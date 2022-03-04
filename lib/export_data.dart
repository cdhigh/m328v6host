/// m328v6数控电子负载上位机
/// 导出数据到EXCEL或其他格式
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io';
//import 'dart:ui' as ui;
//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:syncfusion_officechart/officechart.dart' as officechart;
import 'package:file_picker/file_picker.dart';
import 'i18n/export_data.i18n.dart';
import 'common/iconfont.dart';
import 'common/globals.dart';
import 'common/common_utils.dart';
import 'common/when.dart';
import 'widgets/modal_dialogs.dart';
import 'models/volt_history_provider.dart';

class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({Key? key}) : super(key: key);
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  final _folderCtrller = TextEditingController();
  final _nameCtrller = TextEditingController();
  final _remarkCtrller = TextEditingController();
  String _exportType = "XLSX"; //"XLSX","TXT"
  late VoltHistoryProvider _vhProvider;
  int _dotNum = 0;
  //String _baseName = "";
  //String _exportDir = "";
  
  @override
  void initState() {
    super.initState();
    _nameCtrller.text = "m328v6_" + DateTime.now().format('yyyymmdd_HHMMSS') + ".xlsx";
    Future.delayed(const Duration(milliseconds: 500)).then(requestPermission); //延时确认权限并获取路径
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export curva data'.i18n)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    _vhProvider = ref.watch<VoltHistoryProvider>(Global.vHistoryProvider);
    _dotNum = _vhProvider.dotNum;
    return Container(padding: const EdgeInsets.all(10), child:
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("Export type".i18n)),
          Padding(padding: const EdgeInsets.only(left: 5), child: Row(children: [
            const Padding(padding: EdgeInsets.only(right: 12), child: Icon(IconFont.fileType),),
            Expanded(child: DropdownButton(value: _exportType, 
              //isExpanded: true,
              items: [
                DropdownMenuItem(value: "XLSX", child: Text("XLSX file".i18n)),
                DropdownMenuItem(value: "TXT", child: Text("TXT file".i18n)),],
              onChanged: (newValue) {setState(() {
                _exportType = newValue.toString();
                _nameCtrller.text = p.setExtension(_nameCtrller.text, (newValue == "XLSX") ? ".xlsx" : ".txt");
                });
              },),),
          ]),),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("Export folder".i18n),),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: TextField(controller: _folderCtrller,
              decoration: InputDecoration(
                labelText: _folderCtrller.text != "" ? null : "Select a folder to save".i18n,
                prefixIcon: const Icon(Icons.folder_open)),
            ),),
            IconButton(icon: const Icon(IconFont.dot3), onPressed: () async {
              final ret = await FilePicker.platform.getDirectoryPath(
                dialogTitle: "Choose a directory", initialDirectory: _folderCtrller.text).catchError((e){debugPrint(e.toString());});
              if (ret != null) {
                setState(() {_folderCtrller.text = ret;});
              }
            }),],),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("File name".i18n),),
          TextField(controller: _nameCtrller,
            decoration: InputDecoration(
              labelText: _nameCtrller.text != "" ? null : "Enter a name to save".i18n,
              prefixIcon: const Icon(Icons.file_copy_outlined)),
          ),
          Padding(padding: const EdgeInsets.only(top: 5), child: Text("Remark".i18n),),
          TextField(controller: _remarkCtrller,
            decoration: InputDecoration(
              labelText: _remarkCtrller.text != "" ? null : "Enter a remark".i18n,
              prefixIcon: const Icon(Icons.comment_bank_outlined)),
          ),
          Padding(padding: const EdgeInsets.all(20), child: 
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: (_dotNum > 0) ? doExport : null, 
                child: Text("Export".i18n)),
            ),),
      ]),);
  }

  ///开始导出
  void doExport() {
    if (_dotNum == 0) {
      return;
    }

    final fileName = p.join(_folderCtrller.text, _nameCtrller.text);
    if (_exportType == "XLSX") {
      exportToXlsx(fileName);
    } else if (_exportType == "TXT") {
      exportToTxt(fileName);
    } else {
      return;
    }

    showOkAlertDialog(context: context, title: "Success".i18n, content: Text("Export %s file success".i18n.fill([_exportType])));
  }

  ///导出为XLSX
  ///fileName: 路径+文件名
  void exportToXlsx(String fileName) async {
    //生成XLSX实例
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    //填充数据
    final remarkText = _remarkCtrller.text.trim();
    sheet.getRangeByName('A1').setText('Time'.i18n);
    sheet.getRangeByName('B1').setText(remarkText.isEmpty ? 'Voltage'.i18n : remarkText);
    final list = _vhProvider.vHistory; //cloneList()
    for (var idx = 0; idx < list.length; idx++) {
      final xlsIdx = idx + 2;
      sheet.getRangeByName('A$xlsIdx').setText(readableSeconds(xlsIdx - 1));
      sheet.getRangeByName('B$xlsIdx').setNumber(list[idx]);
    }

    //插入图表
    final charts = officechart.ChartCollection(sheet);
    final chart = charts.add();
    chart.chartType = officechart.ExcelChartType.line;
    chart.dataRange = sheet.getRangeByName('B1:B${_dotNum+2}');
    chart.isSeriesInRows = false;
    chart.hasLegend = false;
    //chart.legend!.position = officechart.ExcelLegendPosition.bottom;
    chart.topRow = 0;
    chart.bottomRow = 24;
    chart.leftColumn = 3;
    chart.rightColumn = 20;
    chart.primaryValueAxis.minimumValue = _vhProvider.minV;
    chart.primaryValueAxis.maximumValue = _vhProvider.maxV;
    
    //final officechart.ChartSerie serie = chart.series[0];
    //serie.dataLabels.isValue = true;
    //serie.dataLabels.isCategoryName = true;
    //serie.dataLabels.isSeriesName = true;
    //serie.dataLabels.textArea.bold = true;
    //serie.dataLabels.textArea.size = 12;
    //serie.dataLabels.textArea.fontName = 'Arial';

    //chart.plotArea.linePattern = officechart.ExcelChartLinePattern.solid;
    //chart.plotArea.linePatternColor = '#00FFFF';
    //chart.linePattern = officechart.ExcelChartLinePattern.longDashDotDot;
    //chart.linePatternColor = '#0000FF';

    sheet.charts = charts;

    //开始保存文件
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    File(fileName).writeAsBytes(bytes);
  }

  ///导出为Txt，一行一个数据
  ///fileName: 路径+文件名
  void exportToTxt(String fileName) async {
    final file = File(fileName);
    final list = _vhProvider.vHistory;
    
    var remarkText = _remarkCtrller.text.trim();
    
    if (Platform.isWindows) {
      if (remarkText.isNotEmpty) {
        remarkText += "\r\n";
      }
      file.writeAsString(remarkText + list.join("\r\n"));
    } else {
      if (remarkText.isNotEmpty) {
        remarkText += "\n";
      }
      file.writeAsString(remarkText + list.join("\n"));
    }
  }

  ///确认权限，如果没有权限，提示需要申请
  void requestPermission([_]) async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      var status = await Permission.storage.status;
      if (!status.isPermanentlyDenied && !status.isDenied) { //之前没有拒绝过
        await Permission.storage.request();
        fetchDefaultExportDir();
      }
    } else {
      fetchDefaultExportDir();
    }
  }

  ///根据系统不同返回默认的导出目录
  void fetchDefaultExportDir() async {
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
    setState((){_folderCtrller.text = ret;});
  }

}
