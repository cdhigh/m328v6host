/// 一些公共的简单的翻译的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Okay",
      "zh_cn": "好的",
    } +
    {
      "en_us": "Cancel",
      "zh_cn": "取消",
    } +
    {
      "en_us": "Start",
      "zh_cn": "开始",
    } +
    {
      "en_us": "End",
      "zh_cn": "结束",
    } +
    {
      "en_us": "No item",
      "zh_cn": "没有项目",
    } +
    {
      "en_us": "No data",
      "zh_cn": "没有数据",
    } +
    {
      "en_us": "Items: %s",
      "zh_cn": "条目: %s",
    } +
    {
      "en_us": "Choose",
      "zh_cn": "选择",
    } +
    {
      "en_us": "[Empty]",
      "zh_cn": "[空白]",
    } +
    {
      "en_us": "Input new text",
      "zh_cn": "输入新文本",
    } +
    {
      "en_us": "Search",
      "zh_cn": "搜索",
    } +
    {
      "en_us": "Connection timeout",
      "zh_cn": "连接超时",
    } +
    {
      "en_us": "Timeout",
      "zh_cn": "超时错误",
    } +
    {
      "en_us": "Pick a color",
      "zh_cn": "选取一个颜色",
    } +
    {
      "en_us": "Date",
      "zh_cn": "日期",
    } +
    {
      "en_us": "Check for update failed",
      "zh_cn": "检查更新失败",
    } +
    {
      "en_us": "Your version is up to date",
      "zh_cn": "您的版本为最新的",
    } +
    {
      "en_us": "There is a new version (%s), the download link has been copied to the clipboard",
      "zh_cn": "发现新版本(%s), 下载链接已经拷贝到系统剪贴板",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
