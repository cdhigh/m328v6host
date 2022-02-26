/// m328v6数控电子负载上位机
/// 封装应用基本信息数据结构为Provider使用，目前包含theme/language/一些颜色设置
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import '../common/globals.dart';

//用于Provider的容器类
class AppInfoProvider extends ChangeNotifier {
  //String _version = "";
  //String _buildNumber = "";

  //String get version => _version;
  //String get buildNumber => _buildNumber;
  String get theme => Global.selectedTheme;
  String get language => Global.selectedLanguage;
  Color get homePageBackgroundColor => Global.homePageBackgroundColor;
  Color get curvaStartColor => Global.curvaStartColor;
  Color get curvaEndColor => Global.curvaEndColor;

  ///设置APP版本号
  //void setVersion(String ver, String bNumber) {
  //  _version = ver;
  //  _buildNumber = bNumber;
  //  notifyListeners();
  //}

  ///设置主题名字
  void setTheme(String themeStr) {
    Global.selectedTheme = themeStr;
    Global.saveProfile();
    notifyListeners();
  }

  ///设置语言
  void setLanguage(String language) {
    Global.selectedLanguage = language;
    Global.saveProfile();
    notifyListeners();
  }

  ///设置主页背景颜色
  void setHomePageBackgroundColor(Color newColor) {
    Global.homePageBackgroundColor = newColor;
    Global.saveProfile();
    notifyListeners();
  }

  ///设置放电曲线颜色
  void setCurvaColor({Color? startColor, Color? endColor}) {
    if (startColor != null) {
      Global.curvaStartColor = startColor;
    }
    
    if (endColor != null) {
      Global.curvaEndColor = endColor;
    }

    Global.saveProfile();
    notifyListeners();
  }
}

