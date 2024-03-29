/// m328v6数控电子负载上位机
/// 定义所有的路由
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'main_page.dart';
import 'settings/settings.dart';
import 'connection.dart';
import 'delay_period_on_off.dart';
import 'switch_mode.dart';
import 'help_page.dart';
import 'export_data.dart';
import 'load_stats_page.dart';
import 'load_testers/max_i_tester.dart';
import 'load_testers/short_circuit_tester.dart';

//为什么用函数 onGenerateRoute, 而不用 变量 routes
//是因为 MaterialApp通过onGenerateRoute才方便传递参数给其他路由，尽管现在还没使用此特性
//传递参数例子：
//注册：'/xxx': (context) => I18n(child: const xxxPage(myParam: settings.arguments),),
//调用：var ret = await Navigator.of(context).pushNamed('/xxx', arguments: aaa);
//实现：class xxxPage extends StatefulWidget {xxxPage({Key? key, required this.myParam});}
MaterialPageRoute routesPath(RouteSettings settings) {
  var routes = <String, WidgetBuilder>{
    '/': (context) => I18n(child: const MainPage()),
    '/settings': (context) => I18n(child: const SettingsPage()),
    '/connection': (context) => I18n(child: const ConnectionPage()),
    '/delay_period_on_off': (context) => I18n(child: const DelayPeriodOnOffPage(),),
    '/mode': (context) => I18n(child: const SwitchModePage(),),
    '/help': (context) => I18n(child: const HelpPage(),),
    '/export': (context) => I18n(child: const ExportPage(),),
    '/load_stats': (context) => I18n(child: LoadStatsPage(loadStats: settings.arguments as Map<String, List<LoadStatsModel>>,),),
    '/export_stats': (context) => I18n(child: ExportLoadStatsPage(loadStats: settings.arguments as Map<String, List<LoadStatsModel>>,),),
    '/max_i_tester': (context) => I18n(child: const MaxITesterPage(),),
    '/sc_tester': (context) => I18n(child: const ScTesterPage(),),
  };
  WidgetBuilder builder = routes[settings.name] ?? routes['/']!;
  return MaterialPageRoute(builder: (ctx) => builder(ctx));
}

