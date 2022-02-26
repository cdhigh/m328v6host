/// m328v6数控电子负载上位机
/// 处理预约开关机和周期开关机
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'i18n/delay_period_on_off.i18n.dart';
import 'widgets/modal_dialogs.dart';
import 'common/globals.dart';
import 'common/common_utils.dart';
import 'common/widget_utils.dart';
import 'common/when.dart';
import 'models/connection_provider.dart';
import 'models/running_data_provider.dart';

class DelayPeriodOnOffPage extends ConsumerStatefulWidget {
  const DelayPeriodOnOffPage({Key? key}) : super(key: key);
  @override
  _DelayPeriodOnOffPageState createState() => _DelayPeriodOnOffPageState();
}

class _DelayPeriodOnOffPageState extends ConsumerState<DelayPeriodOnOffPage> {
  late final Timer _timerForData; //在此界面时定时查询设备的预约时间/周期时间
  final _delayOnHourCtrl = TextEditingController(text: "00");
  final _delayOnMinuteCtrl = TextEditingController(text: "00");
  final _delayOnSecondCtrl = TextEditingController(text: "00");
  final _delayOffHourCtrl = TextEditingController(text: "00");
  final _delayOffMinuteCtrl = TextEditingController(text: "00");
  final _delayOffSecondCtrl = TextEditingController(text: "00");
  final _periodOnHourCtrl = TextEditingController(text: "00");
  final _periodOnMinuteCtrl = TextEditingController(text: "00");
  final _periodOnSecondCtrl = TextEditingController(text: "00");
  final _periodOffHourCtrl = TextEditingController(text: "00");
  final _periodOffMinuteCtrl = TextEditingController(text: "00");
  final _periodOffSecondCtrl = TextEditingController(text: "00");

  @override
  void initState() {
    super.initState();

    //在此界面时定时查询设备的预约时间/周期时间
    _timerForData = Timer.periodic(const Duration(seconds: 1), (timer) {
      final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
      load.queryDelayOn();
      Future.delayed(const Duration(milliseconds: 100)).then((_) => load.queryDelayOff());
      Future.delayed(const Duration(milliseconds: 200)).then((_) => load.queryPeriodOn());
      Future.delayed(const Duration(milliseconds: 300)).then((_) => load.queryPeriodOff());
    });
  }

