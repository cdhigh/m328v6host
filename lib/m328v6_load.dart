/// m328v6数控电子负载上位机
/// 上位机下放给下位机的命令处理，M328v6Load为对真实下位机的抽象
/// Author: cdhigh <https://github.com/cdhigh>
/// 
//import 'dart:io' show Platform;
import 'dart:typed_data';
import 'uni_serial.dart';
import 'common/widget_utils.dart';
import 'common/event_bus.dart';
import 'common/globals.dart';

///扩展整形功能
extension AsListLow16Bits on int {
  ///将整形的低16位分解为5个ASCII码，最大65535
  List<int> asUint8ListL16() {
    final retList = List<int>.filled(5, 0);
    int value = this;
    int idx = 0;
    if (value > 0xffff) {
      value = 0xffff;
    }
    for (int i = 10000; i >= 1; i = i ~/ 10) {
        retList[idx] = (value ~/ i) + 0x30;
        idx++;
        value %= i;
    }
    return retList;
  }

  ///将整形分解为5个ASCII码，最大99999
  List<int> asUint8List5() {
    final retList = List<int>.filled(5, 0);
    int value = this;
    int idx = 0;
    if (value > 99999) {
      value = 99999;
    }
    for (int i = 10000; i >= 1; i = i ~/ 10) {
        retList[idx] = (value ~/ i) + 0x30;
        idx++;
        value %= i;
    }
    return retList;
  }
}

///表示一个下位机
class M328v6Load {
  final _uniSerial = UniSerial();
  
  //Singleton
  M328v6Load._internal(); //私有构造函数
  static final M328v6Load _singleton = M328v6Load._internal(); //保存单例
  factory M328v6Load() => _singleton; //工厂构造函数

  ///实际发送命令
  void sendCmd(Uint8List cmd) {
    try {
      _uniSerial.write(cmd);
    } catch (e) {
      showToast(e.toString());
    }
  }

