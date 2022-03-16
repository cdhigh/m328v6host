library flutter_libserialport;
///因为有了lib_serial，编译APK偶尔能编译通过，大部分时间都失败，每次纯属运气，所以在这里做一个桩
/// 当然，有了这个桩也不是每次都编译通过，只是通过概率高一些而已
/// Author: cdhigh <https://github.com/cdhigh>
/// 如果要编译APK：
/// 1. 在 pubspec.yaml 里面注释掉 flutter_libserialport
/// 2. uni_serial.dart 里面修改导入flutter_libserialport为导入此文件
/// 3. flutter pub get
/// 4. flutter clean
/// 5. flutter build apk
//export 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

class SerialPort {
  static final availablePorts = <String>[];
  int get transport => 0;
  static OSError? get lastError => const OSError("", 0);
  SerialPort(String name);
  void write(Uint8List data) {}
  void drain() {}
}

class SerialPortTransport {
  static const usb = 0;
  static const bluetooth = 1;
  static const native = 2;
}

class SerialPortConfig {
  int baudRate = 19200;
  int bits = 8;
  int stopBits = 1;
  int parity = 0;
  void setFlowControl(int i) {}
  void dispose() {}
}

class SerialPortFlowControl  {
  static const none = 0;
}

class SerialPortReader {
  SerialPortReader(dynamic port);
  void close() {}

  Stream<Uint8List> get stream => Stream<Uint8List>.periodic(const Duration(days : 1));
}
