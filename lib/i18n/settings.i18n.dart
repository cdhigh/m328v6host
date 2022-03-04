// 配置页面的国际化翻译文件
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("en_us") +
    {
      "en_us": "Settings",
      "zh_cn": "设置",
    } +
    {
      "en_us": "External storage directory",
      "zh_cn": "外部存储目录",
    } +
    {
      "en_us": "App document directory",
      "zh_cn": "应用文档目录",
    } +
    {
      "en_us": "Prompt",
      "zh_cn": "提示",
    } +
    {
      "en_us": "Cancel",
      "zh_cn": "取消",
    } +
    {
      "en_us": "Clear",
      "zh_cn": "清除",
    } +
    {
      "en_us": "Yes",
      "zh_cn": "确定",
    } +
    {
      "en_us": "General",
      "zh_cn": "通用",
    } +
    {
      "en_us": "Keep screen on",
      "zh_cn": "保持屏幕常亮",
    } +
    {
      "en_us": "Does not keep the screen always on",
      "zh_cn": "不保持屏幕常亮",
    } +
    {
      "en_us": "Keep the screen on during discharge",
      "zh_cn": "在放电过程中保持屏幕常亮",
    } +
    {
      "en_us": "Keep the screen on while the app is running",
      "zh_cn": "在应用运行时保持屏幕常亮",
    } +
    {
      "en_us": "Does not keep on",
      "zh_cn": "不保持屏幕常亮",
    } +
    {
      "en_us": "During discharging",
      "zh_cn": "在放电过程中",
    } +
    {
      "en_us": "During app running",
      "zh_cn": "在应用运行时",
    } +
    {
      "en_us": "Auto",
      "zh_cn": "自动",
    } +
    {
      "en_us": "English",
      "zh_cn": "英语",
    } +
    {
      "en_us": "Chinese",
      "zh_cn": "简体汉语",
    } +
    {
      "en_us": "Language",
      "zh_cn": "语种",
    } +
    {
      "en_us": "Restart required",
      "zh_cn": "需要重启",
    } +
    {
      "en_us": "You need to restart the application to apply the language change",
      "zh_cn": "您需要重新启动应用程序以应用语言更改",
    } +
    {
      "en_us": "Theme",
      "zh_cn": "主题",
    } +
    {
      "en_us": "Light",
      "zh_cn": "浅色",
    } +
    {
      "en_us": "Dark",
      "zh_cn": "深色",
    } +
    {
      "en_us": "Homepage background color",
      "zh_cn": "主页背景颜色",
    } +
    {
      "en_us": "Blue",
      "zh_cn": "蓝色",
    } +
    {
      "en_us": "Green",
      "zh_cn": "绿色",
    } +
    {
      "en_us": "Blue Grey",
      "zh_cn": "蓝灰色",
    } +
    {
      "en_us": "Brown",
      "zh_cn": "棕色",
    } +
    {
      "en_us": "Cyan",
      "zh_cn": "青色",
    } +
    {
      "en_us": "Light Blue",
      "zh_cn": "浅蓝色",
    } +
    {
      "en_us": "Orange",
      "zh_cn": "橙色",
    } +
    {
      "en_us": "Pink",
      "zh_cn": "粉红色",
    } +
    {
      "en_us": "Red",
      "zh_cn": "红色",
    } +
    {
      "en_us": "Teal",
      "zh_cn": "蓝绿色",
    } +
    {
      "en_us": "Lime",
      "zh_cn": "青橙绿色",
    } +
    {
      "en_us": "Links",
      "zh_cn": "关联链接",
    } +
    {
      "en_us": "Version",
      "zh_cn": "版本",
    } +
    {
      "en_us": "Current version",
      "zh_cn": "当前版本",
    } +
    {
      "en_us": "Check frequency",
      "zh_cn": "检查新版本频率",
    } +
    {
      "en_us": "Check for update now",
      "zh_cn": "现在检查更新",
    } +
    {
      "en_us": "Unable to determine your version number",
      "zh_cn": "不能确定您的版本号",
    } +
    {
      "en_us": "Data",
      "zh_cn": "数据",
    } +
    {
      "en_us": "Auto reconnect",
      "zh_cn": "自动重连",
    } +
    {
      "en_us": "Auto reconnect after connection interruption",
      "zh_cn": "连接异常断开后自动尝试重新连接",
    } +
    {
      "en_us": "Number of points for smooth curve",
      "zh_cn": "用于平滑曲线的点数",
    } +
    {
      "en_us": "Number of points",
      "zh_cn": "平滑点数",
    } +
    {
      "en_us": "Curve line start color",
      "zh_cn": "放电曲线开始颜色",
    } +
    {
      "en_us": "Curve line end color",
      "zh_cn": "放电曲线结束颜色",
    } +
    {
      "en_us": "Never",
      "zh_cn": "从不",
    } +
    {
      "en_us": "One week",
      "zh_cn": "一个星期",
    } +
    {
      "en_us": "One month",
      "zh_cn": "一个月",
    } +
    {
      "en_us": "One year",
      "zh_cn": "一年",
    } +
    {
      "en_us": "%s days",
      "zh_cn": "%s 天",
    } +
    {
      "en_us": "Threshold for smooth curve",
      "zh_cn": "曲线平滑电压门限",
    } +
    {
      "en_us": "Enter a value from 0.00 to 1.00 (V)",
      "zh_cn": "输入一个0.00到1.00的数值 (伏)",
    } +
    {
      "en_us": "The value must be greater than 0.00 and less than 1.00",
      "zh_cn": "数值必须大于0.00并且小于1.00",
    } +
    {
      "en_us": "Found new version [%s]",
      "zh_cn": "发现新版本 [%s]",
    } +
    {
      "en_us": "Whatsnew:",
      "zh_cn": "版本特性:",
    } +
    {
      "en_us": "[The download link has been copied to the clipboard]",
      "zh_cn": "[下载链接已经拷贝到系统剪贴板]",
    };

  String get i18n => localize(this, t);
  
  //"Hello %s, this is %s".i18n.fill(["John", "Mary"])
  String fill(List<Object> params) => localizeFill(this, params);
}
