/// m328v6数控电子负载上位机
/// 配置页面ui实现
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/globals.dart';
import '../common/my_widget_chain.dart';
import '../common/widget_utils.dart';
import '../common/event_bus.dart';
import '../i18n/settings.i18n.dart';
import '../widgets/colored_indicator.dart';
import '../widgets/modal_dialogs.dart';
import '../widgets/widget_with_check.dart';
import '../version_update/version_check.dart';
import 'setting_tile.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
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
      appBar: AppBar(title: Text('Settings'.i18n)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    return Container(padding: const EdgeInsets.all(15), child: ListView(children: [
      //通用组
      buildSettingGroupTile('General'.i18n),
      SettingTile(title: 'Language', subTitle: displaySelectedLanguage())
        .intoInkWell(onTap: onTapChangeLanguage),
      SettingTile(title: 'Theme'.i18n, subTitle: displaySelectedTheme())
        .intoInkWell(onTap: onTapChangeTheme),
      SettingTile(title: 'Homepage background color'.i18n, subTitle: displayHomeBkColor())
        .intoInkWell(onTap: onTapHomePageBackgroundColor),
      SettingTile(title: 'Keep screen on'.i18n, subTitle: displaySelectedScreenOn())
        .intoInkWell(onTap: onTapKeepScreenOn),
      
      //数据组
      buildSettingGroupTile('Data'.i18n),
      SettingTile(title: 'Auto reconnect'.i18n, subTitle: 'Auto reconnect if connection interruption'.i18n,
            switchValue: Global.autoReconnect, switchCallback: (_)=>onTapAutoReconnect())
          .intoGestureDetector(onTap: onTapAutoReconnect),
      SettingTile(title: 'Number of points for smooth curve'.i18n, subTitle: Text(Global.curvaFilterDotNum.toString()))
        .intoInkWell(onTap: onTapDotSmoothNum),
      SettingTile(title: 'Threshold for smooth curve'.i18n, subTitle: Text(Global.curvaFilterThreshold.toStringAsFixed(3) + " V"))
        .intoInkWell(onTap: onTapSmoothThreshold),
      SettingTile(title: 'Curve line start color'.i18n, subTitle: displayCurvaStartColor())
        .intoInkWell(onTap: onTapCurvaStartColor),
      SettingTile(title: 'Curve line end color'.i18n, subTitle: displayCurvaEndColor())
        .intoInkWell(onTap: onTapCurvaEndColor),

      //版本号
      buildSettingGroupTile('Version'.i18n),
      SettingTile(title: 'Current version'.i18n, subTitle: (Global.version != "") ? ("V" + Global.version) : ""),
      SettingTile(title: 'Check frequency'.i18n, subTitle: displayCheckFrequency())
        .intoInkWell(onTap: onTapCheckFrequency),
      SettingTile(title: 'Check for update now'.i18n, subTitle: "https//github.com/cdhigh/m328v6host")
        .intoInkWell(onTap: checkUpdateNow, onLongPress: () {
          pasteText("https//github.com/cdhigh/m328v6host");
          showToast("The link of the official site has been copied to the clipboard".i18n);
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
        return 'Chinese'.i18n;
      default:
        return 'Auto'.i18n;
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
        return SimpleDialog(title: Text('Language'.i18n),
          children: <Widget>[
            const Divider(),
            dialogOptionOnLanguage('Auto'.i18n, ''),
            const Divider(),
            dialogOptionOnLanguage('English', 'en'),
            const Divider(),
            dialogOptionOnLanguage('Chinese'.i18n, 'zh_CN'),
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
      //  return 'Dark'.i18n;
      case 'green':
        return 'Green'.i18n;
      case 'blueGrey':
        return 'Blue Grey'.i18n;
      case 'brown':
        return 'Brown'.i18n;
      case 'cyan':
        return 'Cyan'.i18n;
      case 'lightBlue':
        return 'Light Blue'.i18n;
      case 'orange':
        return 'Orange'.i18n;
      case 'pink':
        return 'Pink'.i18n;
      case 'red':
        return 'Red'.i18n;
      case 'teal':
        return 'Teal'.i18n;
      case 'lime':
        return 'Lime'.i18n;
      case 'blue':
        return 'Blue'.i18n;
      default:
        return 'Auto'.i18n;
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
        return SimpleDialog(title: Text('Theme'.i18n),
          children: <Widget>[
            const Divider(),
            dialogOptionOnColor('Auto'.i18n, '', Colors.lime),
            dialogOptionOnColor('Blue'.i18n, 'blue', Colors.blue),
            //dialogOptionOnColor('Dark'.i18n, 'dark', Colors.black),
            dialogOptionOnColor('Green'.i18n, 'green', Colors.green),
            dialogOptionOnColor('Blue Grey'.i18n, 'blueGrey', Colors.blueGrey),
            dialogOptionOnColor('Brown'.i18n, 'brown', Colors.brown),
            dialogOptionOnColor('Cyan'.i18n, 'cyan', Colors.cyan),
            dialogOptionOnColor('Light Blue'.i18n, 'lightBlue', Colors.lightBlue),
            dialogOptionOnColor('Orange'.i18n, 'orange', Colors.orange),
            dialogOptionOnColor('Pink'.i18n, 'pink', Colors.pink),
            dialogOptionOnColor('Red'.i18n, 'red', Colors.red),
            dialogOptionOnColor('Teal'.i18n, 'teal', Colors.teal),
            dialogOptionOnColor('Lime'.i18n, 'lime', Colors.lime),
          ]);
        }
      );

    if (ret != null) {
      ref.watch(Global.infoProvider).setTheme(ret);
    }
  }

  ///构建主页背景颜色显示块
  Widget displayHomeBkColor() {
    return ColoredIndicator(
      color: Global.homePageBackgroundColor,
      size: (Global.currentTheme?.textTheme.bodyText2?.fontSize ?? 14.0) * 0.9,
      text: "0x${Global.homePageBackgroundColor.value.toRadixString(16).padLeft(8, '0')}",
      fontBold: false,
      //textColor: Colors.white38,
    );
  }

  ///构建放电曲线开始颜色
  Widget displayCurvaStartColor() {
    return ColoredIndicator(
      color: Global.curvaStartColor,
      size: (Global.currentTheme?.textTheme.bodyText2?.fontSize ?? 14.0) * 0.9,
      text: "0x${Global.curvaStartColor.value.toRadixString(16).padLeft(8, '0')}",
      fontBold: false,
      //textColor: Colors.white38,
    );
  }

  ///构建放电曲线结束颜色
  Widget displayCurvaEndColor() {
    return ColoredIndicator(
      color: Global.curvaEndColor,
      size: (Global.currentTheme?.textTheme.bodyText2?.fontSize ?? 14.0) * 0.9,
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
        return 'Does not keep the screen always on'.i18n;
      case KeepScreenOption.onWhenDischarge:
        return 'Keep screen on during discharge'.i18n;
      default:
        return 'Keep screen on while the app is running'.i18n;
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
        return SimpleDialog(title: Text('Keep screen on'.i18n),
          children: <Widget>[
            const Divider(),
            dialogOptionOnScrOn('Does not keep on'.i18n, KeepScreenOption.never),
            const Divider(),
            dialogOptionOnScrOn('During discharging'.i18n, KeepScreenOption.onWhenDischarge),
            const Divider(),
            dialogOptionOnScrOn('During app running'.i18n, KeepScreenOption.always),
          ]);
        }
      );

    if (ret != null) {
      setState(() => Global.keepScreenOn = ret);
      Global.saveProfile();
      if (Global.keepScreenOn == KeepScreenOption.never) {
        Wakelock.disable();
      } else if (Global.keepScreenOn == KeepScreenOption.always) {
        Wakelock.enable();
      }
    }
  }

  ///点击了‘自动重连’功能
  void onTapAutoReconnect() {
    setState(() => Global.autoReconnect = !Global.autoReconnect);
    Global.saveProfile();
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
        return SimpleDialog(title: Text('Number of points'.i18n),
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
      title: "Enter a value from 0.000 to 1.000 (V)".i18n,
      initialText: Global.curvaFilterThreshold.toStringAsFixed(3),
      //formatters: [DecimalTextInputFormatter(), CustomMaxValueInputFormatter(1.0)],
    );

    if (ret != null) {
      final value = double.tryParse(ret);
      if ((value == null) || (value < 0.0) || (value > 1.0)) {
        showToast("The value must be greater than 0.000 and less than 1.000".i18n);
      } else {
        setState(() {Global.curvaFilterThreshold = value;});
      }
    }
  }

  ///显示检查新版本频率
  String displayCheckFrequency() {
    switch (Global.checkUpdateFrequency) {
      case 0:
        return "Never".i18n;
      case 7:
        return "One week".i18n;
      case 30:
        return "One month".i18n;
      case 360:
        return "One year".i18n;
      default:
        return "%s days".i18n.fill([Global.checkUpdateFrequency]);
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
        return SimpleDialog(title: Text('Check frequency'.i18n),
          children: <Widget>[
            const Divider(),
            dialogOptionOnDayNum("Never".i18n, 0),
            const Divider(),
            dialogOptionOnDayNum("One week".i18n, 7),
            const Divider(),
            dialogOptionOnDayNum("One month".i18n, 30),
            const Divider(),
            dialogOptionOnDayNum("One year".i18n, 360),
          ]);
        }
      );

    if (ret != null) {
      setState(() {Global.checkUpdateFrequency = ret;});
      Global.saveProfile();
    }
  }

  ///点击了现在检查新版本
  void checkUpdateNow() async {
    final newVer = await checkUpdate(silent: false);
    if (newVer == null) {
      return;
    }

    final newVerNo = newVer.version;
    final whatsnew = newVer.whatsNew.replaceAll("<br/>", "\n");
    final ret = await showOkCancelAlertDialog(context: context, title: "Found new version [%s]".i18n.fill([newVerNo]), 
      okText: "Download".i18n,
      content:  Column(mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Whatsnew:".i18n, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(whatsnew),
          const Divider(),
          Padding(padding: const EdgeInsets.only(top: 20), 
            child: Text("[The download link has been copied to the clipboard]".i18n, textScaleFactor: 0.8)),
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