  @override
  void dispose() {
    _timerForData.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delay&Period'.i18n)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    return Container(padding: const EdgeInsets.all(10.0), child: ListView(children: [
      //当前状态区段
      ExpansionTile(title: Text("Current Status".i18n), 
        leading: const Icon(Icons.autorenew),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: true,
        children: [
          Padding(padding: const EdgeInsets.all(10), child: 
            Text("Delay on   : %s".i18n.fill([readableSeconds(rdProvider.delayOn)])),),
          Padding(padding: const EdgeInsets.all(10), child: 
            Text("Delay off  : %s".i18n.fill([readableSeconds(rdProvider.delayOff)])),),
          const Divider(),
          Padding(padding: const EdgeInsets.all(10), child: 
            Text("Period on  : %s".i18n.fill([readableSeconds(rdProvider.periodOn)])),),
          Padding(padding: const EdgeInsets.all(10), child: 
            Text("Period off : %s".i18n.fill([readableSeconds(rdProvider.periodOff)])),),
      ],),
      //设置预约开机
      ExpansionTile(title: Text("set Delay on".i18n), 
        leading: const Icon(Icons.timer),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [ //时分秒各一个TextField
          Padding(padding: const EdgeInsets.all(10), child: 
            Row(children:[
              SizedBox(width: 30, child: TextField(controller: _delayOnHourCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _delayOnMinuteCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _delayOnSecondCtrl, textAlign: TextAlign.center)),
              Padding(padding: const EdgeInsets.only(left: 5), child: IconButton(icon:
                const Icon(Icons.timer_outlined), onPressed: () => selectDelayOnTime(context))),
              Expanded(child: Container()),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: setDelayOn, 
              child: Text("Set".i18n)),
          ),
      ],),
      //设置预约关机
      ExpansionTile(title: Text("set Delay off".i18n), 
        leading: const Icon(Icons.timer_off),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(10), child: 
            Row(children:[
              SizedBox(width: 30, child: TextField(controller: _delayOffHourCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _delayOffMinuteCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _delayOffSecondCtrl, textAlign: TextAlign.center)),
              Padding(padding: const EdgeInsets.only(left: 5), child: IconButton(icon:
                const Icon(Icons.timer_outlined), onPressed: () => selectDelayOffTime(context))),
              Expanded(child: Container()),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: setDelayOff, 
              child: Text("Set".i18n)),
          ),
      ],),
      //设置周期开关机
      ExpansionTile(title: Text("set Period On/Off".i18n), 
        leading: const Icon(Icons.av_timer),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(10), child: 
            Row(children:[
              ConstrainedBox(constraints: const BoxConstraints(minWidth: 100), child:
                Text("On time".i18n)),
              SizedBox(width: 30, child: TextField(controller: _periodOnHourCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _periodOnMinuteCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _periodOnSecondCtrl, textAlign: TextAlign.center)),
              Padding(padding: const EdgeInsets.only(left: 5), child: IconButton(icon:
                const Icon(Icons.timer_outlined), onPressed: () => selectPeriodOnTime(context))),
              Expanded(child: Container()),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(10), child: 
            Row(children:[
              ConstrainedBox(constraints: const BoxConstraints(minWidth: 100), child:
                Text("Off time".i18n)),
              SizedBox(width: 30, child: TextField(controller: _periodOffHourCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _periodOffMinuteCtrl, textAlign: TextAlign.center)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text(":")),
              SizedBox(width: 30, child: TextField(controller: _periodOffSecondCtrl, textAlign: TextAlign.center)),
              Padding(padding: const EdgeInsets.only(left: 5), child: IconButton(icon:
                const Icon(Icons.timer_outlined), onPressed: () => selectPeriodOffTime(context))),
              Expanded(child: Container()),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: setPeriodOnOff, 
              child: Text("Set".i18n)),
          ),
      ],),
    ]));
  }

  ///设置预约开时间
  void setDelayOn() async {
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    final seconds = totalSeconds(getDelayOnTime());
    if (seconds > 0xffff) {
      showSimpleSnackBar(context, "Time must be less than 18 hours".i18n);
      return;
    }

    load.setDelayOn(seconds);
    await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set Delay On successfully".i18n));
  }

  ///设置预约关时间
  void setDelayOff() async {
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    final seconds = totalSeconds(getDelayOffTime());
    if (seconds > 0xffff) {
      showSimpleSnackBar(context, "Time must be less than 18 hours".i18n);
      return;
    }

    load.setDelayOff(seconds);
    await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set Delay Off successfully".i18n));
  }

  ///设置周期开关时间
  void setPeriodOnOff() async {
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    final onSeconds = totalSeconds(getPeriodOnTime());
    final offSeconds = totalSeconds(getPeriodOffTime());
    if ((onSeconds > 0xffff) || (offSeconds > 0xffff)) {
      showSimpleSnackBar(context, "Time must be less than 18 hours".i18n);
      return;
    }

    load.setPeriodOnOff(onSeconds, offSeconds);
    await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set Period On/Off successfully".i18n));
  }

  ///获取当前选择的延时开通时间
  DateTime getDelayOnTime() {
    final timeStr = "${_delayOnHourCtrl.text}:${_delayOnMinuteCtrl.text}:${_delayOnSecondCtrl.text}";
    return When.parseTimeOnly(timeStr);
  }

  ///获取当前选择的延时关闭时间
  DateTime getDelayOffTime() {
    final timeStr = "${_delayOffHourCtrl.text}:${_delayOffMinuteCtrl.text}:${_delayOffSecondCtrl.text}";
    return When.parseTimeOnly(timeStr);
  }

  ///获取当前选择的周期开通时间
  DateTime getPeriodOnTime() {
    final timeStr = "${_periodOnHourCtrl.text}:${_periodOnMinuteCtrl.text}:${_periodOnSecondCtrl.text}";
    return When.parseTimeOnly(timeStr);
  }

  ///获取当前选择的周期关闭时间
  DateTime getPeriodOffTime() {
    final timeStr = "${_periodOffHourCtrl.text}:${_periodOffMinuteCtrl.text}:${_periodOffSecondCtrl.text}";
    return When.parseTimeOnly(timeStr);
  }

  ///打开一个时钟界面，选择延时开通时间
  void selectDelayOnTime(BuildContext context) async {
    final picked = await selectTime(context, getDelayOnTime());
    if (picked != null) {
      _delayOnHourCtrl.text = picked.hour.toString().padLeft(2, '0');
      _delayOnMinuteCtrl.text = picked.minute.toString().padLeft(2, '0');
      _delayOnSecondCtrl.text = '00';
    }
  }

  ///打开一个时钟界面，选择延时关闭时间
  void selectDelayOffTime(BuildContext context) async {
    final picked = await selectTime(context, getDelayOffTime());
    if (picked != null) {
      _delayOffHourCtrl.text = picked.hour.toString().padLeft(2, '0');
      _delayOffMinuteCtrl.text = picked.minute.toString().padLeft(2, '0');
      _delayOffSecondCtrl.text = '00';
    }
  }

  ///打开一个时钟界面，选择周期开通时间
  void selectPeriodOnTime(BuildContext context) async {
    final picked = await selectTime(context, getPeriodOnTime());
    if (picked != null) {
      _periodOnHourCtrl.text = picked.hour.toString().padLeft(2, '0');
      _periodOnMinuteCtrl.text = picked.minute.toString().padLeft(2, '0');
      _periodOnSecondCtrl.text = '00';
    }
  }

  ///打开一个时钟界面，选择周期关闭时间
  void selectPeriodOffTime(BuildContext context) async {
    final picked = await selectTime(context, getPeriodOffTime());
    if (picked != null) {
      _periodOffHourCtrl.text = picked.hour.toString().padLeft(2, '0');
      _periodOffMinuteCtrl.text = picked.minute.toString().padLeft(2, '0');
      _periodOffSecondCtrl.text = '00';
    }
  }
  
  ///打开时间选择界面，选择一个时间[使用flutter的showTimePicker]
  Future<TimeOfDay?> selectTime(BuildContext context, DateTime initialTime) async {
    final initial = TimeOfDay.fromDateTime(initialTime);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if ((picked != null) && (picked != initial)){
      if ((picked.hour * 3600 + picked.minute * 60) > 0xffff) { //要16位整数能保存
        showSimpleSnackBar(context, "Time must be less than 18 hours".i18n);
        return null;
      } else {
        return picked;
      }
    }
    return null;
  }

  //判断一个时间是否能使用16位整数保存
  bool timeIsLess18Hours(DateTime t) {
    return (totalSeconds(t) < 0xffff);
  }

  //将一个时间转换为秒为单位的整数
  int totalSeconds(DateTime t) {
    return (t.hour * 3600 + t.minute * 60 + t.second);
  }
}
