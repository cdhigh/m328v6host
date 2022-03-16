/// m328v6数控电子负载上位机
/// 使用此模块是因为flutter_libserialport不给力，经常编译不过，bug不少，丢弃
/// 所以使用此文件对外提供一个统一的串口连接和处理接口，屏蔽不同平台的差异
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart' as serial_android;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as sb_android;
//import 'package:serial_port_win32/serial_port_win32.dart' as serial_win;

//编译apk需要注释掉 flutter_libserialport，取消注释 flutter_libserialport_stub
import 'package:flutter_libserialport/flutter_libserialport.dart' as lib_serial;
//import 'flutter_libserialport_stub.dart' as lib_serial;
import 'i18n/common.i18n.dart';
import 'common/globals.dart';
import 'common/event_bus.dart';
import 'common/widget_utils.dart';

///对外统一接口的串口操作类
class UniSerial {
  dynamic _port; //当前打开的串口实例
  String _name = ""; //当前打开的串口名字
  int _baudRate = 19200; //当前打开的串口波特率
  final _desc = <String, String>{}; //每个端口的描述
  final _portType = <String, String>{}; //每个端口的类型,"USB"/"BLUETOOTH"/"WIFI"/"NATIVE"/"UNKNOWN"
  lib_serial.SerialPortReader? _reader; //for desktop
  StreamSubscription<Uint8List>? _streamrSubscript; //监听端口数据的流订阅句柄
  final _bluetooth = sb_android.FlutterBluetoothSerial.instance;

  //Singleton
  UniSerial._internal(); //私有构造函数
  static final UniSerial _singleton = UniSerial._internal(); //保存单例
  factory UniSerial() => _singleton; //工厂构造函数

  get name => _name;
  get baudRate => _baudRate;

  //获取当前可用的串口名字列表
  Future<List<String>> getAvailablePortNames() async {
    final names = <String>[];
    _desc.clear();
    _portType.clear();
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      //首先是USB串口
      final devices = await serial_android.UsbSerial.listDevices();
      for (final d in devices) {
        names.add(d.deviceName);
        _desc[d.deviceName] = d.productName ?? "";
        _portType[d.deviceName] = "USB";
      }

      //然后是蓝牙串口，需要蓝牙开关打开才显示蓝牙设备
      final btState = await _bluetooth.state;
      if ((btState == sb_android.BluetoothState.STATE_ON) || (btState == sb_android.BluetoothState.STATE_BLE_ON)) {
        try {
          final blueList = await _bluetooth.getBondedDevices();
          for (final d in blueList) {
            //将MAC地址添加到名字中，方便后续连接
            final bName = (d.name ?? "") + " [${d.address}]";
            names.add(bName);
            _portType[bName] = "BLUETOOTH";
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    } else {
      /*var availablePorts = <String>[];
      try { //windows下可能会抛出异常
        availablePorts = serial_win.SerialPort.getAvailablePorts();
      } catch (e) {
        debugPrint(e.toString());
      }*/
      
      for (final name in lib_serial.SerialPort.availablePorts) {
        names.add(name);
        final pt = lib_serial.SerialPort(name).transport;
        if (pt == lib_serial.SerialPortTransport.usb) {
          _portType[name] = "USB";
        } else if (pt == lib_serial.SerialPortTransport.bluetooth) {
          _portType[name] = "BLUETOOTH";
        } else if (pt == lib_serial.SerialPortTransport.native) {
          _portType[name] = "NATIVE";
        } else {
          _portType[name] = "UNKNOWN";
        }
      }
    }
    return names;
  }

  ///获取一个串口的描述字符串
  String getDesc(String name) {
    return _desc[name] ?? "";
  }

  ///获取一个串口的类型
  String getPortType(String name) {
    return _portType[name] ?? "UNKNOWN";
  }

  //创建一个串口，成功返回空字符串，否则返回错误描述字符串，如果没有特定错误，则字符串为"Error"
  //此函数内部可能会抛出异常
  Future<String> open(String name, int baudRate) async {
    assert(name.isNotEmpty && (baudRate >= 9600) && (baudRate <= 115200));
    _port = null;
    _name = "";

    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      //区分USB串口还是蓝牙串口
      final pType = _portType[name] ?? "";
      if (pType == "BLUETOOTH") {
        //从名字中取出MAC地址
        final iStart = name.indexOf("[");
        final iEnd = name.indexOf("]");
        if ((iStart < 0) || (iEnd < 0)) {
          return "Name of device invalid".i18n;
        }

        final addr = name.substring(iStart + 1, iEnd);
        try {
          final connection = await sb_android.BluetoothConnection.toAddress(addr);
          _port = connection;
          _name = name;
          _baudRate = baudRate;
          return "";
        } catch (e) {
          return e.toString();
        }
      } else {
        final ports = await serial_android.UsbSerial.listDevices();
        final idx = ports.indexWhere((elem) => elem.deviceName == name);
        if (idx < 0) {
          return "Name of device invalid".i18n;
        }

        serial_android.UsbPort? port;
        bool ret;
        try {
          port = await ports[idx].create();
          ret = (await port?.open()) ?? false;
        } catch (e) {
          return e.toString();
        }

        if ((port == null) || (!ret)) {
          return "Error";
        } else {
          _port = port;
          port.setPortParameters(baudRate, serial_android.UsbPort.DATABITS_8, serial_android.UsbPort.STOPBITS_1, serial_android.UsbPort.PARITY_NONE);
          _name = name;
          _baudRate = baudRate;
          return "";
        }
      }
    } else {
      //final port = serial_win.SerialPort(name, openNow: false, BaudRate: baudRate);
      try {
        _port = lib_serial.SerialPort(name);
        if (!_port.openReadWrite()) {
          final lastError = lib_serial.SerialPort.lastError;
          final errStr = transWindowsErrorNo(lastError?.errorCode ?? 0);
          return errStr.isEmpty ? lastError.toString() : errStr;
        }
      } catch (e) {
        return e.toString();
      }

      //需要先打开端口再配置端口参数
      final cfg = lib_serial.SerialPortConfig();
      cfg.baudRate = baudRate;
      cfg.bits = 8;
      cfg.stopBits = 1;
      cfg.setFlowControl(lib_serial.SerialPortFlowControl.none);
      cfg.parity = 0;
      _port.config = cfg;
      cfg.dispose();
      
      _name = name;
      _baudRate = baudRate;
      return "";
    }
  }

  ///注册接收数据监听函数，此函数可能会抛出异常
  bool registerListenFunction(Function(Uint8List) func) {
    assert(_port != null);
    if (_port == null) {
      return false;
    }

    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      if (_port is sb_android.BluetoothConnection) {
        sb_android.BluetoothConnection p = _port;
        _streamrSubscript = p.input?.listen(func, onError: ([_]) {sendDisconnectBroadcast("-1");});
      } else {
        serial_android.UsbPort p = _port;
        _streamrSubscript = p.inputStream?.listen(func, onError: ([_]) {sendDisconnectBroadcast("-1");});
      }
    } else {
      //Windows需要先注册监听函数，再打开端口
      /*(_port as serial_win.SerialPort).readOnListenFunction = func;
      try {
        if (!_port.isOpened) {
          _port.open();
        }
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }*/

      _reader = lib_serial.SerialPortReader(_port);
      _streamrSubscript = _reader!.stream.listen(func, onDone: ([_]) {sendDisconnectBroadcast("-1");}, onError: ([_]) {sendDisconnectBroadcast("-1");});
    }
    
    return true;
  }

