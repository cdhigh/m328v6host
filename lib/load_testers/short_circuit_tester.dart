/// m328v6数控电子负载上位机
/// 电源短路测试，属于比较极端的测试手段，如果电源的热保护和器件质量不过关，在多次的短路测试后可能会烧毁
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../i18n/short_circuit_tester.i18n.dart';
import '../common/globals.dart';
import '../common/widget_utils.dart';
import '../models/running_data_provider.dart';
import '../models/connection_provider.dart';
import '../m328v6_load.dart';

///测试阶段/状态枚举
enum _TestStatus {
  waiting,
  shorted,
  gapping,
}

class ScTesterPage extends ConsumerStatefulWidget {
  const ScTesterPage({Key? key}) : super(key: key);
  @override
  _ScTesterPageState createState() => _ScTesterPageState();
}

class _ScTesterPageState extends ConsumerState<ScTesterPage> {
  final _cntCtrller = TextEditingController();
  int _testCnt = 0; //测试次数
  int _scTime = 1; //短路时间
  int _gapTime = 1; //间隔时间
  _TestStatus _testStatus = _TestStatus.waiting;
  late M328v6Load _load;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _load.restoreMos();
    //恢复默认上报方式
    Future.delayed(const Duration(milliseconds: 100), () => _load.setDataReportType(baseData: 1, extraData: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _load = ref.read<ConnectionProvider>(Global.connectionProvider).load;
    return Scaffold(
      appBar: AppBar(title: Text('Short circuit tester!!!'.i18n)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    final warningText = ["Warning: This test is very dangerous!".i18n,
      "Please do not test the battery.".i18n,
      "Before the test, make sure that the power supply has short circuit protection.".i18n,
      "Only for power supply under 10V.".i18n,
    ];

    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);

    //按钮使能
    bool btnEnabled = true;
    
    //状态文本
    String testInfo;
    if (_testStatus == _TestStatus.shorted) {
      testInfo = "Shorted".i18n;
    } else if (_testStatus == _TestStatus.gapping) {
      testInfo = "In the gap".i18n;
    } else if (rdProvider.vNow < 1) {
      testInfo = "Power supply not connected".i18n;
      btnEnabled = false;
    } else if (rdProvider.vNow > 10) {
      testInfo = "Voltage is too high".i18n;
      btnEnabled = false;
    } else { // if (_testStatus == _TestStatus.waiting) {
      testInfo = "Waiting".i18n;
    }

    //进度条数值
    var progressValue = 0.0;
    final maxTestCnt = int.tryParse(_cntCtrller.text);
    if ((maxTestCnt != null) && (maxTestCnt > 0.0)) {
      progressValue = (_testCnt < maxTestCnt) ? (_testCnt / maxTestCnt) : 1.0;
    }

    //开头的警告文本
    final warningWidget = warningText.map<Widget>((elem) {
      return Text(elem, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold,), textScaleFactor: 1.2);
    }).toList();

    return Container(padding: const EdgeInsets.all(10), child:
      ListView(
        children: [
          //警示文本
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: warningWidget,),),
          const Divider(height: 3,),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("Number of tests".i18n),),
          Row(children: [
            SizedBox(width: 280, child: TextField(controller: _cntCtrller,
              keyboardType: TextInputType.number,
              onChanged: (_) {setState((){});},
              decoration: InputDecoration(
                labelText: _cntCtrller.text.isNotEmpty ? null : "Enter the number of tests".i18n,),),),
            const Expanded(child: Text("")),
          ]),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("short circuit time".i18n),),
          Row(children: [
            SizedBox(width: 280, child: DropdownButton(value: _scTime, isExpanded: true,
              items: const [
                DropdownMenuItem(value: 1, child: Text("1s")),
                DropdownMenuItem(value: 2, child: Text("2s")),
                DropdownMenuItem(value: 3, child: Text("3s")),
                DropdownMenuItem(value: 4, child: Text("4s")),
                DropdownMenuItem(value: 5, child: Text("5s")),
                DropdownMenuItem(value: 6, child: Text("6s")),
                DropdownMenuItem(value: 7, child: Text("7s")),
                DropdownMenuItem(value: 8, child: Text("8s")),
                DropdownMenuItem(value: 9, child: Text("9s")),
                DropdownMenuItem(value: 10, child: Text("10s")),
                ],
              onChanged: (newValue) {setState(() {_scTime = int.tryParse(newValue.toString()) ?? 1;});},),),
            const Expanded(child: Text("")),
          ],),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("Gap time".i18n),),
          Row(children: [
            SizedBox(width: 280, child: DropdownButton(value: _gapTime, isExpanded: true,
              items: const [
                DropdownMenuItem(value: 1, child: Text("1s")),
                DropdownMenuItem(value: 2, child: Text("2s")),
                DropdownMenuItem(value: 3, child: Text("3s")),
                DropdownMenuItem(value: 4, child: Text("4s")),
                DropdownMenuItem(value: 5, child: Text("5s")),
                DropdownMenuItem(value: 6, child: Text("6s")),
                DropdownMenuItem(value: 7, child: Text("7s")),
                DropdownMenuItem(value: 8, child: Text("8s")),
                DropdownMenuItem(value: 9, child: Text("9s")),
                DropdownMenuItem(value: 10, child: Text("10s")),
                ],
              onChanged: (newValue) {setState(() {_gapTime = int.tryParse(newValue.toString()) ?? 1;});},),),
            const Expanded(child: Text("")),
          ],),
          Row(children: [
            SizedBox(width: 280, child: Padding(padding: const EdgeInsets.all(20), child: 
              ElevatedButton(
                onPressed: btnEnabled ? startTest : null, 
                child: Text((_testStatus == _TestStatus.waiting) ? "Start".i18n : "Stop".i18n)),
            ),),
            const Expanded(child: Text("")),
          ],),
          const Divider(height: 5,),
          Padding(padding: const EdgeInsets.only(top: 10), child: Row(children: [
            SizedBox(width: 150, child: Text('Status'.i18n, textAlign: TextAlign.right,),),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 20), child: 
              Text(testInfo, style: const TextStyle(fontWeight: FontWeight.bold,)),),),
          ]),),
          const SizedBox(height: 5),
          Row(children: [
            SizedBox(width: 150, child: Text('Voltage'.i18n, textAlign: TextAlign.right,),),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 20), child: 
              Text(rdProvider.vNow.toStringAsFixed(3) + "V", style: 
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red,),),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            SizedBox(width: 150, child: Text('Current'.i18n, textAlign: TextAlign.right,),),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 20), child: 
              Text(rdProvider.iNow.toStringAsFixed(3) + "A", style: 
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,),),),),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            SizedBox(width: 150, child: Text('Test progress'.i18n, textAlign: TextAlign.right,),),
            Padding(padding: const EdgeInsets.only(left: 20), child: 
              ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 150), child: 
                LinearProgressIndicator(value: progressValue, minHeight: 10, semanticsValue: _testCnt.toString(),),),),
            const Expanded(child: Text(""),),
          ]),
          const SizedBox(height: 30),
      ]),);
  }

  ///开始启动短路测试
  void startTest() {
    if (_testStatus == _TestStatus.waiting) {  //启动测试
      final maxTestCnt = int.tryParse(_cntCtrller.text);
      if ((maxTestCnt == null) || (maxTestCnt <= 0)) {
        showToast("Number of tests is invalid".i18n);
        return;
      }

      _testCnt = 0;
      _load.fullOpenMos();
      //切换为VIL数据上报方式
      Future.delayed(const Duration(milliseconds: 100), () => _load.setDataReportType(baseData: 2, extraData: true));
      setState((){_testStatus = _TestStatus.shorted;});
      Future.delayed(Duration(seconds: _scTime), funcToRestore);
    } else { //停止测试
      _testCnt = 0;
      _load.restoreMos();
      //恢复默认上报方式
      Future.delayed(const Duration(milliseconds: 100), () => _load.setDataReportType(baseData: 1, extraData: true));
      setState((){_testStatus = _TestStatus.waiting;});
    }
  }

  ///强制MOS导通，进行短路测试
  void funcToShort([_]) {
    if (!mounted || (_testStatus == _TestStatus.waiting)) {
      return;
    }
    final maxTestCnt = int.tryParse(_cntCtrller.text);
    if ((maxTestCnt == null) || (maxTestCnt <= 0)) {
      return;
    }

    _load.fullOpenMos();
    setState((){_testStatus = _TestStatus.shorted;});
    Future.delayed(Duration(seconds: _scTime), funcToRestore);
  }

  ///恢复MOS
  void funcToRestore([_]) {
    if (!mounted || (_testStatus == _TestStatus.waiting)) {
      return;
    }
    final maxTestCnt = int.tryParse(_cntCtrller.text);
    if ((maxTestCnt == null) || (maxTestCnt <= 0)) {
      return;
    }

    _load.restoreMos();
    _testCnt++;
    if (_testCnt >= maxTestCnt) { //测试结束
      setState((){_testStatus = _TestStatus.waiting;});
    } else {
      setState((){_testStatus = _TestStatus.gapping;});
      Future.delayed(Duration(seconds: _gapTime), funcToShort);
    }
  }

}
