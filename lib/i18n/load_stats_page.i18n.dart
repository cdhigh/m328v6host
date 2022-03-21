/// 放电统计信息页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Load Stats",
      "zh_cn": "放电统计信息",
    } +
    {
      "en_us": "Export",
      "zh_cn": "导出",
    } +
    {
      "en_us": "No data",
      "zh_cn": "没有数据",
    } +
    {
      "en_us": "Click to add remark",
      "zh_cn": "点击添加备注",
    } +
    {
      "en_us": "Input a remark",
      "zh_cn": "输入备注",
    } +
    {
      "en_us": "Initial V",
      "zh_cn": "初始电压",
    } +
    {
      "en_us": "End V",
      "zh_cn": "结束电压",
    } +
    {
      "en_us": "Average V",
      "zh_cn": "平均电压",
    } +
    {
      "en_us": "Initial I",
      "zh_cn": "初始电流",
    } +
    {
      "en_us": "End I",
      "zh_cn": "结束电流",
    } +
    {
      "en_us": "Average I",
      "zh_cn": "平均电流",
    } +
    {
      "en_us": "Initial Ah",
      "zh_cn": "初始安时",
    } +
    {
      "en_us": "Ah",
      "zh_cn": "本次安时",
    } +
    {
      "en_us": "Total Ah",
      "zh_cn": "总安时",
    } +
    {
      "en_us": "Initial Wh",
      "zh_cn": "初始瓦时",
    } +
    {
      "en_us": "Wh",
      "zh_cn": "本次瓦时",
    } +
    {
      "en_us": "Total Wh",
      "zh_cn": "总瓦时",
    } +
    {
      "en_us": "Mode",
      "zh_cn": "放电模式",
    } +
    {
      "en_us": "CC",
      "zh_cn": "恒流",
    } +
    {
      "en_us": "CR",
      "zh_cn": "恒阻",
    } +
    {
      "en_us": "CP",
      "zh_cn": "恒功率",
    } +
    {
      "en_us": "CR value",
      "zh_cn": "恒阻值",
    } +
    {
      "en_us": "CP value",
      "zh_cn": "恒功率值",
    } +
    {
      "en_us": "Rd",
      "zh_cn": "直流内阻",
    } +
    {
      "en_us": "Ra",
      "zh_cn": "交流内阻",
    } +
    {
      "en_us": "Head sink",
      "zh_cn": "散热器温度",
    } +
    {
      "en_us": "Board",
      "zh_cn": "主板温度",
    } +
    {
      "en_us": "Start time",
      "zh_cn": "开始时间",
    } +
    {
      "en_us": "End time",
      "zh_cn": "结束时间",
    } +
    {
      "en_us": "Duration",
      "zh_cn": "持续时间",
    } +
    {
      "en_us": "Export load stats data",
      "zh_cn": "导出放电统计数据",
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
      "en_us": "Success",
      "zh_cn": "成功",
    } +
    {
      "en_us": "Export load stats file success",
      "zh_cn": "导出放电统计信息文件成功",
    } +
    {
      "en_us": "Item",
      "zh_cn": "条目",
    } +
    {
      "en_us": "Value",
      "zh_cn": "数值",
    } +
    {
      "en_us": "Unit",
      "zh_cn": "单位",
    } +
    {
      "en_us": "Remark",
      "zh_cn": "备注",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
