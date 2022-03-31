/// m328v6数控电子负载上位机
/// 测试电源的最大可提供电流/功率
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../i18n/max_i_tester.i18n.dart';
import '../common/globals.dart';
import '../common/widget_utils.dart';
import '../common/common_utils.dart';
import '../widgets/modal_dialogs.dart';
import '../models/running_data_provider.dart';
import '../models/connection_provider.dart';

///测试终止条件的枚举
enum _EndCondition {
  dropPercent,
  dropVolt,
  endVolt,
}

///测试阶段/状态枚举
enum _TestStatus {
  waiting,
  testing,
  finish,
  paused,
  stopped,
}

class MaxITesterPage extends ConsumerStatefulWidget {
  const MaxITesterPage({Key? key}) : super(key: key);
  @override
  _MaxITesterPageState createState() => _MaxITesterPageState();
}

class _MaxITesterPageState extends ConsumerState<MaxITesterPage> {
  final _startCurrentCtrller = TextEditingController(text: "0.0");
  final _endCurrentCtrller = TextEditingController(text: "10.0");
  final _currentStepCtrller = TextEditingController(text: "0.050");
  final _endConditionCtrller = TextEditingController(text: "10");
  var _stepTime = 1; //步进时间，0表示0.5s，之后的数字表示秒数，比如1表示1s
  String _endConditionStr = _EndCondition.dropPercent.name;
  PausableTimer? _timer;  //定时增加电流值的定时器
  double _vStart = 0.0;  //开始测试时的电压
  double _endV = 0.0;    //计算出来的截止电压
  double _iToSet = 0.0;  //当前要测试的电流值
  double _maxPower = 0.0; //最大功率
  double _vWhenMaxPower = 0.0; //最大功率时的电压值
  double _iWhenMaxPower = 0.0; //最大功率时的电流值
  double _maxCurrent = 0.0; //本次测试的最大电流
  _TestStatus _testStatus = _TestStatus.waiting;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(title: Text('Test PSU max capacity'.i18n)),
      body: (orientation == Orientation.portrait) ? buildMainList(context) : buildMainListLandscape(context),
    );
  }

  ///构建竖屏页面主体的ListView
  Widget buildMainList(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final startBtnEnabled = (rdProvider.vNow > 0.0) && ([_TestStatus.waiting, _TestStatus.finish, _TestStatus.stopped].contains(_testStatus));
    final stopPauseBtnEnabled = (rdProvider.vNow > 0.0) && ([_TestStatus.testing, _TestStatus.paused].contains(_testStatus));
    
    if (_testStatus == _TestStatus.testing) {
      updateMax(rdProvider.powerIn, rdProvider.vNow, rdProvider.iNow);
    }

    String testInfo = "";
    if ((_testStatus == _TestStatus.testing) || (_testStatus == _TestStatus.paused)) {
      testInfo = _testStatus.name.capitalize().i18n + " [${_iToSet.toStringAsFixed(3)}A]...";
    } else {
      testInfo = _testStatus.name.capitalize().i18n;
    }

    final powerStr = "${_maxPower.toStringAsFixed(1)} W (${_vWhenMaxPower.toStringAsFixed(3)}V x ${_iWhenMaxPower.toStringAsFixed(3)}A)";
    
    return Container(padding: const EdgeInsets.all(10.0), child: ListView(children: [
      //参数配置区段
      ExpansionTile(title: Text("Parameters".i18n), 
        leading: const Icon(Icons.settings),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: true,
        children: [
          Padding(padding: const EdgeInsets.only(right: 40), child: TextField(controller: _startCurrentCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "Start test current (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(right: 40), child: TextField(controller: _endCurrentCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "End test current (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(right: 40), child: TextField(controller: _currentStepCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "Current step (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(top: 10), child: Text("Step time".i18n),),
          Row(children: [
            SizedBox(width: 200, child: DropdownButton(value: _stepTime, isExpanded: true,
              items: const [
                //DropdownMenuItem(value: 0, child: Text("0.5s")),
                DropdownMenuItem(value: 1, child: Text("1s")),
                DropdownMenuItem(value: 2, child: Text("2s")),
                DropdownMenuItem(value: 3, child: Text("3s")),
                DropdownMenuItem(value: 4, child: Text("4s")),
                DropdownMenuItem(value: 5, child: Text("5s")),],
              onChanged: (newValue) {setState(() {_stepTime = int.tryParse(newValue.toString()) ?? 1;});},),),
            const Expanded(child: Text("")),
          ],),
          Padding(padding: const EdgeInsets.only(top: 10), child: Text("End condition".i18n),),
          Row(children: [
            SizedBox(width: 180, child: DropdownButtonFormField(value: _endConditionStr, isExpanded: true,
              items: [
                DropdownMenuItem(value: _EndCondition.dropPercent.name, child: Text("Voltage drop (%)".i18n)),
                DropdownMenuItem(value: _EndCondition.dropVolt.name, child: Text("Voltage drop (V)".i18n)),
                DropdownMenuItem(value: _EndCondition.endVolt.name, child: Text("End voltage (V)".i18n)),],
              onChanged: (newValue) {setState(() {
                if (newValue != null) {
                  _endConditionStr = newValue.toString();
                  if ((_testStatus != _TestStatus.testing) && (_testStatus != _TestStatus.paused)) {
                    updateEndV(rdProvider);
                  }
                }
              });},),),
            Flexible(child: SizedBox(width: 80, child: TextFormField(controller: _endConditionCtrller,
              keyboardType: TextInputType.number, 
              textAlign: TextAlign.right,
              onChanged: (_) {setState(() {
                if ((_testStatus != _TestStatus.testing) && (_testStatus != _TestStatus.paused)) {
                  updateEndV(rdProvider);
                }
              });},
              //inputFormatters: [DecimalTextInputFormatter()],
              decoration: const InputDecoration(contentPadding: EdgeInsets.zero,),
            ),),),
            Expanded(child: Text((_endConditionStr == _EndCondition.dropPercent.name) ? "%" : "V", textAlign: TextAlign.left),),
          ],),
          Padding(padding: const EdgeInsets.all(20), child: 
            SizedBox(width: 230, child: ElevatedButton(
              onPressed: startBtnEnabled ? startTest : null, 
              child: Text("Start".i18n),),
          ),),
      ]),
      ExpansionTile(title: Text("Process and results".i18n), 
        leading: const Icon(Icons.wb_auto),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: true,
        children: [
          //电压和电流仪表盘
          Row(children: [
            SizedBox(width: scrWidth / 2 - 20, height: scrWidth / 2 - 20, child: SfRadialGauge(
              axes: <RadialAxis>[RadialAxis(minimum: 0, maximum: 65,
                pointers: <GaugePointer>[
                  //NeedlePointer:实时电压指针, MarkerPointer:截止电压指针
                  NeedlePointer(value: rdProvider.vNow, needleEndWidth: 3, enableAnimation: true,
                    needleColor: Colors.red, knobStyle: const KnobStyle(color: Colors.red, 
                      knobRadius: 8, sizeUnit: GaugeSizeUnit.logicalPixel),),
                  MarkerPointer(value: _endV, color: Colors.red),],
                annotations: <GaugeAnnotation>[GaugeAnnotation(widget: 
                 Text(rdProvider.vNow.toStringAsFixed(3) + "V", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                 angle: 90, positionFactor: 0.75,)],),
              ],
            ),),
            SizedBox(width: scrWidth / 2 - 20, height: scrWidth / 2 - 20, child: SfRadialGauge(
              axes: <RadialAxis>[RadialAxis(minimum: 0, maximum: double.tryParse(_endCurrentCtrller.text) ?? 10,
                pointers: <GaugePointer>[NeedlePointer(value: rdProvider.iNow, needleEndWidth: 3, enableAnimation: true,
                  needleColor: Colors.blue, knobStyle: const KnobStyle(color: Colors.blue,
                    knobRadius: 8, sizeUnit: GaugeSizeUnit.logicalPixel),)],
                annotations: <GaugeAnnotation>[GaugeAnnotation(widget: 
                 Text(rdProvider.iNow.toStringAsFixed(3) + "A", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                 angle: 90, positionFactor: 0.75,)],),
              ],
            ),),
          ],),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Max power'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text(powerStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red,),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Max current'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text("${_maxCurrent.toStringAsFixed(3)} A", 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Status'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text(testInfo, style: const TextStyle(fontWeight: FontWeight.bold,)),),
          ]),
          Padding(padding: const EdgeInsets.all(20), child: Row(children: [
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: stopPauseBtnEnabled ? pauseTest : null, 
                child: Text((_testStatus == _TestStatus.paused) ? "Resume".i18n : "Pause".i18n),),
            ),
            const SizedBox(width: 30,),
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: stopPauseBtnEnabled ? stopTest : null, 
                child: Text("Stop".i18n),),
            ),
            Expanded(child: Container(),),
          ],),),
        ],),
      const SizedBox(height: 50),
    ],),
    );
  }

  ///构建横屏页面主体的ListView
  Widget buildMainListLandscape(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final startBtnEnabled = (rdProvider.vNow > 0.0) && ([_TestStatus.waiting, _TestStatus.finish, _TestStatus.stopped].contains(_testStatus));
    final stopPauseBtnEnabled = (rdProvider.vNow > 0.0) && ([_TestStatus.testing, _TestStatus.paused].contains(_testStatus));
    
    if (_testStatus == _TestStatus.testing) {
      _maxCurrent = max<double>(_maxCurrent, rdProvider.iNow); //保存最大电流
    }

    String testInfo = "";
    if ((_testStatus == _TestStatus.testing) || (_testStatus == _TestStatus.paused)) {
      testInfo = _testStatus.name.capitalize().i18n + " [${_iToSet.toStringAsFixed(3)}A]...";
    } else {
      testInfo = _testStatus.name.capitalize().i18n;
    }

    final powerStr = "${_maxPower.toStringAsFixed(1)} W (${_vWhenMaxPower.toStringAsFixed(3)}V x ${_iWhenMaxPower.toStringAsFixed(3)}A)";

    return Container(padding: const EdgeInsets.all(10.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      //左侧参数区
      Flexible(child: 
        ListView(children: [
          Padding(padding: const EdgeInsets.only(right: 60), child: TextField(controller: _startCurrentCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "Start test current (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(right: 60), child: TextField(controller: _endCurrentCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "End test current (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(right: 60), child: TextField(controller: _currentStepCtrller,
            keyboardType: TextInputType.number,
            inputFormatters: [CustomMaxValueInputFormatter(15.0)],
            onTap: () {},
            decoration: InputDecoration(labelText: "Current step (A)".i18n,),
          ),),
          Padding(padding: const EdgeInsets.only(top: 10), child: Text("Step time".i18n),),
          Row(children: [
            SizedBox(width: 200, child: DropdownButton(value: _stepTime, isExpanded: true,
              items: const [
                //DropdownMenuItem(value: 0, child: Text("0.5s")),
                DropdownMenuItem(value: 1, child: Text("1s")),
                DropdownMenuItem(value: 2, child: Text("2s")),
                DropdownMenuItem(value: 3, child: Text("3s")),
                DropdownMenuItem(value: 4, child: Text("4s")),
                DropdownMenuItem(value: 5, child: Text("5s")),],
              onChanged: (newValue) {setState(() {_stepTime = int.tryParse(newValue.toString()) ?? 0;});},),),
            const Expanded(child: Text("")),
          ],),
          Padding(padding: const EdgeInsets.only(top: 10), child: Text("End condition".i18n),),
          Row(children: [
            SizedBox(width: 180, child: DropdownButtonFormField(value: _endConditionStr, isExpanded: true,
              items: [
                DropdownMenuItem(value: _EndCondition.dropPercent.name, child: Text("Voltage drop (%)".i18n)),
                DropdownMenuItem(value: _EndCondition.dropVolt.name, child: Text("Voltage drop (V)".i18n)),
                DropdownMenuItem(value: _EndCondition.endVolt.name, child: Text("End voltage (V)".i18n)),],
              onChanged: (newValue) {setState(() {
                if (newValue != null) {
                  _endConditionStr = newValue.toString();
                  if ((_testStatus != _TestStatus.testing) && (_testStatus != _TestStatus.paused)) {
                    updateEndV(rdProvider);
                  }
                }
              });},),),
            Flexible(child: SizedBox(width: 80, child: TextFormField(controller: _endConditionCtrller,
              keyboardType: TextInputType.number, 
              textAlign: TextAlign.right,
              onChanged: (_) {setState(() {
                if ((_testStatus != _TestStatus.testing) && (_testStatus != _TestStatus.paused)) {
                  updateEndV(rdProvider);
                }
              });},
              //inputFormatters: [DecimalTextInputFormatter()],
              decoration: const InputDecoration(contentPadding: EdgeInsets.zero,),
            ),),),
            Expanded(child: Text((_endConditionStr == _EndCondition.dropPercent.name) ? "%" : "V", textAlign: TextAlign.left),),
          ],),
          Padding(padding: const EdgeInsets.only(top: 30), child: 
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                onPressed: startBtnEnabled ? startTest : null, 
                child: Text("Start".i18n),),
              ElevatedButton(
                onPressed: stopPauseBtnEnabled ? pauseTest : null, 
                child: Text((_testStatus == _TestStatus.paused) ? "Resume".i18n : "Pause".i18n),),
              ElevatedButton(
                onPressed: stopPauseBtnEnabled ? stopTest : null, 
                child: Text("Stop".i18n),),
            ],),),
      ],),),
      const SizedBox(width: 10),
      //右侧结果区
      Flexible(child: 
        ListView(children: [
          //电压和电流仪表盘
          Row(children: [
            SizedBox(width: scrWidth / 4 - 10, height: scrWidth / 4 - 10, child: SfRadialGauge(
              axes: <RadialAxis>[RadialAxis(minimum: 0, maximum: 65,
                pointers: <GaugePointer>[
                  //NeedlePointer:实时电压指针, MarkerPointer:截止电压指针
                  NeedlePointer(value: rdProvider.vNow, needleEndWidth: 3, enableAnimation: true,
                    needleColor: Colors.red, knobStyle: const KnobStyle(color: Colors.red, 
                      knobRadius: 8, sizeUnit: GaugeSizeUnit.logicalPixel),),
                  MarkerPointer(value: _endV, color: Colors.red),],
                annotations: <GaugeAnnotation>[GaugeAnnotation(widget: 
                 Text(rdProvider.vNow.toStringAsFixed(3) + "V", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                 angle: 90, positionFactor: 0.75,)],),
              ],
            ),),
            SizedBox(width: scrWidth / 4 - 10, height: scrWidth / 4 - 10, child: SfRadialGauge(
              axes: <RadialAxis>[RadialAxis(minimum: 0, maximum: double.tryParse(_endCurrentCtrller.text) ?? 10,
                pointers: <GaugePointer>[NeedlePointer(value: rdProvider.iNow, needleEndWidth: 3, enableAnimation: true,
                  needleColor: Colors.blue, knobStyle: const KnobStyle(color: Colors.blue,
                    knobRadius: 8, sizeUnit: GaugeSizeUnit.logicalPixel),)],
                annotations: <GaugeAnnotation>[GaugeAnnotation(widget: 
                 Text(rdProvider.iNow.toStringAsFixed(3) + "A", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                 angle: 90, positionFactor: 0.75,)],),
              ],
            ),),
          ],),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Max power'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text(powerStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red,),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Max current'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text("${_maxCurrent.toStringAsFixed(3)} A", 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: 
              Text('Status'.i18n, textAlign: TextAlign.right,),),),
            Expanded(child: Text(testInfo, style: const TextStyle(fontWeight: FontWeight.bold,)),),
          ]),
        ],),),
    ],),);
  }

  ///开始启动最大电流/功率测试
  void startTest() {
    if (!([_TestStatus.waiting, _TestStatus.finish, _TestStatus.stopped].contains(_testStatus))) {
      return;
    }

    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    if (rdProvider.vNow <= 0.0) {
      return;
    }
    
    //判断参数的合法性
    final startI = double.tryParse(_startCurrentCtrller.text);
    final endI = double.tryParse(_endCurrentCtrller.text);
    final stepI = double.tryParse(_currentStepCtrller.text);
    if ((startI == null) || (startI < 0.0) || (startI > 15.0)) {
      showToast("Start current value is invalid".i18n);
      return;
    }
    if ((endI == null) || (endI < 0.0) || (endI > 15.0) || (endI <= startI)) {
      showToast("End current value is invalid".i18n);
      return;
    }
    if ((stepI == null) || (stepI <= 0.0) || (stepI > 15.0)) {
      showToast("Current step value is invalid".i18n);
      return;
    }

    final ret = updateEndV(rdProvider);
    if (ret.isNotEmpty) {
      showToast(ret);
      return;
    }
    
    //开始测试
    _maxCurrent = startI;
    _testStatus = _TestStatus.testing;

    //初始化下位机的一些参数
    load.setV(0.0); //由软件判断截止电压
    Future.delayed(const Duration(milliseconds: 100), () => load.setI(startI));
    Future.delayed(const Duration(milliseconds: 200), () => load.setLoadOn(true));
    _iToSet = startI;
    _maxPower = 0.0;
    _vWhenMaxPower = 0.0;
    _iWhenMaxPower = 0.0;

    //创建一个定时器用于定时增加电流值
    if (_stepTime == 0) {
      _stepTime = 1;
    }
    final duration = Duration(seconds: _stepTime);
    
    _timer?.cancel();
    
    _timer = PausableTimer(duration, () {
      if (!mounted) {
        return;
      }
      
      final powerIn = rdProvider.powerIn;
      final vNow = rdProvider.vNow;
      final iNow = rdProvider.iNow;

      //保存最大功率和电流
      updateMax(powerIn, vNow, iNow);
      
      if ((_iToSet >= endI) || (vNow < _endV)) {  //结束
        //debugPrint("End for $vNow V");
        _timer?.cancel();
        load.setLoadOn(false);
        setState(() {_testStatus = _TestStatus.finish;});
      } else {
        //避免浮点数计算误差，这里转换为整数计算
        _iToSet = ((_iToSet + stepI) > endI) ? endI : (((_iToSet * 1000).toInt() + (stepI * 1000).toInt()) / 1000);
        load.setI(_iToSet);
        setState(() {_testStatus = _TestStatus.testing;});
        //主动查询电压电流值
        if (_stepTime == 0) {
          _stepTime = 1;
        }
        Future.delayed(Duration(milliseconds: (_stepTime * 1000) - 500), () {
          load.setI(65.535);
          Future.delayed(const Duration(milliseconds: 100), () => load.setV(65.535));
        });
        _timer?..reset()..start();
      }
    });
    _timer?.start();
  }

  ///更新最大功率和电流
  void updateMax(double powerIn, double vNow, double iNow) {
    if (iNow >= _maxCurrent) {
      _maxCurrent = iNow;
    }
    
    //保存最大功率
    if (powerIn >= _maxPower) {
      _maxPower = powerIn;
      _vWhenMaxPower = vNow;
      _iWhenMaxPower = iNow;
    }
  }

  ///暂停测试
  void pauseTest() {
    if (_testStatus == _TestStatus.paused) {
      _timer?..reset()..start();
      _testStatus = _TestStatus.testing;
    } else {
      _timer?.pause();
      _testStatus = _TestStatus.paused;
    }
    
    setState((){});
  }

  ///停止测试
  void stopTest() {
    _timer?.cancel();
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    load.setLoadOn(false);
    _testStatus = _TestStatus.stopped;
    setState((){});
  }

  ///更新截止电压，如果错误，返回一个错误字符串
  String updateEndV(RunningDataProvider rdProvider) {
    _vStart = rdProvider.vNow;
    if (_endConditionStr == _EndCondition.dropPercent.name) { //电压跌落百分比
      final value = double.tryParse(_endConditionCtrller.text);
      if ((value == null) || (value < 0.01) || (value > 100.0)) {
        return "The voltage drop percentage is invalid".i18n;
      }
      _endV = _vStart - (_vStart * (value / 100));
    } else if (_endConditionStr == _EndCondition.dropVolt.name) { //电压跌落值
      final value = double.tryParse(_endConditionCtrller.text);
      if ((value == null) || (value < 0.01) || (value > 65.0) || (value > _vStart)) {
        return "The voltage drop value is invalid".i18n;
      }
      _endV = _vStart - value;
    } else { //截止电压
      final value = double.tryParse(_endConditionCtrller.text);
      if ((value == null) || (value < 0.0) || (value > 65.0) || (value >= _vStart)) {
        return "The end voltage value is invalid".i18n;
      }
      _endV = value;
    }
    return "";
  }
  
}
