/// 切换工作模式页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Switch Mode",
      "zh_cn": "切换模式",
    } +
    {
      "en_us": "CC Mode",
      "zh_cn": "恒流模式",
    } +
    {
      "en_us": "CR Mode",
      "zh_cn": "恒阻模式",
    } +
    {
      "en_us": "CP Mode",
      "zh_cn": "恒功率模式",
    } +
    {
      "en_us": "set the resistor value (Ohm)",
      "zh_cn": "设置阻值 (欧姆)",
    } +
    {
      "en_us": "set the power value (W)",
      "zh_cn": "设置功率 (瓦)",
    } +
    {
      "en_us": "Set",
      "zh_cn": "设置",
    } +
    {
      "en_us": "Error",
      "zh_cn": "错误",
    } +
    {
      "en_us": "Resistor value is invalid",
      "zh_cn": "阻值非法",
    } +
    {
      "en_us": "Power value is invalid",
      "zh_cn": "功率值非法",
    } +
    {
      "en_us": "Success",
      "zh_cn": "成功",
    } +
    {
      "en_us": "set CC mode successfully",
      "zh_cn": "设置 恒流模式 成功",
    } +
    {
      "en_us": "set CR mode successfully",
      "zh_cn": "设置 恒阻模式 成功",
    } +
    {
      "en_us": "set CP mode successfully",
      "zh_cn": "设置 恒功率模式 成功",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
