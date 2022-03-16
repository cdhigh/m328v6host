/// 测试电源最大供电电流能力页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Warning: This test is very dangerous!",
      "zh_cn": "警告: 此项测试非常危险!",
    } +
    {
      "en_us": "Please do not test the battery.",
      "zh_cn": "请千万不要测试电池.",
    } +
    {
      "en_us": "Before the test, make sure that the power supply has short circuit protection.",
      "zh_cn": "请在测试前确认电源有短路保护功能.",
    } +
    {
      "en_us": "Only for power supply under 10V.",
      "zh_cn": "仅可用于10V以下的电源.",
    }
     +
    {
      "en_us": "Short circuit tester!!!",
      "zh_cn": "电源短路测试!!!",
    } +
    {
      "en_us": "Number of tests",
      "zh_cn": "测试次数",
    } +
    {
      "en_us": "Enter the number of tests",
      "zh_cn": "输入需要的测试次数",
    } +
    {
      "en_us": "short circuit time",
      "zh_cn": "短路时间",
    } +
    {
      "en_us": "Gap time",
      "zh_cn": "间隔时间",
    } +
    {
      "en_us": "Start",
      "zh_cn": "开始",
    } +
    {
      "en_us": "Stop",
      "zh_cn": "停止",
    } +
    {
      "en_us": "Status",
      "zh_cn": "状态",
    } +
    {
      "en_us": "Waiting",
      "zh_cn": "等待命令",
    } +
    {
      "en_us": "Shorted",
      "zh_cn": "已短路",
    } +
    {
      "en_us": "In the gap",
      "zh_cn": "在短路间隙中",
    } +
    {
      "en_us": "Voltage",
      "zh_cn": "实时电压",
    } +
    {
      "en_us": "Current",
      "zh_cn": "实时电流",
    } +
    {
      "en_us": "Test progress",
      "zh_cn": "测试进度",
    } +
    {
      "en_us": "Number of tests is invalid",
      "zh_cn": "测试次数数值非法",
    } +
    {
      "en_us": "Power supply not connected",
      "zh_cn": "电源未连接",
    } +
    {
      "en_us": "Voltage is too high",
      "zh_cn": "电源电压太高",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
