/// 连接页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Connection",
      "zh_cn": "串口连接",
    } +
    {
      "en_us": "Available devices",
      "zh_cn": "可用的设备",
    } +
    {
      "en_us": "Baud rate",
      "zh_cn": "波特率",
    } +
    {
      "en_us": "Connect",
      "zh_cn": "连接",
    } +
    {
      "en_us": "Baud rate is invalid",
      "zh_cn": "波特率非法",
    } +
    {
      "en_us": "No device",
      "zh_cn": "没有设备",
    } +
    {
      "en_us": "Open device failed",
      "zh_cn": "打开设备失败",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
