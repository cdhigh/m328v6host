/// m328v6数控电子负载上位机
/// 保存需要的全局变量
/// Global为单例模式，也可以使用静态变量方法
/// 使用方法：
/// void main() => Global().init().then((e) => runApp(MyApp()));
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_provider.dart';
import '../models/volt_history_provider.dart';
import '../models/app_info_provider.dart';
import '../models/running_data_provider.dart';
import 'event_bus.dart';

///屏幕常量枚举
enum KeepScreenOption {
  never,
  onWhenDischarge,
  always,
}

//使用package_info_plus时不时就获取不到版本号，所以将版本号固定写作代码内
//编译时有buildApk.py/buildExe.py将pubspec.yaml里的版本号同步更新到此文件

///程序全局唯一的信息池，大部分都会保存到SharedPreferences
///小部分为程序共用的变量
class Global {
  //版本号注意需要使用单引号，让buildXXX.py能找的到
  static const version = '1.0.0';
  static const buildNumber = "";

  static bool firstTimeRuning = true; //是否是本应用第一次运行
  static int checkUpdateFrequency = 7; //检查新版本频率（天数）
  static DateTime lastCheckUpdateTime = DateTime(1970); //上次检查新版本的时标
  static int defaultBaudRate = 19200; //默认波特率
  static late final SharedPreferences prefs;
  static String selectedLanguage = ''; //当前选择的语种，空则为自动
  static String selectedTheme = '';    //当前选择的主题，空则为自动
  static Color homePageBackgroundColor = const Color(0xff0e0e0e); //主导航页面的背景颜色
  static Color curvaStartColor = const Color(0xff23b6e6); //放电曲线的开始颜色[渐变色]
  static Color curvaEndColor = const Color(0xff02d39a); //放电曲线的开始颜色[渐变色]
  static KeepScreenOption keepScreenOn = KeepScreenOption.always;
  static DateTime lastPaused = DateTime.now(); //上次切换到后台的时间
  static DateTime lastHeartBeat = DateTime.now(); //上次接收到下位机的时间
  static bool offlineMode = false; //是否处于离线模式
  static String lastSerialPort = "";
  static int lastBaudRate = 19200;
  static int curvaFilterDotNum = 3; //放电曲线的平滑点数

  //各种tile的背景色和分割色
  static Color get tileBkColor => Colors.white;
  static Color get tileDividerColor => Colors.grey;

  ///初始化全局信息，会在APP启动时执行，注意里面的代码绝对不允许出现异常
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
    
    try {
      firstTimeRuning = prefs.getBool('firstTimeRuning') ?? true;
      checkUpdateFrequency = prefs.getInt('checkUpdateFrequency') ?? 7;
      lastCheckUpdateTime = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lastCheckUpdateTime') ?? 0);
      selectedLanguage = prefs.getString('selectedLanguage') ?? '';
      selectedTheme = prefs.getString('selectedTheme') ?? '';
      homePageBackgroundColor = Color(prefs.getInt('homePageBackgroundColor') ?? 0xff0e0e0e);
      curvaStartColor = Color(prefs.getInt('curvaStartColor') ?? 0xff23b6e6);
      curvaEndColor = Color(prefs.getInt('curvaEndColor') ?? 0xff02d39a);
      final onValue = min<int>((prefs.getInt('keepScreenOn') ?? KeepScreenOption.always.index), KeepScreenOption.always.index);
      keepScreenOn = KeepScreenOption.values[onValue];
      lastSerialPort = prefs.getString('lastSerialPort') ?? "";
      lastBaudRate = prefs.getInt('lastBaudRate') ?? 19200;
      curvaFilterDotNum = prefs.getInt('curvaFilterDotNum') ?? 3;
      if (curvaFilterDotNum == 0) {
        curvaFilterDotNum = 1;
      } else if (curvaFilterDotNum > 10) {
        curvaFilterDotNum = 10;
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  /// 持久化Profile信息
  static void saveProfile() {
    prefs.setBool('firstTimeRuning', firstTimeRuning);
    prefs.setInt('checkUpdateFrequency', checkUpdateFrequency);
    prefs.setInt('lastCheckUpdateTime', lastCheckUpdateTime.millisecondsSinceEpoch);
    prefs.setString("selectedLanguage", selectedLanguage);
    prefs.setString("selectedTheme", selectedTheme);
    prefs.setInt('homePageBackgroundColor', homePageBackgroundColor.value);
    prefs.setInt('curvaStartColor', curvaStartColor.value);
    prefs.setInt('curvaEndColor', curvaEndColor.value);
    prefs.setInt("keepScreenOn", keepScreenOn.index);
    prefs.setString("lastSerialPort", lastSerialPort);
    prefs.setInt('lastBaudRate', lastBaudRate);
    prefs.setInt('curvaFilterDotNum', curvaFilterDotNum);
  }

  ///这个全局key要注册到MaterialApp的navigatorKey属性
  ///返回即可在任何地方使用 navigatorState/currentContext/currentTheme
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ///在代码中任何地方获取当前的state/context/theme
  ///使用这些函数的前提是将 Global.navigatorKey 注册到MaterialApp的navigatorKey属性
  static NavigatorState? get navigatorState => Global.navigatorKey.currentState;
  static BuildContext? get currentContext => navigatorState?.context;
  static ThemeData? get currentTheme => Theme.of(navigatorState!.context);
  static bool get isDarkMode => currentTheme!.brightness == Brightness.dark;
  
  //全局provider实例
  static ChangeNotifierProvider<AppInfoProvider> infoProvider = ChangeNotifierProvider((_) => AppInfoProvider());
  static ChangeNotifierProvider<ConnectionProvider> connectionProvider = ChangeNotifierProvider((_) => ConnectionProvider());
  static ChangeNotifierProvider<VoltHistoryProvider> vHistoryProvider = ChangeNotifierProvider((_) => VoltHistoryProvider());
  static ChangeNotifierProvider<RunningDataProvider> runningDataProvider = ChangeNotifierProvider((_) => RunningDataProvider());

  //事件总线
  static final bus = EventBus();

  Global._internal(); //私有构造函数
  static final Global _singleton = Global._internal(); //保存单例
  factory Global() => _singleton; ////工厂构造函数
}
