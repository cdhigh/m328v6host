/// m328v6数控电子负载上位机
/// 主页面ui实现，同时也监控前后台切换事件
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:segment_display/segment_display.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'i18n/main_page.i18n.dart';
import 'common/my_widget_chain.dart';
import 'common/globals.dart';
import 'common/event_bus.dart';
import 'common/serial_resp_buffer.dart';
import 'common/widget_utils.dart';
import 'common/iconfont.dart';
import 'models/connection_provider.dart';
import 'models/running_data_provider.dart';
import 'models/app_info_provider.dart';
import 'models/volt_history_provider.dart';
import 'widgets/main_drawer.dart';
import 'widgets/text_with_superscript.dart';
import 'widgets/bottom_num_keyboard.dart';
import 'widgets/modal_dialogs.dart';
import 'widgets/colored_safe_area.dart';
import 'widgets/curva_chart.dart';
import 'version_update/version_check.dart';
import 'uni_serial.dart';
import 'load_stats_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  AppLifecycleState _lifeState = AppLifecycleState.inactive;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _scrWidth = 100.0; //随便给一个值，保证不为空，会在build里面设置为正确的值
  double _segDisplaySize = 1; //电压电流字体大小随屏幕大小变化，尽量填满水平方向
  var availablePorts = []; //系统中的串口列表
  final _srlBuff = SerialRespBuffer(256); //串口接收缓存
  final _uniSerial = UniSerial();
  bool _prevReceivedOff = true; //上次接收到的报文是否是OFF状态

  //如隔一段时间后没有收到EXTRA数据，重发一次请求额外数据的命令，避免下位机中间复位了
  late final PausableTimer _timerForExtraData;
  var _lastSetLoadOffTime = DateTime.now();
  //如果异常中断并且启用了“自动重连”选项，则每隔5s自动尝试重连一次
  late final PausableTimer _timerForReconnect;
  DateTime _lostConnectionTime = DateTime(2022); //丢失连接时间，自动重连限时5分钟内
  final _loadStats = <LoadStatsModel>[];  //每次放电的统计信息
  Offset _tapPosForCurvaDblTap = const Offset(0.0, 0.0);  //保存曲线区域的鼠标位置，用于弹出菜单
  
  @override
  bool get wantKeepAlive =>true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this); //启动前后台切换监听
    Wakelock.toggle(enable: Global.keepScreenOn == KeepScreenOption.always); //设置是否允许保持屏幕常亮
    Global.bus.addListener(EventBus.connectionChanged, connectionChanged);
    Global.bus.addListener(EventBus.curvaFilterDotNumChanged, curvaFilterDotNumChanged);
    Global.bus.addListener(EventBus.setLoadOnOff, setLoadOnOffReceived);
    Future.delayed(const Duration(seconds: 5), checkNewVersion); //延时确定是否需要检查新版本

    _timerForExtraData = PausableTimer(const Duration(seconds: 3), qeuryVersionPeriodic);
    _timerForExtraData.pause();
    _timerForReconnect = PausableTimer(const Duration(seconds: 1), reconnectPeriodic);
    _timerForReconnect.pause();
  }

  ///如果一段时间后没有收到下位机上报的额外数据包，则重发一次请求额外数据的命令，避免下位机中途复位了
  void qeuryVersionPeriodic() {
    final load = ref.read<ConnectionProvider>(Global.connectionProvider).load;
    load.requestExtraData();
    Future.delayed(const Duration(milliseconds: 150), load.queryVersion);
    if (Global.autoSynchronizeTime) {
      Future.delayed(const Duration(milliseconds: 300), load.synchronizeTime);
    }
  }

  //如果异常中断并且启用了“自动重连”选项，则每隔5s自动尝试重连一次
  void reconnectPeriodic() async {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    final lostSeconds = DateTime.now().difference(_lostConnectionTime).inSeconds;
    if (connProvider.name.isNotEmpty || (lostSeconds > (5 * 60))) { //重连成功或超时5分钟，不需要再执行
      return;
    }

    final name = Global.lastSerialPort;
    final baudRate = Global.lastBaudRate;
    if (name.isEmpty || (baudRate < 9600) || (baudRate > 115200)) {
      return;
    }

    String ret = "";
    try {
      ret = await _uniSerial.open(name, baudRate);
    } catch (e) {
      ret = e.toString();
    }

    if (ret.isEmpty) { //如果重连成功
      connProvider.setPort(name, baudRate);
      Global.bus.sendBroadcast(EventBus.connectionChanged, arg: "1", sendAsync: false);
    } else { //1s后继续重试
      _timerForReconnect..reset()..start();
    }
  }

  ///确定是否需要检查新版本，如果有新版本，提示用户
  void checkNewVersion([_]) {
    if (Global.checkUpdateFrequency == 0) {
      return;
    }

    final now = DateTime.now();
    final days = now.difference(Global.lastCheckUpdateTime).inDays;
    if (days >= Global.checkUpdateFrequency) {
      checkUpdate(silent: true);
    }
  }

  @override
  void dispose() {
    _timerForExtraData.cancel();
    _timerForReconnect.cancel();
    Global.bus.removeListener(EventBus.connectionChanged, connectionChanged);
    Global.bus.removeListener(EventBus.curvaFilterDotNumChanged, curvaFilterDotNumChanged);
    Global.bus.removeListener(EventBus.setLoadOnOff, setLoadOnOffReceived);
    Wakelock.disable();
    WidgetsBinding.instance?.removeObserver(this);
    ref.read<ConnectionProvider>(Global.connectionProvider).closePort();
    super.dispose();
  }

  ///监控前后台切换
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_lifeState == state) {
      return;
    }

    _lifeState = state;
    if (state == AppLifecycleState.resumed) { //切换到前台
      
    } else if (state == AppLifecycleState.paused) { //切换到后台
      Global.lastPaused = DateTime.now();
    }
  }

  ///连接状态变化的事件
  void connectionChanged(String isConnect) {
    if (mounted) {
      final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
      _timerForReconnect.pause();
      
      if (isConnect == "1") { //连接
        //注册监听函数
        connProvider.serial.registerListenFunction(newSrlDataReceived);

        //连接后马上查询下位机版本号，请求上报额外数据
        Future.delayed(const Duration(milliseconds: 150), connProvider.load.queryVersion);
        Future.delayed(const Duration(milliseconds: 300), connProvider.load.requestExtraData);
        if (Global.autoSynchronizeTime) {
          Future.delayed(const Duration(milliseconds: 500), connProvider.load.synchronizeTime);
        }
        _timerForExtraData..reset()..start();
      } else { //断开连接
        final rdProvider = ref.read<RunningDataProvider>(Global.runningDataProvider);
        connProvider.closePort();
        rdProvider.reset();
        _timerForExtraData.pause();

        //-1表示异常中断，如果启用“自动重连”，则启动重连定时器
        if ((isConnect == "-1") && Global.autoReconnect) {
          _lostConnectionTime = DateTime.now();
          _timerForReconnect..reset()..start();
        } else if (Global.keepScreenOn != KeepScreenOption.always) { //关闭屏幕常亮
          Wakelock.disable();
        }
      }
      _srlBuff.reset();  //答复缓冲区清空
      setState((){});
    }
  }

  ///平滑点数有变化，清空缓冲区内的点数滤波器
  void curvaFilterDotNumChanged([_]) {
    if (mounted) {
      final vhProvider = ref.read<VoltHistoryProvider>(Global.vHistoryProvider);
      vhProvider.resetFilter();
    }
  }

  ///接收到打开关闭放电的消息，保存现在的时间，避免弹出放电停止提示
  void setLoadOnOffReceived(String isOn) {
    if (mounted) {
      if (isOn == "0") {
        _lastSetLoadOffTime = DateTime.now();
      }
    }
  }

  ///有新的串口数据到达
  void newSrlDataReceived(Uint8List data) {
    //debugPrint('received: $data');
    _srlBuff.addAll(data);
    if (_srlBuff.packageCount > 0) { //接收到完整的回复包，开始处理数据
      var bag = _srlBuff.getOnePackage();
      while (bag.isNotEmpty) {
        handleSrlPackage(bag);
        bag = _srlBuff.getOnePackage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final orientation = MediaQuery.of(context).orientation;
    
    _scrWidth = MediaQuery.of(context).size.width;
    //_viFontSize = 0.11 * _scrWidth;  //更新VI显示字体
    _segDisplaySize = _scrWidth / 100; //通过宽度计算数码管的大小
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    final portName = connProvider.name;
    var needAppBar = true;  //竖屏或桌面版本才绘制标题栏
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      needAppBar = (orientation == Orientation.portrait);
    }
    
    return ColoredSafeArea(child: Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false, //避免不必要的重绘
      drawer: const Drawer(child: MainDrawer()),
      appBar: needAppBar ? AppBar(
        leading: Builder(builder: (context) {
          return InkWell(child: const Icon(Icons.menu), onTap: ()=>_scaffoldKey.currentState?.openDrawer());
          }),
        title: Text(((portName == "") ? "Unconnected".i18n : "Connected".i18n)),
        titleSpacing: 1.0,
        actions: buildAppBarActions((portName != ""), rdProvider.running),
      ) : null,
      body: (orientation == Orientation.portrait) ? portraitUi(context) : landscapeUi(context),
    ));
  }

  ///构建AppBar右侧的按钮
  List<Widget> buildAppBarActions(bool isConnected, bool isRunning) {
    return <Widget>[
      Padding(padding: const EdgeInsets.only(right: 20), child:
        IconButton(icon: Icon(isConnected ? IconFont.disconnect : IconFont.connect, color: Colors.white), 
        tooltip: isConnected ? "Disconnect".i18n : "Connect".i18n,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        iconSize: 40,
        onPressed: () {
          if (isConnected) {
            Global.bus.sendBroadcast(EventBus.connectionChanged, arg: "0", sendAsync: false);
          } else {
            Navigator.pushNamed(context, "/connection");
          }},
      ),),
      
      //开始放电和结束放电的按钮
      Padding(padding: const EdgeInsets.only(right: 15), child: FlutterSwitch(
        disabled: !isConnected,
        width: 80.0,
        height: 35.0,
        valueFontSize: 18.0,
        toggleSize: 30.0,
        borderRadius: 18,
        value: isRunning,
        activeColor: Colors.green,
        inactiveColor: Colors.red[600]!,
        activeTextColor: Colors.white,
        inactiveTextColor: Colors.white,
        activeText: "ON",
        inactiveText: "OFF",
        showOnOff: true,
        switchBorder: Border.all(color: Colors.white60, width: 1.0,),
        onToggle:onTapAppBarSwitch,),),
    ];
  }

  ///构建主页中间显示的竖屏界面
  Widget portraitUi(BuildContext context) {
    final appInfo = ref.watch<AppInfoProvider>(Global.infoProvider);
    return Container(padding: const EdgeInsets.all(10.0), 
      color: Global.isDarkMode ? Colors.transparent : appInfo.homePageBackgroundColor,
      child: ListView(children: [
        GestureDetector(child: const CurvaChart(), 
          onDoubleTap: onDoubleTapCurvaChart,
          onDoubleTapDown: (TapDownDetails details) {_tapPosForCurvaDblTap = details.globalPosition;},),
        buildVISetDisplay(context),
        buildVIDisplay(context),
        buildOtherDisplayData(context),
        const SizedBox(height: 50),
      ]),
    );
  }

  ///构建竖屏的电压电流设置值显示
  Widget buildVISetDisplay(BuildContext context) {
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [
      GestureDetector(onDoubleTap: onDoubleTapVset, child: SevenSegmentWithSuperText(
        title: "V Set".i18n + " (V)",
        value: rdProvider.vSet.toStringAsFixed(3).padLeft(6),
        size: _segDisplaySize,
        color: Colors.red,
      ),),
      Expanded(child: Container()),
      GestureDetector(onDoubleTap: onDoubleTapIset, child: SevenSegmentWithSuperText(
        title: "I Set".i18n + " (A)",
        value: rdProvider.iSet.toStringAsFixed(3).padLeft(6),
        size: _segDisplaySize,
        color: Colors.blue,
      ),),
    ],),);
  }

  ///构建竖屏的实时电压电流显示
  Widget buildVIDisplay(BuildContext context) {
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [
      SevenSegmentWithSuperText(
        title: "V".i18n + " (V)",
        value: rdProvider.vNow.toStringAsFixed(3).padLeft(6),
        size: _segDisplaySize,
        color: Colors.red,
      ),
      Expanded(child: Container()),
      SevenSegmentWithSuperText(
        title: "I".i18n + " (A)",
        value: rdProvider.iNow.toStringAsFixed(3).padLeft(6),
        size: _segDisplaySize,
        color: Colors.blue,
      ),
    ],),);
  }

  ///构建竖屏的其他显示的数据
  Widget buildOtherDisplayData(BuildContext context) {
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final mode = rdProvider.mode;

    return Padding(padding: const EdgeInsets.only(left: 10, top: 5, right: 10), child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //功率和模式（包括参数）
        Row(children: [
          SevenSegmentWithSuperText(
            title: "Power".i18n + " (W)",
            value: rdProvider.powerIn.toStringAsFixed(2).padLeft(6),
            size: _segDisplaySize,
            color: Colors.amber,
          ),
          Expanded(child: Container()),
          if (mode == "CR")
          SevenSegmentWithSuperText(
            title: "CR".i18n + " (R)",
            value: rdProvider.rSet.toStringAsFixed(2).padLeft(6),
            size: _segDisplaySize,
            color: Colors.amber,
          ),
          if (mode == "CP")
          SevenSegmentWithSuperText(
            title: "CP".i18n + " (W)",
            value: rdProvider.pSet.toStringAsFixed(2).padLeft(6),
            size: _segDisplaySize,
            color: Colors.amber,
          ),
        ]),
        //容量和能量
        Row(children: [
          GestureDetector(onDoubleTap: onDoubleTapAh,
            child: SevenSegmentWithSuperText(
              title: "Capacity".i18n + " (Ah)",
              value: rdProvider.ah.toStringAsFixed(3).padLeft(6),
              size: _segDisplaySize,
              color: Colors.cyan,
          )),
          Expanded(child: Container()),
          SevenSegmentWithSuperText(
            title: "Energy".i18n + " (Wh)",
            value: rdProvider.wh.toStringAsFixed(2).padLeft(6),
            size: _segDisplaySize,
            color: Colors.cyan,
          ),
        ]),
        //直流内阻和交流内阻
        Row(children: [
          SevenSegmentWithSuperText(
            title: "Rd".i18n + " (R)",
            value: rdProvider.rd.toStringAsFixed(3).padLeft(6),
            size: _segDisplaySize,
            color: Colors.cyan,
          ),
          Expanded(child: Container()),
          SevenSegmentWithSuperText(
            title: "Ra".i18n + " (R)",
            value: rdProvider.ra.toStringAsFixed(3).padLeft(6),
            size: _segDisplaySize,
            color: Colors.cyan,
          ),
        ]),

        //散热器温度和主板温度
        Row(children: [
          SevenSegmentWithSuperText(
            title: "Heat sink".i18n + " (C)",
            value: rdProvider.temperature1.toString().padLeft(2),
            size: _segDisplaySize,
            color: Colors.green,
          ),
          const SizedBox(width: 30),
          SevenSegmentWithSuperText(
            title: "Board".i18n + " (C)",
            value: rdProvider.temperature2.toString().padLeft(2),
            size: _segDisplaySize,
            color: Colors.green,
          ),
        ]),
      ],));
  }

  ///构建主页中间显示的竖屏的界面
  Widget landscapeUi(BuildContext context) {
    final appInfo = ref.watch<AppInfoProvider>(Global.infoProvider);
    return Container(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), 
      color: Global.isDarkMode ? Colors.transparent : appInfo.homePageBackgroundColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(child: CurvaChartLandscape(scrWidth: _scrWidth), 
            onDoubleTap: onDoubleTapCurvaChart,
            onDoubleTapDown: (TapDownDetails details) {_tapPosForCurvaDblTap = details.globalPosition;},),
          SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: buildRawDataDisplayLandscape(context),
          ),),
      ]),
    );
  }

  ///构建横屏的各种数据显示
  List<Widget> buildRawDataDisplayLandscape(BuildContext context) {
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final mode = rdProvider.mode;

    return <Widget>[
      //设置电压
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("V Set".i18n, style: const TextStyle(color: Colors.white))),
        GestureDetector(child: SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.vSet.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.red,
            disabledColor: Colors.red.withOpacity(0.15),),),
          onDoubleTap: onDoubleTapVset,),
      ])),
      //设置电流
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("I Set".i18n, style: const TextStyle(color: Colors.white))),
        GestureDetector(child: SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.iSet.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.blue,
            disabledColor: Colors.blue.withOpacity(0.15),),),
          onDoubleTap: onDoubleTapIset,),
      ])),
      //实时电压
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("V".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.vNow.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.red,
            disabledColor: Colors.red.withOpacity(0.15),),
      )])),
      //实时电流
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("I".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.iNow.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.blue,
            disabledColor: Colors.blue.withOpacity(0.15),),
      )])),
      //功率
      Padding(padding: const EdgeInsets.only(top: 5, bottom: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("Power".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.powerIn.toStringAsFixed(2).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.amber,
            disabledColor: Colors.amber.withOpacity(0.15),),
      )])),
      //容量
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("Capacity".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.ah.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.cyan,
            disabledColor: Colors.cyan.withOpacity(0.15),),)
        .intoGestureDetector(onDoubleTap: onDoubleTapAh),
      ])),
      //能量
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("Energy".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.wh.toStringAsFixed(2).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.cyan,
            disabledColor: Colors.cyan.withOpacity(0.15),),
      )])),
      //直流内阻
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("Rd".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.rd.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.cyan,
            disabledColor: Colors.cyan.withOpacity(0.15),),
      )])),
      //交流内阻
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text("Ra".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.ra.toStringAsFixed(3).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.cyan,
            disabledColor: Colors.cyan.withOpacity(0.15),),
      )])),
      //模式
      if (mode != "CC")
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 20), child: Text(mode.i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: (mode == "CR") ? rdProvider.rSet.toStringAsFixed(2).padLeft(6) : rdProvider.pSet.toStringAsFixed(2).padLeft(6),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.amber,
            disabledColor: Colors.cyan.withOpacity(0.15),),
      )])),
      
      //散热器温度
      Padding(padding: const EdgeInsets.only(top: 5, bottom: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 25), child: Text("Heat sink".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.temperature1.toString().padLeft(5),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.green,
            disabledColor: Colors.green.withOpacity(0.05),),
      )])),
      //主板温度
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Padding(padding: const EdgeInsets.only(right: 25), child: Text("Board".i18n, style: const TextStyle(color: Colors.white))),
        SevenSegmentDisplay(size: 3, backgroundColor: Colors.transparent,
          value: rdProvider.temperature2.toString().padLeft(5),
          segmentStyle: DefaultSegmentStyle(enabledColor: Colors.green,
            disabledColor: Colors.green.withOpacity(0.05),),
      )])),
    ];
  }

  ///双击截止电压后弹出小键盘，用于设置新的截止电压
  void onDoubleTapVset() async {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    final rdProvider = ref.read<RunningDataProvider>(Global.runningDataProvider);
    if (connProvider.name != "") {
      final newvSet = await showNumKeyboardDialog(context: context, doubleNumber: rdProvider.vSet);
      if (newvSet != null) {
        if (newvSet.toDouble() > 65.0) { //最高65V
          showToast("The voltage must be less than 65 volts".i18n);
        } else if (newvSet.toDouble() != rdProvider.vSet) {
          final load = connProvider.load;
          setState(() {load.setV(newvSet.toDouble()); rdProvider.vSet = newvSet.toDouble();});
        }
      }
    }
  }

  ///双击设置的电流后弹出小键盘，用于设置新的放电电流
  void onDoubleTapIset() async {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    final rdProvider = ref.read<RunningDataProvider>(Global.runningDataProvider);
    if (connProvider.name != "") {
      final newiSet = await showNumKeyboardDialog(context: context, doubleNumber: rdProvider.iSet);
      if (newiSet != null) {
        if (newiSet.toDouble() > 15.0) { //最高15A
          showToast("The current must be less than 15A".i18n);
        } else if (newiSet.toDouble() != rdProvider.iSet) {
          final load = connProvider.load;
          setState(() {load.setI(newiSet.toDouble()); rdProvider.iSet = newiSet.toDouble();});
        }
      }
    }
  }

  ///双击容量数码管后弹出提问，是否需要清除容量
  void onDoubleTapAh() async {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    if (connProvider.name != "") {
      final bool? ok = await showOkCancelAlertDialog(context: context, title: "Confirm".i18n, content: Text("Clear Ah?".i18n));
      if (ok == true) {
        connProvider.load.clearAh();
      }
    }
  }

  ///双击曲线区域弹出菜单
  void onDoubleTapCurvaChart() async {
    final overlay = Overlay.of(context)?.context.findRenderObject();
    final size = Overlay.of(context)?.context.size;
    if ((overlay == null) || (size == null)) {
      return;
    }

    await showMenu(context: context,
      elevation: 8.0,
      position: RelativeRect.fromRect(
          _tapPosForCurvaDblTap & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(child: Text("Clear curva data".i18n),
          onTap: () {ref.watch<VoltHistoryProvider>(Global.vHistoryProvider).clear();}),
        PopupMenuItem(child: Text("Show load stats".i18n),
          enabled: _loadStats.isNotEmpty,
          onTap: () { //菜单本身就是一个页面，所以需要等此页面关闭后才能打开另一个页面，使用 addPostFrameCallback
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              Navigator.pushNamed(context, "/load_stats", 
                arguments: Map<String, List<LoadStatsModel>>.from({"stats": _loadStats}),);
            });
          }),
      ],
    );
  }

  ///点击标题栏上的Switch按钮，询问是否需要打开关闭放电
  void onTapAppBarSwitch(bool isOff) async {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    final txt = isOff ? "Turn on the electronic load?\nRemember to clear Ah, if needed".i18n : "Turn off the electronic load?".i18n;
    final bool? ret = await showOkCancelAlertDialog(context: context, title: "Confirm".i18n, 
      content: Text(txt));
    if (ret == true) {
        connProvider.load.setLoadOn(isOff);
    }
  }

  ///处理下位机发过来的回复包或主动上报包
  void handleSrlPackage(List<int> bag) {
    int size = bag.length;
    //简单判断
    if ((size < 3) || (bag[size - 2] != 0x0d) || (bag.last != 0x0a)) {
      return;
    }
    //debugPrint(String.fromCharCodes(bag));

    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final first5Chars = (size > 5) ? String.fromCharCodes(bag, 0, 5) : "";

    if ((size >= 32) && (first5Chars == "EXTRA")) { //额外数据
      //debugPrint(String.fromCharCodes(bag));
      int? wh;
      int? rSet;
      int? pSet;
      int? vSet = int.tryParse(String.fromCharCodes(bag, 6, 11));
      int? iSet = int.tryParse(String.fromCharCodes(bag, 12, 17));
      int? tempe1 = int.tryParse(String.fromCharCodes(bag, 18, 20));
      int? tempe2 = int.tryParse(String.fromCharCodes(bag, 21, 23));
      String mode = String.fromCharCodes(bag, 24, 26);
      if (mode == "CC") {
        wh = int.tryParse(String.fromCharCodes(bag, 27, 32));
        rSet = 0;
        pSet = 0;
      } else if (mode == "Wh") {
        wh = int.tryParse(String.fromCharCodes(bag, 27, 32));
      } else if (mode == "CR") {
        rSet = int.tryParse(String.fromCharCodes(bag, 27, 32));
        pSet = 0;
      } else if (mode == "CP") {
        pSet = int.tryParse(String.fromCharCodes(bag, 27, 32));
        rSet = 0;
      } else {
        mode = "";
        pSet = 0;
        rSet = 0;
      }

      rdProvider.vSet = (vSet != null) ? (vSet / 1000) : 0.0;
      rdProvider.iSet = (iSet != null) ? (iSet / 1000) : 0.0;
      rdProvider.temperature1 = (tempe1 != null) ? tempe1 : 0;
      rdProvider.temperature2 = (tempe2 != null) ? tempe2 : 0;
      
      if ((mode != "") && (mode != "Wh")) { //Wh是CR/CP模式下专门上报瓦时的标识
        rdProvider.mode = mode;
      }
      if (wh != null) {
        rdProvider.wh = wh / 100; //下位机的单位为10毫瓦时
      }
      if (rSet != null) {
        rdProvider.rSet = rSet / 100; //下位机的单位为10毫欧
      }
      if (pSet != null) {
        rdProvider.pSet = pSet / 100; //下位机的单位为10毫瓦
      }

      if (_loadStats.isNotEmpty) {
        _loadStats.last.initialWh ??= rdProvider.wh;
      }

      rdProvider.notifyDataChanged();

      //每次收到EXTRA数据就复位请求额外数据的定时器
      //只有连续3s没有收到额外数据才重新下发请求命令
      _timerForExtraData..reset()..start();
    } else if (size >= 29) {   //老版本M8V6定义的数据
      //debugPrint(String.fromCharCodes(bag));
      final vhProvider = ref.watch<VoltHistoryProvider>(Global.vHistoryProvider);
      int loadStatus = 0; //1-开始，2-结束

      int? iNow;
      int? vNow = int.tryParse(String.fromCharCodes(bag, 6, 11));
      int? ah = int.tryParse(String.fromCharCodes(bag, 12, 17));
      int? rd = int.tryParse(String.fromCharCodes(bag, 18, 23));
      int? ra = int.tryParse(String.fromCharCodes(bag, 24, 29));
      
      bool isOff = true;
      if (first5Chars != "OFF  ") {
        isOff = false;
        iNow = int.tryParse(first5Chars);
      }

      //从未放电到放电状态，则自动清除原先的曲线数据，如果需要，启用屏幕常亮
      if (_prevReceivedOff && !isOff) {
        vhProvider.clear();
        loadStatus = 1; //标识放电开始，下面的代码会创建一个放电状态容器
        if (Global.keepScreenOn == KeepScreenOption.onWhenDischarge) {
          Wakelock.enable();
        }
      }
      _prevReceivedOff = isOff;

      //从放电状态到未放电状态，如果需要，关闭屏幕常亮
      if (rdProvider.running && isOff) {
        loadStatus = 2; //标识放电结束，下面的代码会保存更新本次放电信息
        if (Global.keepScreenOn != KeepScreenOption.always) {
          Wakelock.disable();
        }

        //如果是正常放电停止，而不是上位机主动停止，则弹出提示条
        //因为手机端横屏时没有AppBar，所以显示一个提示条
        if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
          if (DateTime.now().difference(_lastSetLoadOffTime).inSeconds > 2) {
            if (MediaQuery.of(context).orientation == Orientation.landscape) {
              showNotification("Discharge has ended".i18n);
            }
          }
        }
      }

      rdProvider.running = !isOff;

      if (!isOff && (vNow != null)) { //正在放电状态
        vhProvider.add(vNow / 1000); //添加当前电压到电压历史缓冲区，用于绘制曲线图
      }
      
      iNow ??= 0;
      vNow ??= 0;

      rdProvider.iNow = iNow / 1000;
      rdProvider.vNow = vNow / 1000;

      //功率需要自己计算，下位机没有上报
      rdProvider.powerIn = calP(vNow, iNow);
      
      rdProvider.ah = (ah != null) ? (ah / 1000) : 0.0;
      rdProvider.rd = (rd != null) ? (rd / 1000) : 0.0;
      rdProvider.ra = (ra != null) ? (ra / 1000) : 0.0;

      //放电状态统计信息
      if (loadStatus == 1) { //放电开始
        final lStats = LoadStatsModel(initialV: rdProvider.vNow, initialAh: rdProvider.ah);
        lStats.rd = rdProvider.rd;
        lStats.ra = rdProvider.ra;
        if (_loadStats.length > 16) { //仅保留最近16个记录
          _loadStats.removeAt(0);
        }
        _loadStats.add(lStats); //新增一个统计数据
      } else if (_loadStats.isNotEmpty) {
        final lStats = _loadStats.last;
        if (loadStatus == 2) { //放电结束
          lStats.endV = rdProvider.vNow;
          lStats.endI = rdProvider.iNow;
          lStats.avgV = (lStats.initialV + lStats.endV) / 2;
          lStats.avgI = ((lStats.initialI ?? 0.0) + lStats.endI) / 2;
          lStats.ah = lStats.totalAh - lStats.initialAh;
          lStats.wh = lStats.totalWh - (lStats.initialWh ?? 0.0);
          lStats.temperature1 = rdProvider.temperature1;
          lStats.temperature2 = rdProvider.temperature2;
          lStats.endTime = DateTime.now();
          lStats.loadTime = lStats.endTime!.difference(lStats.startTime);
        } else {
          if (rdProvider.iNow > 0.0) {
            lStats.initialI ??= rdProvider.iNow;
          }
          if (rdProvider.rd > lStats.rd) {
            lStats.rd = rdProvider.rd;
          }
          if (rdProvider.ra > lStats.ra) {
            lStats.ra = rdProvider.ra;
          }
          lStats.totalAh = rdProvider.ah;
          lStats.totalWh = rdProvider.wh;
          lStats.ah = lStats.totalAh - lStats.initialAh;
          lStats.wh = lStats.totalWh - (lStats.initialWh ?? 0.0);
          lStats.temperature1 = rdProvider.temperature1;
          lStats.temperature2 = rdProvider.temperature2;
          if (lStats.mode.isEmpty && rdProvider.mode.isNotEmpty) {
            lStats.mode = rdProvider.mode;
            if (lStats.mode == "CR") {
              lStats.rSet = rdProvider.rSet;
            } else if (lStats.mode == "CP") {
              lStats.pSet = rdProvider.pSet;
            }
          }
        }
      }
      
      rdProvider.notifyDataChanged();
    } else if ((size >= 13) && (bag[6] == ",".codeUnitAt(0))) { //VIL数据(实时电压电流LOG)
      rdProvider.vNow = double.tryParse(String.fromCharCodes(bag, 0, 6)) ?? 0.0;
      rdProvider.iNow = double.tryParse(String.fromCharCodes(bag, 7, 13)) ?? 0.0;
      rdProvider.notifyDataChanged();
    } else if (bag.first == ">".codeUnitAt(0)) { //其他回复命令
      final respCmd = bag[1];
      if (respCmd == 'b'.codeUnitAt(0)) { //查询版本的返回命令
        if (size >= 13) {
          rdProvider.ver = String.fromCharCodes(bag.sublist(2, 7)); //V6.30
          rdProvider.buildDate = String.fromCharCodes(bag.sublist(7, 13)); //220214
          rdProvider.notifyDataChanged();
        }
      } else if (respCmd == 'D'.codeUnitAt(0)) { //预约开关负载的返回命令
        if (size >= 9) {
          final subCmd = String.fromCharCodes(bag, 2, 4);
          final value = int.tryParse(String.fromCharCodes(bag, 4, 9));
          if (value != null) {
            switch (subCmd) {
              case "QO": //DQO00000: 预约开时间
                rdProvider.delayOn = value;
                break;
              case "QF": //DQF00000: 预约关时间
                rdProvider.delayOff = value;
                break;
              case "QP": //DQP00000: 周期开时间
                rdProvider.periodOn = value;
                break;
              case "QQ": //DQQ00000: 周期关时间
                rdProvider.periodOff = value;
                break;
            }
            rdProvider.notifyDataChanged();
          }
        }
      } else if (respCmd == "V".codeUnitAt(0)) { //设置/查询当前电压的返回包
        if (size >= 7) {
          final value = int.tryParse(String.fromCharCodes(bag, 2, 7));
          if ((value != null) && (value >= 0) && (value <= 65000)) {
            rdProvider.vNow = value / 1000;
            rdProvider.powerIn = calP(value, (rdProvider.iNow * 1000).toInt());
            rdProvider.notifyDataChanged();
            //debugPrint("Response of V: ${rdProvider.vNow}, power: ${rdProvider.powerIn}, i: ${rdProvider.iNow}");
          }
        }
      } else if (respCmd == "I".codeUnitAt(0)) {//设置/查询当前电流的返回包
        if (size >= 7) {
          final value = int.tryParse(String.fromCharCodes(bag, 2, 7));
          if ((value != null) && (value >= 0) && (value <= 15000)) {
            rdProvider.iNow = value / 1000;
            rdProvider.powerIn = calP((rdProvider.vNow * 1000).toInt(), value);
            rdProvider.notifyDataChanged();
            //debugPrint("Response of I: ${rdProvider.iNow}, power: ${rdProvider.powerIn}, i: ${rdProvider.iNow}");
          }
        }
      }
    } else if (bag.first == "?".codeUnitAt(0)) { //电压电流的返回
      final respCmd = bag[1];
      if (respCmd == "V".codeUnitAt(0)) { //设置/查询当前电压的返回包
        if (size >= 7) {
          final value = int.tryParse(String.fromCharCodes(bag, 2, 7));
          if ((value != null) && (value >= 0) && (value <= 65000)) {
            rdProvider.vNow = value / 1000;
            rdProvider.powerIn = calP(value, (rdProvider.iNow * 1000).toInt());
            rdProvider.notifyDataChanged();
          }
        }
      } else if (respCmd == "I".codeUnitAt(0)) {//设置/查询当前电流的返回包
        if (size >= 7) {
          final value = int.tryParse(String.fromCharCodes(bag, 2, 7));
          if ((value != null) && (value >= 0) && (value <= 15000)) {
            rdProvider.iNow = value / 1000;
            rdProvider.powerIn = calP((rdProvider.vNow * 1000).toInt(), value);
            rdProvider.notifyDataChanged();
          }
        }
      }
    }
  }

  ///使用和下位机一样的计算功率算法，保证和下位机显示一致(因为下位机仅使用整数运算)
  ///最后的除以100是因为下位机使用10毫瓦为单位
  /// 2022-03-22 配置下位机修改，不需要复杂的计算公式了
  double calP(int v, int i) {
    //return (((v ~/ 10)  * i).toInt() ~/ 1000) / 100;
    return ((v * i) ~/ 10000) / 100;
  }
}
