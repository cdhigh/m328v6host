/// 帮助页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Help",
      "zh_cn": "帮助",
    } +
    {
      "en_us": "Double-click 'Vset' to set a new value",
      "zh_cn": "双击[截止电压]可以设置新的电压值",
    } +
    {
      "en_us": "Double-click 'Iset' to set a new value",
      "zh_cn": "双击[放电电流]可以设置新的电流值",
    } +
    {
      "en_us": "Double-click 'Capacity' to clear Ah of device",
      "zh_cn": "双击[容量]可以清零设备的容量值",
    } +
    {
      "en_us": "Double-click 'Curva area' to clear curva data",
      "zh_cn": "双击[曲线区域]可以清除曲线数据",
    } +
    {
      "en_us": "Swipe on the left side of the screen to popup the menu",
      "zh_cn": "从屏幕左侧往里滑可以弹出操作菜单",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
