/// 主导航页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Connected",
      "zh_cn": "已连接",
    } +
    {
      "en_us": "Connected [OFF]",
      "zh_cn": "已连接 [未放电]",
    } +
    {
      "en_us": "Connected [ON]",
      "zh_cn": "已连接 [正在放电]",
    } +
    {
      "en_us": "Unconnected",
      "zh_cn": "未连接",
    } +
    {
      "en_us": "V Set",
      "zh_cn": "截止电压",
    } +
    {
      "en_us": "I Set",
      "zh_cn": "设置电流",
    } +
    {
      "en_us": "V",
      "zh_cn": "实时电压",
    } +
    {
      "en_us": "I",
      "zh_cn": "实时电流",
    } +
    {
      "en_us": "Power",
      "zh_cn": "输入功率",
    } +
    {
      "en_us": "Capacity",
      "zh_cn": "容量",
    } +
    {
      "en_us": "Energy",
      "zh_cn": "能量",
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
      "en_us": "CC",
      "zh_cn": "恒流模式",
    } +
    {
      "en_us": "CR",
      "zh_cn": "恒阻模式",
    } +
    {
      "en_us": "CP",
      "zh_cn": "恒功率",
    } +
    {
      "en_us": "Heat sink",
      "zh_cn": "散热温度",
    } +
    {
      "en_us": "Board",
      "zh_cn": "主板温度",
    } +
    {
      "en_us": "Confirm",
      "zh_cn": "确认",
    } +
    {
      "en_us": "Clear Ah?",
      "zh_cn": "清除容量?",
    } +
    {
      "en_us": "Clear curva data",
      "zh_cn": "清除曲线数据",
    } +
    {
      "en_us": "Show load stats",
      "zh_cn": "显示放电统计信息",
    } +
    {
      "en_us": "Turn on the electronic load?\nRemember to clear Ah, if needed",
      "zh_cn": "打开负载开始放电?\n如果需要, 记得要先清零安时容量",
    } +
    {
      "en_us": "Turn off the electronic load?",
      "zh_cn": "关闭负载结束放电?",
    } +
    {
      "en_us": "The voltage must be less than 65 volts",
      "zh_cn": "电压必须要小于65伏",
    } +
    {
      "en_us": "The current must be less than 15A",
      "zh_cn": "电流必须要小于15安",
    } +
    {
      "en_us": "Discharge has ended",
      "zh_cn": "放电已经结束",
    } +
    {
      "en_us": "Disconnect",
      "zh_cn": "断开连接",
    } +
    {
      "en_us": "Connect",
      "zh_cn": "连接",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
