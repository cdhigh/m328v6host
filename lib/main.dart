/// m328v6数控电子负载上位机
/// 应用程序入口
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bot_toast/bot_toast.dart';
import 'common/globals.dart';
import 'models/app_info_provider.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(
    ProviderScope(
      child: I18n(child: const M328v6App(), initialLocale: selectedLanguage())
    ),
  ));
}

class M328v6App extends ConsumerWidget {
  const M328v6App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(Global.infoProvider);
    return MaterialApp(
      title: 'm328v6',
      theme: selectedTheme(appInfo),
      darkTheme: appInfo.theme.isEmpty ? ThemeData.dark() : null,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      navigatorKey: Global.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: routesPath,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('zh', 'CN'),
      ],
      locale: selectedLanguage(appInfo),
      debugShowCheckedModeBanner: false,
    );
  }
}

///返回用户指定的语种设置，返回null为跟随系统
Locale? selectedLanguage([AppInfoProvider? appInfo]) {
  final lang = appInfo != null ? appInfo.language : Global.selectedLanguage;
  switch (lang) {
    case "":
      return null;
    case 'zh_CN':
      return const Locale('zh', 'CN');
    default:
      return const  Locale('en', 'US');
  }
}

///返回用户指定的主题设置
ThemeData selectedTheme(AppInfoProvider appInfo) {
  switch (appInfo.theme) {
    //case 'dark':
    //  return ThemeData.dark();
    case 'green':
      return ThemeData(primarySwatch: Colors.green, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'blueGrey':
      return ThemeData(primarySwatch: Colors.blueGrey, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'brown':
      return ThemeData(primarySwatch: Colors.brown, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'cyan':
      return ThemeData(primarySwatch: Colors.cyan, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'lightBlue':
      return ThemeData(primarySwatch: Colors.lightBlue, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'orange':
      return ThemeData(primarySwatch: Colors.orange, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'pink':
      return ThemeData(primarySwatch: Colors.pink, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'red':
      return ThemeData(primarySwatch: Colors.red, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    case 'teal':
      return ThemeData(primarySwatch: Colors.teal, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    //case 'light':
    case 'blue':
      return ThemeData(primarySwatch: Colors.blue, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
    default: //'lime':
      return ThemeData(primarySwatch: Colors.lime, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'CourierPrime');
  }
}
