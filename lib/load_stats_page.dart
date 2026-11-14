/// m328v6数控电子负载上位机
/// 查看每次放电的统计信息
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import 'common/when.dart';
import 'common/iconfont.dart';
import 'common/widget_utils.dart';
import 'widgets/modal_dialogs.dart';
import 'models/load_stats_model.dart';
export 'models/load_stats_model.dart';

///传入参数为每次放电的统计列表
class LoadStatsPage extends ConsumerStatefulWidget {
  final Map<String, List<LoadStatsModel>> loadStats;
  const LoadStatsPage({super.key, required this.loadStats});
  @override
  _LoadStatsPageState createState() => _LoadStatsPageState();
}

class _LoadStatsPageState extends ConsumerState<LoadStatsPage> {
  //final _delayOnHourCtrl = TextEditingController(text: "00");
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.loadStats)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    final loadStatsWidgets = List<Widget>.from(widget.loadStats["stats"]?.map((e) {
      return ExpansionTile(title: Text(e.remark.isEmpty ? "${e.startTime.toStdString()} - ${e.endTime?.toStdString() ?? ""}" : e.remark,), 
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(child: Padding(padding: const EdgeInsets.all(10), child: 
              Text(e.remark.isNotEmpty ? e.remark : AppLocalizations.of(context)!.clickToAddRemark,
                style: const TextStyle(fontWeight: FontWeight.bold,),),),
              onTap: () async {
                final ret = await showInputDialog(context: context, title: AppLocalizations.of(context)!.inputARemark, initialText: e.remark);
                if (ret != null) {
                  setState(() {e.remark = ret;});
                }
              },
              onDoubleTap: () async {
                final ret = await showInputDialog(context: context, title: AppLocalizations.of(context)!.inputARemark, initialText: e.remark);
                if (ret != null) {
                  setState(() {e.remark = ret;});
                }
              },
          ),
          Padding(padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10), child: SingleLoadStats(stats: e))]);
    }) ?? [Text(AppLocalizations.of(context)!.noData)]);

    return Container(padding: const EdgeInsets.all(10.0), child: ListView(
      shrinkWrap: true, 
      children: [
        Padding(padding: const EdgeInsets.all(10), child: 
          Row(children: [
            SizedBox(width: 200, child: ElevatedButton(
              onPressed: () {Navigator.pushNamed(context, "/export_stats", arguments: widget.loadStats,);},
              child: Text(AppLocalizations.of(context)!.export),),),
            const Expanded(child: Text("")),
          ]),),
        ...loadStatsWidgets]));
  }
}

///每个单独的放电统计信息widget
class SingleLoadStats extends StatelessWidget {
  final LoadStatsModel stats;
  
  const SingleLoadStats({super.key, required this.stats});
  
  @override
  Widget build(BuildContext context) {
    const leftTextWidth = 150.0;
    return ListView(shrinkWrap: true, children: [
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.initialV),),
        Expanded(child: SelectableText('${stats.initialV.toStringAsFixed(3)}V')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.endV),),
        Expanded(child: SelectableText('${stats.endV.toStringAsFixed(3)}V')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.averageV),),
        Expanded(child: SelectableText('${stats.avgV.toStringAsFixed(3)}V')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.initialI),),
        Expanded(child: SelectableText('${(stats.initialI ?? 0.0).toStringAsFixed(3)}A')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.endI),),
        Expanded(child: SelectableText('${stats.endI.toStringAsFixed(3)}A')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.averageI),),
        Expanded(child: SelectableText('${stats.avgI.toStringAsFixed(3)}A')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.initialAh),),
        Expanded(child: SelectableText('${stats.initialAh.toStringAsFixed(3)}Ah')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.ah),),
        Expanded(child: SelectableText('${stats.ah.toStringAsFixed(3)}Ah')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.totalAh),),
        Expanded(child: SelectableText('${stats.totalAh.toStringAsFixed(3)}Ah')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.initialWh),),
        Expanded(child: SelectableText('${(stats.initialWh ?? 0.0).toStringAsFixed(2)}Wh')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.wh),),
        Expanded(child: SelectableText('${stats.wh.toStringAsFixed(2)}Wh')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.totalWh),),
        Expanded(child: SelectableText('${stats.totalWh.toStringAsFixed(2)}Wh')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.mode),),
        Expanded(child: SelectableText(stats.mode)),]),),
      const Divider(),
      if (stats.mode == "CR") Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.crValue),),
        Expanded(child: SelectableText('${stats.rSet.toStringAsFixed(2)}Ohm')),]),),
      if (stats.mode == "CR") const Divider(),
      if (stats.mode == "CP") Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.cpValue),),
        Expanded(child: SelectableText('${stats.pSet.toStringAsFixed(2)}W')),]),),
      if (stats.mode == "CP") const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.rd),),
        Expanded(child: SelectableText('${stats.rd.toStringAsFixed(3)}Ohm')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.ra),),
        Expanded(child: SelectableText('${stats.ra.toStringAsFixed(3)}Ohm')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.headSink),),
        Expanded(child: SelectableText('${stats.temperature1}C')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.board),),
        Expanded(child: SelectableText('${stats.temperature2}C')),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.startTime),),
        Expanded(child: SelectableText(stats.startTime.toStdString())),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.endTime),),
        Expanded(child: SelectableText(stats.endTime?.toStdString() ?? "")),]),),
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children:[
        SizedBox(width: leftTextWidth, child: SelectableText(AppLocalizations.of(context)!.duration),),
        Expanded(child: SelectableText(
          (stats.endTime != null) ? stats.loadTime.toTimeString() : DateTime.now().difference(stats.startTime).toTimeString(),),),]),),
    ]);
  }
}

