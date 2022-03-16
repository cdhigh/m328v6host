/// m328v6数控电子负载上位机
/// 选择一个串口并连接，因为flutter_libserialport经常编译不过，bug不少，丢弃
/// 所以使用此文件对外提供一个统一的串口连接和处理接口
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as sb_android;
import 'common/my_widget_chain.dart';
import 'common/widget_utils.dart';
import 'common/globals.dart';
import 'common/event_bus.dart';
import 'common/iconfont.dart';
import 'models/connection_provider.dart';
import '../i18n/connection.i18n.dart';
import 'uni_serial.dart';


class ConnectionPage extends ConsumerStatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionPage> {
  final _uniSerial = UniSerial();
  var _availablePorts = <String>[];
  final _baudCtrllers = <String, TextEditingController>{};
  late final sb_android.FlutterBluetoothSerial _bluetooth;
  bool? _bluetoothIsOn;
  sb_android.BluetoothState? _prevBluetoothIson;
  Timer? _timerForUpdateBtState;

  @override
  void initState() {
    super.initState();
    _bluetooth = sb_android.FlutterBluetoothSerial.instance;
    //定期刷新蓝牙状态
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      _timerForUpdateBtState = Timer.periodic(const Duration(seconds: 3), updateBluetoothState);
    }
    Future.delayed(const Duration(milliseconds: 500)).then(requestPermission); //延时确认权限并初始化端口列表
  }

  ///初始化端口列表
  void initPorts([_]) async {
    _availablePorts = await _uniSerial.getAvailablePortNames();
    setState(() {
      for (final d in _availablePorts) {
        _baudCtrllers[d] = TextEditingController(text: Global.lastBaudRate.toString());
      }
    });
  }

  @override
  void dispose() {
    _timerForUpdateBtState?.cancel();
    _baudCtrllers.forEach((key, value) {value.dispose();});
    _baudCtrllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? actions;

    //在标题栏上显示当前蓝牙开关状态
    if ((_bluetoothIsOn != null) && (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia)) {
      if (_bluetoothIsOn!) {
        actions = <Widget>[IconButton(onPressed: requestCloseBT, icon: const Icon(Icons.bluetooth))];
      } else {
        actions = <Widget>[IconButton(onPressed: requestOpenBT, icon: const Icon(Icons.bluetooth_disabled))];
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Connection'.i18n), actions: actions),
      body: buildMainList(context),
    );
  }

  ///更新蓝牙状态
  void updateBluetoothState([_]) async {
    final btState = await _bluetooth.state;
    if (_prevBluetoothIson != btState) {
      _prevBluetoothIson = btState;
      initPorts();
    }

    if ((btState == sb_android.BluetoothState.STATE_ON) || (btState == sb_android.BluetoothState.STATE_BLE_ON)) {
      setState(() {_bluetoothIsOn = true;});
    } else {
      setState(() {_bluetoothIsOn = false;});
    }
  }

  ///申请开启蓝牙
  void requestOpenBT() async {
    await _bluetooth.requestEnable();
    updateBluetoothState();
  }

  ///申请关闭蓝牙
  void requestCloseBT() async {
    await _bluetooth.requestDisable();
    updateBluetoothState();
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    List<Widget> list = [Row(children: [Expanded(child: Text("Available devices".i18n)), IconButton(icon: const Icon(Icons.refresh), onPressed: initPorts,)])];
    
    for (final name in _availablePorts) {
      final desc = _uniSerial.getDesc(name);
      final portType = _uniSerial.getPortType(name);
      list.add(ExpansionTile(title: Text((desc != "") ? "$name [$desc]" : name),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: (_availablePorts.length == 1),
        leading: _serialTypeIcon(portType),
        children: <Widget>[
          TextField(
            controller: _baudCtrllers[name],
            //onChanged: (_) {},
            decoration: InputDecoration(
              labelText: "Baud rate".i18n,
              prefixIcon: const Icon(Icons.bolt)
            )),
          Padding(padding: const EdgeInsets.all(20),
            child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 200), child: 
              ElevatedButton(child: Text("Connect".i18n),
                onPressed: () => _doConnection(name, int.tryParse(_baudCtrllers[name]?.text ?? "")),
              ),
            ),
          ),
        ],)
      );
    }

    if (_availablePorts.isEmpty) {
      list.add(Padding(padding: const EdgeInsets.all(20), child: Text("No device".i18n)));
    }
    
    return list.intoListView().intoContainer(padding: const EdgeInsets.all(10.0));
  }

  ///根据不同类型的端口显示不同类型的图标
  Icon _serialTypeIcon(String portType) {
    switch (portType) {
      case "BLUETOOTH":
        return const Icon(Icons.bluetooth, color: Colors.black87);
      case "USB":
        return const Icon(Icons.usb, color: Colors.black87);
      case "WIFI":
        return const Icon(Icons.wifi, color: Colors.black87);
      default:
        return const Icon(IconFont.serialPort, color: Colors.black87);
    }
  }

  ///连接串口
  void _doConnection(String name, int? baudRate) async {
    if ((baudRate == null) || (baudRate < 9600) || (baudRate > 115200)) {
      showToast("Baud rate is invalid".i18n);
      return;
    }

    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    String ret = "";
    try {
      ret = await _uniSerial.open(name, baudRate);
    } catch (e) {
      ret = e.toString();
    }

    if (ret.isNotEmpty) {
      if (ret == "Error") { //没有具体错误信息
        showToast("Open device failed".i18n);
      } else {
        showToast("Open device failed".i18n + "\n$ret");
      }
      return;
    }

    connProvider.setPort(name, baudRate);
    Global.bus.sendBroadcast(EventBus.connectionChanged, arg: "1", sendAsync: false);
    Navigator.of(context).pop();
  }

  ///确认权限，如果没有权限，提示需要申请
  void requestPermission([_]) async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      //蓝牙功能需要定位权限
      var status = await Permission.location.status;
      if (!status.isPermanentlyDenied && !status.isDenied) { //之前没有拒绝过
        await Permission.location.request();
      }

      status = await Permission.bluetoothConnect.status;
      if (!status.isPermanentlyDenied && !status.isDenied) { //之前没有拒绝过
        await Permission.bluetoothConnect.request();
      }
    }

    initPorts(); //刷新串口列表
  }
}
