/// m328v6数控电子负载上位机
/// 封装串口连接基本信息数据结构为Provider使用，目前包含name/baudRate
/// Author: cdhigh <https://github.com/cdhigh>
/// 
//import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../m328v6_load.dart';
import '../uni_serial.dart';

//用于Provider的容器类，界面需要一个状态管理，所以使用此Provider再封装一层
class ConnectionProvider extends ChangeNotifier {
  final _load = M328v6Load();
  final _uniSerial = UniSerial();
  
  //dynamic get port => _port;
  String get name => _uniSerial.name;
  int get baudRate => _uniSerial.baudRate;
  //bool get isOpen => _port?.isOpen ?? false;
  M328v6Load get load => _load;
  UniSerial get serial => _uniSerial;

  void setPort(String name, int baudRate) {
    Global.lastSerialPort = name;
    Global.lastBaudRate = baudRate;
    Global.saveProfile();
    notifyListeners();
  }

  void closePort() {
    _uniSerial.close();
    //_port?.flush();
    //_port?.close();
    //_port?.dispose(); //加了这句app会崩溃
    //_port = null;
    //_name = "";
    //_load.port = null;
    notifyListeners();
  }
}