/////////////////////////////////////////////////////////////
///导出放电统计数据页面，基本上是export_data页面的拷贝，以后再优化吧
class ExportLoadStatsPage extends ConsumerStatefulWidget {
  final Map<String, List<LoadStatsModel>> loadStats;
  const ExportLoadStatsPage({super.key, required this.loadStats});
  @override
  _ExportLoadStatsPageState createState() => _ExportLoadStatsPageState();
}

class _ExportLoadStatsPageState extends ConsumerState<ExportLoadStatsPage> {
  final _folderCtrller = TextEditingController();
  final _nameCtrller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _nameCtrller.text = "load_stats_${DateTime.now().format('yyyymmdd_HHMMSS')}.xlsx";
    Future.delayed(const Duration(milliseconds: 500), requestPermission); //延时确认权限并获取路径
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.exportLoadStatsData)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    bool btnEnabled = widget.loadStats["stats"]?.isNotEmpty ?? false;
    
    return Container(padding: const EdgeInsets.all(10), child:
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 5), child: Text(AppLocalizations.of(context)!.exportFolder),),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: TextField(controller: _folderCtrller,
              onChanged: (_) {setState((){});},
              decoration: InputDecoration(
                labelText: _folderCtrller.text.isNotEmpty ? null : AppLocalizations.of(context)!.selectAFolderToSave,
                prefixIcon: const Icon(Icons.folder_open)),
            ),),
            IconButton(icon: const Icon(IconFont.dot3), onPressed: () async {
              final ret = await FilePicker.platform.getDirectoryPath(
                dialogTitle: "Choose a directory", initialDirectory: _folderCtrller.text).catchError((e){debugPrint(e.toString()); return null;});
              if (ret != null) {
                setState(() {_folderCtrller.text = ret;});
              }
            }),],),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text(AppLocalizations.of(context)!.fileName),),
          TextField(controller: _nameCtrller,
            onChanged: (_) {setState((){});},
            decoration: InputDecoration(
              labelText: _nameCtrller.text.isNotEmpty ? null : AppLocalizations.of(context)!.enterANameToSave,
              prefixIcon: const Icon(Icons.file_copy_outlined)),
          ),
          Padding(padding: const EdgeInsets.all(20), child: 
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: btnEnabled ? doExport : null, 
                child: Text(AppLocalizations.of(context)!.export)),
            ),),
      ]),);
  }

  ///开始导出
  void doExport() async {
    final loadStats = widget.loadStats["stats"];
    if ((loadStats == null) || (loadStats.isEmpty)) {
      return;
    }

    final fileName = p.join(_folderCtrller.text, _nameCtrller.text);

    //生成XLSX实例
    final workbook = xlsio.Workbook(loadStats.length);
    var wsIdx = 0;
    //记录已使用的sheet名，保证唯一性
    final usedSheetNames = <String>{};
    for (final stats in loadStats) {
      final sheet = workbook.worksheets[wsIdx];
      //XLSX的sheet名字不允许特殊字符(: \ / ? * [ ])，长度不能超过31，且不允许重复
      var remark = stats.remark.replaceAll(RegExp(r'[:\\/\?\*\[\]\r\n：]'), '-');
      remark = remark.trim();
      var sheetName = remark.isEmpty ? stats.startTime.format('yyyy-mm-dd HH-MM-SS') : remark;
      if (sheetName.length > 31) {
        sheetName = sheetName.substring(0, 31);
      }
      var uniqueName = sheetName;
      var suffix = 2;
      while (usedSheetNames.contains(uniqueName)) {
        final tail = '_${suffix++}';
        uniqueName = sheetName.substring(0, (31 - tail.length > 0) ? (31 - tail.length) : sheetName.length) + tail;
      }
      usedSheetNames.add(uniqueName);
      sheet.name = uniqueName;
      var row = 1;
      //填充数据
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.item);
      sheet.getRangeByName('B$row').setText(AppLocalizations.of(context)!.value);
      sheet.getRangeByName('C$row').setText(AppLocalizations.of(context)!.unit);
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.initialV);
      sheet.getRangeByName('B$row').setNumber(stats.initialV);
      sheet.getRangeByName('C$row').setText('V');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.endV);
      sheet.getRangeByName('B$row').setNumber(stats.endV);
      sheet.getRangeByName('C$row').setText('V');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.averageV);
      sheet.getRangeByName('B$row').setNumber(stats.avgV);
      sheet.getRangeByName('C$row').setText('V');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.initialI);
      sheet.getRangeByName('B$row').setNumber(stats.initialI ?? 0.0);
      sheet.getRangeByName('C$row').setText('A');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.endI);
      sheet.getRangeByName('B$row').setNumber(stats.endI);
      sheet.getRangeByName('C$row').setText('A');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.averageI);
      sheet.getRangeByName('B$row').setNumber(stats.avgI);
      sheet.getRangeByName('C$row').setText('A');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.initialAh);
      sheet.getRangeByName('B$row').setNumber(stats.initialAh);
      sheet.getRangeByName('C$row').setText('Ah');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.ah);
      sheet.getRangeByName('B$row').setNumber(stats.ah);
      sheet.getRangeByName('C$row').setText('Ah');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.totalAh);
      sheet.getRangeByName('B$row').setNumber(stats.totalAh);
      sheet.getRangeByName('C$row').setText('Ah');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.initialWh);
      sheet.getRangeByName('B$row').setNumber(stats.initialWh ?? 0.0);
      sheet.getRangeByName('C$row').setText('Wh');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.wh);
      sheet.getRangeByName('B$row').setNumber(stats.wh);
      sheet.getRangeByName('C$row').setText('Wh');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.totalWh);
      sheet.getRangeByName('B$row').setNumber(stats.totalWh);
      sheet.getRangeByName('C$row').setText('Wh');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.mode);
      sheet.getRangeByName('B$row').setText(stats.mode);
      sheet.getRangeByName('C$row').setText('');
      row++;
      if (stats.mode == "CR") {
        sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.crValue);
        sheet.getRangeByName('B$row').setText(stats.rSet.toStringAsFixed(2));
        sheet.getRangeByName('C$row').setText('Ohm');
        row++;
      } else if (stats.mode == "CP") {
        sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.cpValue);
        sheet.getRangeByName('B$row').setText(stats.pSet.toStringAsFixed(2));
        sheet.getRangeByName('C$row').setText('W');
        row++;
      }
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.rd);
      sheet.getRangeByName('B$row').setNumber(stats.rd);
      sheet.getRangeByName('C$row').setText('Ohm');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.ra);
      sheet.getRangeByName('B$row').setNumber(stats.ra);
      sheet.getRangeByName('C$row').setText('Ohm');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.headSink);
      sheet.getRangeByName('B$row').setText(stats.temperature1.toString());
      sheet.getRangeByName('C$row').setText('C');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.board);
      sheet.getRangeByName('B$row').setText(stats.temperature2.toString());
      sheet.getRangeByName('C$row').setText('C');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.startTime);
      sheet.getRangeByName('B$row').setText(stats.startTime.toStdString());
      sheet.getRangeByName('C$row').setText('');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.endTime);
      sheet.getRangeByName('B$row').setText(stats.endTime?.toStdString() ?? "");
      sheet.getRangeByName('C$row').setText('');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.duration);
      sheet.getRangeByName('B$row').setText(
        (stats.endTime != null) ? stats.loadTime.toTimeString() : DateTime.now().difference(stats.startTime).toTimeString()
      );
      sheet.getRangeByName('C$row').setText('');
      row++;
      sheet.getRangeByName('A$row').setText(AppLocalizations.of(context)!.remark);
      sheet.getRangeByName('B$row').setText(stats.remark);
      sheet.getRangeByName('C$row').setText('');
      row++;
      wsIdx++;
    }

    //开始保存文件
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    bool ret = true;
    try {
      await File(fileName).writeAsBytes(bytes);
    } catch (e) {
      debugPrint('Export load stats failed: $e');
      ret = false;
    }

    if (!mounted) {
      return;
    }
    if (ret) {
      showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.success, content: Text(AppLocalizations.of(context)!.exportLoadStatsFileSuccess));
    } else {
      showToast(AppLocalizations.of(context)!.exportFileFailed);
    }
  }

  ///确认权限，如果没有权限，提示需要申请
  void requestPermission([_]) async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      var status = await Permission.storage.status;
      if (status.isDenied) { //尚未授权，弹出申请对话框
        await Permission.storage.request();
      }
    }

    fetchDefaultExportDir();
  }

  ///根据系统不同返回默认的导出目录
  void fetchDefaultExportDir() async {
    if (_folderCtrller.text.isNotEmpty) {
      return;
    }
    
    var ret = "";
    if (Platform.isAndroid || Platform.isFuchsia) {
      //使用path_provider返回的Download目录在Android11上是应用内Download目录，外部无法存取
      //在这里使用一个通用的目录，如果以后Android又修改了，再考虑其他方案
      ret = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      ret = (await getApplicationSupportDirectory()).path;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      ret = (await getDownloadsDirectory())?.path ?? "";
    } else {
      ret = "";
    }
    if (mounted) {
      setState((){_folderCtrller.text = ret;});
    }
  }
}