  ///设置截止电压：^V12000$
  ///参数为电压，单位为伏
  void setV(double volt) {
    final cmd = BytesBuilder();
    cmd.add("^V".codeUnits);
    cmd.add((volt * 1000).toInt().asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///设置放电电流：^I01200$
  ///参数为电流，单位为安
  void setI(double i) {
    final cmd = BytesBuilder();
    cmd.add("^I".codeUnits);
    cmd.add((i * 1000).toInt().asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///交流内阻开关：^R1$
  void setRaOn(bool isOn) {
    int onoff = isOn ? 0x31 : 0x30;
    final cmd = Uint8List.fromList(["^".codeUnitAt(0), "R".codeUnitAt(0), onoff, r"$".codeUnitAt(0)]);
    sendCmd(cmd);
  }

  ///打开关闭负载：^L1$
  void setLoadOn(bool isOn) {
    Global.bus.sendBroadcast(EventBus.setLoadOnOff, arg: isOn ? "1" : "0", sendAsync: false);
    
    int onoff = isOn ? 0x31 : 0x30;
    final cmd = Uint8List.fromList(["^".codeUnitAt(0), "L".codeUnitAt(0), onoff, r"$".codeUnitAt(0)]);
    sendCmd(cmd);
    //print('setLoadOn:$isOn');
  }

  ///设置电流PWM微调使能开关：^F1$
  void setFinePwmOn(bool isOn) {
    int onoff = isOn ? 0x31 : 0x30;
    final cmd = Uint8List.fromList(["^".codeUnitAt(0), "F".codeUnitAt(0), onoff, r"$".codeUnitAt(0)]);
    sendCmd(cmd);
  }

  ///清零容量Ah：^ZA$
  void clearAh() {
    final cmd = Uint8List.fromList(r"^ZA$".codeUnits);
    sendCmd(cmd);
  }

  ///Ra调零：^ZR$
  void zeroRa() {
    final cmd = Uint8List.fromList(r"^ZR$".codeUnits);
    sendCmd(cmd);
  }

  ///电流调零：^ZI$
  void zeroI() {
    final cmd = Uint8List.fromList(r"^ZI$".codeUnits);
    sendCmd(cmd);
  }

  ///运行时间清零：^T00000$
  void clearTime() {
    final cmd = Uint8List.fromList(r"^T00000$".codeUnits);
    sendCmd(cmd);
  }

  ///将上位机的时间同步到下位机: ^T12345$
  void synchronizeTime() {
    final now = DateTime.now();
    final int nowSeconds = now.hour * 3600 + now.minute * 60 + now.second;
    final cmd = BytesBuilder();
    cmd.add("^T".codeUnits);
    cmd.add(nowSeconds.asUint8List5());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///切换为恒流模式：^MC00000$
  void switchToCC() {
    final cmd = Uint8List.fromList(r"^MC00000$".codeUnits);
    sendCmd(cmd);
  }

  ///切换为恒阻模式：^MR00000$
  ///参数为阻值，单位为欧
  void switchToCR(double resistor) {
    final cmd = BytesBuilder();
    cmd.add("^MR".codeUnits);
    cmd.add((resistor * 100).toInt().asUint8ListL16()); //单位切换为下位机使用的10毫欧
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///切换为恒流模式：^MP00000$
  ///参数为功率，单位为瓦
  void switchToCP(double power) {
    final cmd = BytesBuilder();
    cmd.add("^MP".codeUnits);
    cmd.add((power * 100).toInt().asUint8ListL16()); //单位切换为下位机使用的10毫瓦
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///设置延时开负载：^DSO03600$
  ///参数为时间，单位为秒
  void setDelayOn(int seconds) {
    final cmd = BytesBuilder();
    cmd.add("^DSO".codeUnits);
    cmd.add(seconds.asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///查询延时开负载剩余时间：^DQO00000$
  void queryDelayOn() {
    final cmd = Uint8List.fromList(r"^DQO00000$".codeUnits);
    sendCmd(cmd);
  }

  ///设置延时关负载：^DSF03600$
  ///参数为时间，单位为秒
  void setDelayOff(int seconds) {
    final cmd = BytesBuilder();
    cmd.add("^DSF".codeUnits);
    cmd.add(seconds.asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///查询延时关负载剩余时间：^DQF00000$
  void queryDelayOff() {
    final cmd = Uint8List.fromList(r"^DQF00000$".codeUnits);
    sendCmd(cmd);
  }

  ///设置周期开关负载：^DSP03600$, ^DSQ03600$
  ///参数为时间，单位为秒
  void setPeriodOnOff(int onSeconds, int offSeconds) {
    final cmd = BytesBuilder();
    cmd.add("^DSP".codeUnits);
    cmd.add(onSeconds.asUint8ListL16());
    cmd.add(r"$^DSQ".codeUnits);
    cmd.add(offSeconds.asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }

  ///查询周期关负载时间：^DQP00000$
  void queryPeriodOn() {
    final cmd = Uint8List.fromList(r"^DQP00000$".codeUnits);
    sendCmd(cmd);
  }

  ///查询周期关负载时间：^DQQ00000$
  void queryPeriodOff() {
    final cmd = Uint8List.fromList(r"^DQQ00000$".codeUnits);
    sendCmd(cmd);
  }

  ///控制蜂鸣器，参数为零则关闭蜂鸣器：^B00000$
  ///时间单位为10ms
  void setBuzzerTime(int onTime) {
    final cmd = BytesBuilder();
    cmd.add("^B".codeUnits);
    cmd.add(onTime.asUint8ListL16());
    cmd.addByte(r"$".codeUnitAt(0));
    sendCmd(cmd.toBytes());
  }
  
  ///查询版本：^bv$
  ///接下来需要在读取函数中获取下位机返回的版本号
  void queryVersion() {
    final cmd = Uint8List.fromList(r"^bv$".codeUnits);
    sendCmd(cmd);
  }

  ///请求发送额外数据：^U11$
  void requestExtraData() {
    final cmd = Uint8List.fromList(r"^U11$".codeUnits);
    sendCmd(cmd);
  }

  ///设置数据上报类型开关：^U11$
  ///baseData:0-关闭基本数据上传，1-M8V6兼容格式上传，2-实时电压电流LOG上传
  ///extraData:false-关闭额外数据上传，true-打开额外数据上传
  void setDataReportType({required int baseData, required bool extraData}) {
    assert((baseData >= 0) && (baseData <= 2));
    final baseOnoff = (baseData == 1) ? 0x31 : ((baseData == 0) ? 0x30 : 0x32);
    final extraOnoff = extraData ? 0x31 : 0x30;
    final cmd = Uint8List.fromList(["^".codeUnitAt(0), "U".codeUnitAt(0), baseOnoff, extraOnoff, r"$".codeUnitAt(0)]);
    sendCmd(cmd);
  }

  ///强制完全导通MOS，进行短路测试，将电子负载做为电流表使用时也是强制完全开通MOS
  /// 注意之后需要调用 restoreMos() 恢复正常工作状态
  void fullOpenMos() {
    final cmd = Uint8List.fromList(r"^S11111$".codeUnits);
    sendCmd(cmd);
  }

  ///强制MOS关断，进行开路测试
  /// 注意之后需要调用 restoreMos() 恢复正常工作状态
  void fullCloseMos() {
    final cmd = Uint8List.fromList(r"^S22222$".codeUnits);
    sendCmd(cmd);
  }

  ///MOS工作状态恢复正常，由设定的放电电流进行控制
  void restoreMos() {
    final cmd = Uint8List.fromList(r"^S00000$".codeUnits);
    sendCmd(cmd);
  }
}
