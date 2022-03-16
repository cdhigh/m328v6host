/// 测试电源最大供电电流能力页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Test PSU max capacity",
      "zh_cn": "测试电源输出能力",
    } +
    {
      "en_us": "Parameters",
      "zh_cn": "参数配置",
    } +
    {
      "en_us": "Start test current (A)",
      "zh_cn": "起始测试电流 (安)",
    } +
    {
      "en_us": "End test current (A)",
      "zh_cn": "终止测试电流 (安)",
    } +
    {
      "en_us": "Current step (A)",
      "zh_cn": "电流步进 (安)",
    } +
    {
      "en_us": "Step time",
      "zh_cn": "步进时间",
    } +
    {
      "en_us": "End condition",
      "zh_cn": "结束条件",
    } +
    {
      "en_us": "Voltage drop (%)",
      "zh_cn": "电压跌落百分比",
    } +
    {
      "en_us": "Voltage drop (V)",
      "zh_cn": "电压跌落数值",
    } +
    {
      "en_us": "End voltage (V)",
      "zh_cn": "截止电压",
    } +
    {
      "en_us": "Start",
      "zh_cn": "开始",
    } +
    {
      "en_us": "Process and results",
      "zh_cn": "过程与结果",
    } +
    {
      "en_us": "Max power",
      "zh_cn": "最大功率",
    } +
    {
      "en_us": "Max current",
      "zh_cn": "最大电流",
    } +
    {
      "en_us": "Status",
      "zh_cn": "状态",
    } +
    {
      "en_us": "Pause",
      "zh_cn": "暂停",
    } +
    {
      "en_us": "Stop",
      "zh_cn": "停止",
    } +
    {
      "en_us": "Start current value is invalid",
      "zh_cn": "起始电流值非法",
    } +
    {
      "en_us": "End current value is invalid",
      "zh_cn": "结束电流值非法",
    } +
    {
      "en_us": "Current step value is invalid",
      "zh_cn": "电流步进值非法",
    } +
    {
      "en_us": "The voltage drop percentage is invalid",
      "zh_cn": "电压跌落百分比非法",
    } +
    {
      "en_us": "The voltage drop value is invalid",
      "zh_cn": "电压跌落值非法",
    } +
    {
      "en_us": "The end voltage value is invalid",
      "zh_cn": "截止电压值非法",
    } +
    {
      "en_us": "Finish",
      "zh_cn": "结束",
    } +
    {
      "en_us": "Testing",
      "zh_cn": "正在测试",
    } +
    {
      "en_us": "Waiting",
      "zh_cn": "等待命令",
    } +
    {
      "en_us": "Current voltage",
      "zh_cn": "当前电压",
    } +
    {
      "en_us": "Resume",
      "zh_cn": "恢复",
    } +
    {
      "en_us": "Paused",
      "zh_cn": "已暂停",
    } +
    {
      "en_us": "Stopped",
      "zh_cn": "已停止",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
