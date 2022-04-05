/// 侧滑菜单页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Settings",
      "zh_cn": "设置",
    } +
    {
      "en_us": "M328v6 Electronic Load",
      "zh_cn": "M328v6 数控电子负载",
    } +
    {
      "en_us": "Device : %s [%s]",
      "zh_cn": "下位机 : %s [%s]",
    } +
    {
      "en_us": "Connect",
      "zh_cn": "连接",
    } +
    {
      "en_us": "Disconnect [%s]",
      "zh_cn": "断开连接 [%s]",
    } +
    {
      "en_us": "Unconnected",
      "zh_cn": "未连接",
    } +
    {
      "en_us": "Connected",
      "zh_cn": "已连接",
    } +
    {
      "en_us": "Load On",
      "zh_cn": "打开负载",
    } +
    {
      "en_us": "Load Off",
      "zh_cn": "关闭负载",
    } +
    {
      "en_us": "Clear Ah",
      "zh_cn": "清除电量",
    } +
    {
      "en_us": "Device Operations",
      "zh_cn": "设备操作",
    } +
    {
      "en_us": "Ra On",
      "zh_cn": "打开交流内阻测试",
    } +
    {
      "en_us": "Ra Off",
      "zh_cn": "关闭交流内阻测试",
    } +
    {
      "en_us": "Zero Ra",
      "zh_cn": "交流内阻调零",
    } +
    {
      "en_us": "Zero I",
      "zh_cn": "电流调零",
    } +
    {
      "en_us": "Clear Time",
      "zh_cn": "运行时间归零",
    } +
    {
      "en_us": "Synchronize Time",
      "zh_cn": "同步下位机时间",
    } +
    {
      "en_us": "Mode",
      "zh_cn": "切换工作模式",
    } +
    {
      "en_us": "Delay On",
      "zh_cn": "预约开负载",
    } +
    {
      "en_us": "Delay Off",
      "zh_cn": "预约关负载",
    } +
    {
      "en_us": "Period On/Off",
      "zh_cn": "周期开关负载",
    } +
    {
      "en_us": "Delay/Period On/Off",
      "zh_cn": "预约/周期开关负载",
    } +
    {
      "en_us": "Turn off Buzzer",
      "zh_cn": "关蜂鸣器",
    } +
    {
      "en_us": "Help",
      "zh_cn": "帮助",
    } +
    {
      "en_us": "Other Operations",
      "zh_cn": "其他操作",
    } +
    {
      "en_us": "Test max capcity",
      "zh_cn": "测试电源输出能力",
    } +
    {
      "en_us": "Test short circuit",
      "zh_cn": "测试电源短路保护",
    } +
    {
      "en_us": "Export",
      "zh_cn": "导出",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
