/// m328v6数控电子负载上位机
/// 封装电子负载运行数据为Provider使用
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';

//用于Provider的容器类，这里面的单位全部调整为正常的单位：伏，安，安时，瓦时，欧姆等
class RunningDataProvider extends ChangeNotifier {
  String ver = "";
  String buildDate = "";
  bool running = false; //是否处于放电状态
  double vSet = 0.0;
  double iSet = 0.0;
  double vNow = 0.0;
  double iNow = 0.0;
  double powerIn = 0.0;
  double ah = 0.0;
  double wh = 0.0;
  double ra = 0.0;
  double rd = 0.0;
  int temperature1 = 0;
  int temperature2 = 0;
  String mode = "CC";
  double rSet = 0.0;
  double pSet = 0.0;
  int delayOn = 0; //以秒为单位
  int delayOff = 0;
  int periodOn = 0;
  int periodOff = 0;

  ///所有数据恢复默认值
  void reset() {
    ver = "";
    buildDate = "";
    running = false;
    vSet = 0.0;
    iSet = 0.0;
    vNow = 0.0;
    iNow = 0.0;
    powerIn = 0.0;
    ah = 0.0;
    wh = 0.0;
    ra = 0.0;
    rd = 0.0;
    temperature1 = 0;
    temperature2 = 0;
    mode = "CC";
    rSet = 0.0;
    pSet = 0.0;
    delayOn = 0;
    delayOff = 0;
    periodOn = 0;
    periodOff = 0;
    notifyListeners();
  }

  ///通知依赖这些数据的控件更新
  void notifyDataChanged() {
    notifyListeners();
  }
}

