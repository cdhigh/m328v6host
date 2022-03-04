/// 导出数据页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Save to folder",
      "zh_cn": "保存目录",
    } +
    {
      "en_us": "Save file to this folder",
      "zh_cn": "保存到此目录",
    } +
    {
      "en_us": "Export curva data",
      "zh_cn": "导出曲线数据",
    } +
    {
      "en_us": "Export type",
      "zh_cn": "导出类型",
    } +
    {
      "en_us": "PNG image",
      "zh_cn": "PNG图像",
    } +
    {
      "en_us": "XLSX file",
      "zh_cn": "XLSX 文件",
    } +
    {
      "en_us": "TXT file",
      "zh_cn": "TXT 文件",
    } +
    {
      "en_us": "Export folder",
      "zh_cn": "导出目录",
    } +
    {
      "en_us": "Select a folder to save",
      "zh_cn": "选择一个保存目录",
    } +
    {
      "en_us": "File name",
      "zh_cn": "文件名",
    } +
    {
      "en_us": "Enter a name to save",
      "zh_cn": "输入一个保存文件名",
    } +
    {
      "en_us": "Remark",
      "zh_cn": "备注",
    } +
    {
      "en_us": "Enter a remark",
      "zh_cn": "输入备注信息",
    } +
    {
      "en_us": "Export",
      "zh_cn": "导出",
    } +
    {
      "en_us": "Success",
      "zh_cn": "成功",
    } +
    {
      "en_us": "Export %s file success",
      "zh_cn": "导出 %s 文件成功",
    } +
    {
      "en_us": "Time",
      "zh_cn": "时间",
    } +
    {
      "en_us": "Voltage",
      "zh_cn": "电压",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
