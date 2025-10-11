/// m328v6数控电子负载上位机
/// 配置页面ui实现
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/globals.dart';
import '../common/my_widget_chain.dart';
import '../common/widget_utils.dart';
import '../common/event_bus.dart';
import '../models/connection_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/colored_indicator.dart';
import '../widgets/modal_dialogs.dart';
import '../widgets/widget_with_check.dart';
import '../version_update/version_check.dart';
import 'setting_tile.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    return Container(padding: const EdgeInsets.all(15), child: ListView(children: [
      //通用组
      buildSettingGroupTile(AppLocalizations.of(context)!.general),
      SettingTile(title: AppLocalizations.of(context)!.language, subTitle: displaySelectedLanguage())
        .intoInkWell(onTap: onTapChangeLanguage),
      SettingTile(title: AppLocalizations.of(context)!.theme, subTitle: displaySelectedTheme())
        .intoInkWell(onTap: onTapChangeTheme),
      SettingTile(title: AppLocalizations.of(context)!.homepageBackgroundColor, subTitle: displayHomeBkColor())
        .intoInkWell(onTap: onTapHomePageBackgroundColor),
      SettingTile(title: AppLocalizations.of(context)!.keepScreenOn, subTitle: displaySelectedScreenOn())
        .intoInkWell(onTap: onTapKeepScreenOn),
      
      //数据组
      buildSettingGroupTile(AppLocalizations.of(context)!.data),
      SettingTile(title: AppLocalizations.of(context)!.autoReconnect, subTitle: AppLocalizations.of(context)!.autoReconnectIfConnectionInterruption,
          switchValue: Global.autoReconnect, switchCallback: onTapAutoReconnect)
        .intoGestureDetector(onTap: onTapAutoReconnect),
      SettingTile(title: AppLocalizations.of(context)!.autoSynchronizeTime, subTitle: AppLocalizations.of(context)!.autoSynchronizeTimeToLoad,
          switchValue: Global.autoSynchronizeTime, switchCallback: onTapAutoSynchronizeTime)
        .intoGestureDetector(onTap: onTapAutoSynchronizeTime),
      SettingTile(title: AppLocalizations.of(context)!.numberOfPointsForSmoothCurve, subTitle: Text(Global.curvaFilterDotNum.toString()))
        .intoInkWell(onTap: onTapDotSmoothNum),
      SettingTile(title: AppLocalizations.of(context)!.thresholdForSmoothCurve, subTitle: Text("${Global.curvaFilterThreshold.toStringAsFixed(3)} V"))
        .intoInkWell(onTap: onTapSmoothThreshold),
      SettingTile(title: AppLocalizations.of(context)!.curveLineStartColor, subTitle: displayCurvaStartColor())
        .intoInkWell(onTap: onTapCurvaStartColor),
      SettingTile(title: AppLocalizations.of(context)!.curveLineEndColor, subTitle: displayCurvaEndColor())
        .intoInkWell(onTap: onTapCurvaEndColor),

      //版本号
      buildSettingGroupTile(AppLocalizations.of(context)!.version),
      SettingTile(title: AppLocalizations.of(context)!.currentVersion, subTitle: (Global.version != "") ? ("V${Global.version}") : ""),
      SettingTile(title: AppLocalizations.of(context)!.checkFrequency, subTitle: displayCheckFrequency())
        .intoInkWell(onTap: onTapCheckFrequency),
      SettingTile(title: AppLocalizations.of(context)!.checkForUpdateNow, subTitle: "https//github.com/cdhigh/m328v6host")
        .intoInkWell(onTap: checkUpdateNow, onLongPress: () {
          pasteText("https//github.com/cdhigh/m328v6host");
          showToast(AppLocalizations.of(context)!.theLinkOfTheOfficialSiteHasBeenCopiedToTheClipboard);
        }),

      const SizedBox(height: 100),
    ]));
  }

  ///设置界面的分组标题
  Widget buildSettingGroupTile(String title) {
    return Text(title, style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold))
      .intoContainer(height: 41.0, padding: const EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.centerLeft,
        decoration: containerDivider(bottom: true, bkColor: Colors.transparent),
      );
  }

  ///根据选择的语种，显示更人性的名字
  String displaySelectedLanguage() {
    switch (Global.selectedLanguage) {
      case 'en':
        return 'English';  //不翻译英语，保证任何时候都能识别
      case 'zh_CN':
        return AppLocalizations.of(context)!.chinese;
      default:
        return AppLocalizations.of(context)!.auto;
    }
  }

  ///点击了选择语种，弹出对话框供选择
  void onTapChangeLanguage() async {
    //简单的闭包函数，根据当前自动登出时间创建不同的对话框行
    Widget dialogOptionOnLanguage(String title, String lang) {
      return SimpleDialogOption(onPressed: () => Navigator.of(context).pop<String>(lang),
        child: (Global.selectedLanguage == lang) ? WidgetWithCheck(Text(title)) : Text(title));
    }

    String? ret = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(AppLocalizations.of(context)!.language),
          children: <Widget>[
            const Divider(),
            dialogOptionOnLanguage(AppLocalizations.of(context)!.auto, ''),
            const Divider(),
            dialogOptionOnLanguage('English', 'en'),
            const Divider(),
            dialogOptionOnLanguage(AppLocalizations.of(context)!.chinese, 'zh_CN'),
          ]);
        }
      );

    if (ret != null) {
      ref.watch(Global.infoProvider).setLanguage(ret);
    }
    }

  ///根据选择的主题，显示翻译后的名字
  String displaySelectedTheme() {
    switch (Global.selectedTheme) {
      //case 'dark':
      //  return 'Dark';
      case 'green':
        return AppLocalizations.of(context)!.green;
      case 'blueGrey':
        return AppLocalizations.of(context)!.blueGrey;
      case 'brown':
        return AppLocalizations.of(context)!.brown;
      case 'cyan':
        return AppLocalizations.of(context)!.cyan;
      case 'lightBlue':
        return AppLocalizations.of(context)!.lightBlue;
      case 'orange':
        return AppLocalizations.of(context)!.orange;
      case 'pink':
        return AppLocalizations.of(context)!.pink;
      case 'red':
        return AppLocalizations.of(context)!.red;
      case 'teal':
        return AppLocalizations.of(context)!.teal;
      case 'lime':
        return AppLocalizations.of(context)!.lime;
      case 'blue':
        return AppLocalizations.of(context)!.blue;
      default:
        return AppLocalizations.of(context)!.auto;
    }
  }

  ///点击了选择主题
  void onTapChangeTheme() async {
    //简单的闭包函数，根据当前自动登出时间创建不同的对话框行
    Widget dialogOptionOnColor(String title, String mark, Color color) {
      return SimpleDialogOption(onPressed: () => Navigator.of(context).pop<String>(mark),
              child: SettingsThemeTile(title: title, mark: mark, color: color));
    }

    String? ret = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(AppLocalizations.of(context)!.theme),
          children: <Widget>[
            const Divider(),
            dialogOptionOnColor(AppLocalizations.of(context)!.auto, '', Colors.lime),
            dialogOptionOnColor(AppLocalizations.of(context)!.blue, 'blue', Colors.blue),
            //dialogOptionOnColor('Dark', 'dark', Colors.black),
            dialogOptionOnColor(AppLocalizations.of(context)!.green, 'green', Colors.green),
            dialogOptionOnColor(AppLocalizations.of(context)!.blueGrey, 'blueGrey', Colors.blueGrey),
            dialogOptionOnColor(AppLocalizations.of(context)!.brown, 'brown', Colors.brown),
            dialogOptionOnColor(AppLocalizations.of(context)!.cyan, 'cyan', Colors.cyan),
            dialogOptionOnColor(AppLocalizations.of(context)!.lightBlue, 'lightBlue', Colors.lightBlue),
            dialogOptionOnColor(AppLocalizations.of(context)!.orange, 'orange', Colors.orange),
            dialogOptionOnColor(AppLocalizations.of(context)!.pink, 'pink', Colors.pink),
            dialogOptionOnColor(AppLocalizations.of(context)!.red, 'red', Colors.red),
            dialogOptionOnColor(AppLocalizations.of(context)!.teal, 'teal', Colors.teal),
            dialogOptionOnColor(AppLocalizations.of(context)!.lime, 'lime', Colors.lime),
          ]);
        }
      );

    ref.watch(Global.infoProvider).setTheme(ret ?? '');
    }

  ///构建主页背景颜色显示块
  Widget displayHomeBkColor() {
    return ColoredIndicator(
      color: Global.homePageBackgroundColor,
      size: (Global.currentTheme?.textTheme.bodyMedium?.fontSize ?? 14.0) * 0.9,
      text: "0x${Global.homePageBackgroundColor.value.toRadixString(16).padLeft(8, '0')}",
      fontBold: false,
      //textColor: Colors.white38,
    );
  }

  ///构建放电曲线开始颜色
  Widget displayCurvaStartColor() {
    return ColoredIndicator(
      color: Global.curvaStartColor,
      size: (Global.currentTheme?.textTheme.bodyMedium?.fontSize ?? 14.0) * 0.9,
      text: "0x${Global.curvaStartColor.value.toRadixString(16).padLeft(8, '0')}",
      fontBold: false,
      //textColor: Colors.white38,
    );
  }

  ///构建放电曲线结束颜色
  Widget displayCurvaEndColor() {
    return ColoredIndicator(
      color: Global.curvaEndColor,
      size: (Global.currentTheme?.textTheme.bodyMedium?.fontSize ?? 14.0) * 0.9,
      text: "0x${Global.curvaEndColor.value.toRadixString(16).padLeft(8, '0')}",
      fontBold: false,
      //textColor: Colors.white38,
    );
  }

  ///点击了选择主页背景颜色
  void onTapHomePageBackgroundColor() async {
    final appInfo = ref.watch(Global.infoProvider);
    var newColor = await showColorPickerDialog(context: context, initialColor: Global.homePageBackgroundColor);
    if (newColor != null) {
      appInfo.setHomePageBackgroundColor(newColor);
    }
  }

  ///点击了选择曲线开始颜色
  void onTapCurvaStartColor() async {
    final appInfo = ref.watch(Global.infoProvider);
    var newColor = await showColorPickerDialog(context: context, initialColor: Global.curvaStartColor);
    if (newColor != null) {
      appInfo.setCurvaColor(startColor: newColor);
    }
  }

  ///点击了选择曲线结束颜色
  void onTapCurvaEndColor() async {
    final appInfo = ref.watch(Global.infoProvider);
    var newColor = await showColorPickerDialog(context: context, initialColor: Global.curvaEndColor);
    if (newColor != null) {
      appInfo.setCurvaColor(endColor: newColor);
    }
  }

  ///构建'保持屏幕常亮'显示项
  String displaySelectedScreenOn() {
    switch (Global.keepScreenOn) {
      case KeepScreenOption.never:
        return AppLocalizations.of(context)!.doesNotKeepTheScreenAlwaysOn;
      case KeepScreenOption.onWhenDischarge:
        return AppLocalizations.of(context)!.keepScreenOnDuringDischarge;
      default:
        return AppLocalizations.of(context)!.keepScreenOnWhileTheAppIsRunning;
    }
  }

  ///点击了‘保持屏幕常亮’功能，弹出选项对话框选择
  void onTapKeepScreenOn() async {
    //简单的闭包函数，根据当前屏幕常亮选项创建不同的对话框行
    Widget dialogOptionOnScrOn(String title, KeepScreenOption opt) {
      return SimpleDialogOption(onPressed: () => Navigator.of(context).pop<KeepScreenOption>(opt),
        child: (Global.keepScreenOn == opt) ? WidgetWithCheck(Text(title)) : Text(title));
    }

    KeepScreenOption? ret = await showDialog<KeepScreenOption>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(AppLocalizations.of(context)!.keepScreenOn),
          children: <Widget>[
            const Divider(),
            dialogOptionOnScrOn(AppLocalizations.of(context)!.doesNotKeepOn, KeepScreenOption.never),
            const Divider(),
            dialogOptionOnScrOn(AppLocalizations.of(context)!.duringDischarging, KeepScreenOption.onWhenDischarge),
            const Divider(),
            dialogOptionOnScrOn(AppLocalizations.of(context)!.duringAppRunning, KeepScreenOption.always),
          ]);
        }
      );

    setState(() => Global.keepScreenOn = ret ?? KeepScreenOption.never);
    Global.saveProfile();
    if (Global.keepScreenOn == KeepScreenOption.never) {
      WakelockPlus.disable();
    } else if (Global.keepScreenOn == KeepScreenOption.always) {
      WakelockPlus.enable();
    }
    }

  ///点击了‘自动重连’功能
  void onTapAutoReconnect([_]) {
    setState(() => Global.autoReconnect = !Global.autoReconnect);
    Global.saveProfile();
  }

  ///点击了“自动同步时间”功能
  void onTapAutoSynchronizeTime([_]) {
    setState(() => Global.autoSynchronizeTime = !Global.autoSynchronizeTime);
    Global.saveProfile();
    if (Global.autoSynchronizeTime) {
      final load = ref.read<ConnectionProvider>(Global.connectionProvider).load;
      load.synchronizeTime();
    }
  }

  ///点击了“用于平滑曲线的点数”
  void onTapDotSmoothNum() async {
    //简单的闭包函数，根据当前平滑点数创建不同的对话框行
    Widget dialogOptionOnDotNum(int dotNum) {
      return SimpleDialogOption(onPressed: () => Navigator.of(context).pop<int>(dotNum),
        child: (Global.curvaFilterDotNum == dotNum) ? WidgetWithCheck(Text(dotNum.toString())) : Text(dotNum.toString()));
    }

    int? ret = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(AppLocalizations.of(context)!.numberOfPoints),
          children: <Widget>[
            const Divider(),
            dialogOptionOnDotNum(1),
            const Divider(),
            dialogOptionOnDotNum(2),
            const Divider(),
            dialogOptionOnDotNum(3),
            const Divider(),
            dialogOptionOnDotNum(4),
            const Divider(),
            dialogOptionOnDotNum(5),
            const Divider(),
            dialogOptionOnDotNum(6),
            const Divider(),
            dialogOptionOnDotNum(7),
            const Divider(),
            dialogOptionOnDotNum(8),
            const Divider(),
            dialogOptionOnDotNum(9),
          ]);
        }
      );

    if ((ret != null) && (ret > 0) && (ret < 10)) {
      setState(() {Global.curvaFilterDotNum = ret;});
      Global.bus.sendBroadcast(EventBus.curvaFilterDotNumChanged, arg: ret.toString());
    }
  }

  ///点击了曲线平滑阀值
  void onTapSmoothThreshold() async {
    String? ret = await showInputDialog(context: context,
      title: AppLocalizations.of(context)!.enterAValueFrom0000To1000V,
      initialText: Global.curvaFilterThreshold.toStringAsFixed(3),
      //formatters: [DecimalTextInputFormatter(), CustomMaxValueInputFormatter(1.0)],
    );

    if (ret != null) {
      final value = double.tryParse(ret);
      if ((value == null) || (value < 0.0) || (value > 1.0)) {
        showToast(AppLocalizations.of(context)!.theValueMustBeGreaterThan0000AndLessThan1000);
      } else {
        setState(() {Global.curvaFilterThreshold = value;});
      }
    }
  }

  ///显示检查新版本频率
  String displayCheckFrequency() {
    switch (Global.checkUpdateFrequency) {
      case 0:
        return AppLocalizations.of(context)!.never;
      case 7:
        return AppLocalizations.of(context)!.oneWeek;
      case 30:
        return AppLocalizations.of(context)!.oneMonth;
      case 360:
        return AppLocalizations.of(context)!.oneYear;
      default:
        return AppLocalizations.of(context)!.days(Global.checkUpdateFrequency.toString());
    }
  }

  ///点击了检查新版本频率，弹出选项菜单
  void onTapCheckFrequency() async {
    //简单的闭包函数，根据当前平滑点数创建不同的对话框行
    Widget dialogOptionOnDayNum(String title, int dayNum) {
      return SimpleDialogOption(onPressed: () => Navigator.of(context).pop<int>(dayNum),
        child: (Global.checkUpdateFrequency == dayNum) ? WidgetWithCheck(Text(title)) : Text(title));
    }

    int? ret = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(AppLocalizations.of(context)!.checkFrequency),
          children: <Widget>[
            const Divider(),
            dialogOptionOnDayNum(AppLocalizations.of(context)!.never, 0),
            const Divider(),
            dialogOptionOnDayNum(AppLocalizations.of(context)!.oneWeek, 7),
            const Divider(),
            dialogOptionOnDayNum(AppLocalizations.of(context)!.oneMonth, 30),
            const Divider(),
            dialogOptionOnDayNum(AppLocalizations.of(context)!.oneYear, 360),
          ]);
        }
      );

    setState(() {Global.checkUpdateFrequency = ret ?? 0;});
    Global.saveProfile();
    }

  ///点击了现在检查新版本
  void checkUpdateNow() async {
    final newVer = await checkUpdate(context, silent: false);
    if (newVer == null) {
      return;
    }

    final newVerNo = newVer.version;
    final whatsnew = newVer.whatsNew.replaceAll("<br/>", "\n");
    final ret = await showOkCancelAlertDialog(context: context, title: AppLocalizations.of(context)!.foundNewVersion(newVerNo), 
      okText: AppLocalizations.of(context)!.download,
      content:  Column(mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.whatsnew, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(whatsnew),
          const Divider(),
          Padding(padding: const EdgeInsets.only(top: 20), 
            child: Text(AppLocalizations.of(context)!.theDownloadLinkHasBeenCopiedToTheClipboard, textScaleFactor: 0.8)),
        ],),
    );
    if (ret == true) {
      if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
        launch(newVer.androidFile);
      } else {
        launch(newVer.windowsFile);
      }
    }
  }
   
}