  ///往串口写一个字节串，此函数可能会抛出异常
  void write(Uint8List data) async {
    if (_port == null) {
      return;
    }

    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      if (_port is sb_android.BluetoothConnection) {
        sb_android.BluetoothConnection p = _port;
        try {
          p.output.add(data);
          await p.output.allSent;
        } catch (e) {
          sendDisconnectBroadcast("-1");
        }
      } else {
        serial_android.UsbPort p = _port;
        try {
          await p.write(data);
        } catch (e) {
          sendDisconnectBroadcast("-1");
        }
      }
    } else {
      //assert(_port?.isOpened);
      //_port.writeBytesFromUint8List(data);
      lib_serial.SerialPort p = _port;
      try {
        p.write(data);
        p.drain();
      } catch (e) {
        sendDisconnectBroadcast("-1");
      }
    }
  }

  ///关闭串口
  void close() {
    try {
      _streamrSubscript?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _reader?.close();
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _port?.close();
    } catch (e) {
      debugPrint(e.toString());
    }

    _port = null;
    _reader = null;
    _streamrSubscript = null;
    _desc.clear();
    _name = "";
    _baudRate = 19200;
  }

  ///连接被关闭后发送端口关闭广播
  /// 用参数-1表示异常关闭
  void sendDisconnectBroadcast(String bcFlag) {
    if (bcFlag == "0") {
      showNotification("sendDisconnectBroadcast: $bcFlag");
    } else {
      showToast("sendDisconnectBroadcast: $bcFlag");
    }
    Global.bus.sendBroadcast(EventBus.connectionChanged, arg: bcFlag, sendAsync: false);
  }

  ///将Windows的一些常用系统错误码翻译为字符串，
  ///因为Windows返回的部分错误信息为误码（编码关系），暂时找不到很好的方法解码不让乱码，先这样用着
  String transWindowsErrorNo(int errorNo) {
    switch (errorNo) {
      case 1:
        return 'Incorrect function';
      case 2:
        return 'The system cannot find the file specified';
      case 3:
        return 'The system cannot find the path specified';
      case 4:
        return 'The system cannot open the file';
      case 5:
        return 'Access is denied';
      case 6:
        return 'The handle is invalid';
      case 7:
        return 'The storage control blocks were destroyed';
      case 8:
        return 'Not enough memory resources are available to process this command';
      case 21:
        return 'The device is not ready';
      case 22:
        return 'The device does not recognize the command';
      case 29:
        return 'The system cannot write to the specified device';
      case 30:
        return 'The system cannot read from the specified device';
      case 31:
        return 'A device attached to the system is not functioning';
      case 32:
        return 'The process cannot access the file because it is being used by another process';
      default:
        return '';
    }
  }

}
