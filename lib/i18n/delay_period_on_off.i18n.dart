/// 预约/周期开关机页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Delay&Period",
      "zh_cn": "预约&周期",
    } +
    {
      "en_us": "Current Status",
      "zh_cn": "当前状态",
    } +
    {
      "en_us": "set Delay on",
      "zh_cn": "设置预约开时间",
    } +
    {
      "en_us": "set Delay off",
      "zh_cn": "设置预约关时间",
    } +
    {
      "en_us": "set Period On/Off",
      "zh_cn": "设置周期开关时间",
    } +
    {
      "en_us": "Delay on   : %s",
      "zh_cn": "预约开负载  : %s",
    } +
    {
      "en_us": "Delay off  : %s",
      "zh_cn": "预约关负载  : %s",
    } +
    {
      "en_us": "Period on  : %s",
      "zh_cn": "周期开时间  : %s",
    } +
    {
      "en_us": "Period off : %s",
      "zh_cn": "周期关时间  : %s",
    } +
    {
      "en_us": "Delay on time",
      "zh_cn": "在此时间后开启",
    } +
    {
      "en_us": "Set",
      "zh_cn": "设置",
    } +
    {
      "en_us": "Delay off time",
      "zh_cn": "在此时间后关闭",
    } +
    {
      "en_us": "Period on time",
      "zh_cn": "周期开启时间",
    } +
    {
      "en_us": "Period off time",
      "zh_cn": "周期关闭时间",
    } +
    {
      "en_us": "Time must be less than 18 hours",
      "zh_cn": "时间必须小于18小时",
    } +
    {
      "en_us": "Success",
      "zh_cn": "成功",
    } +
    {
      "en_us": "set Delay On successfully",
      "zh_cn": "设置 预约开负载 成功",
    } +
    {
      "en_us": "set Delay Off successfully",
      "zh_cn": "设置 预约关负载 成功",
    } +
    {
      "en_us": "set Period On/Off successfully",
      "zh_cn": "设置 周期开关负载 成功",
    } +
    {
      "en_us": "On time",
      "zh_cn": "开通时间",
    } +
    {
      "en_us": "Off time",
      "zh_cn": "关断时间",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
