/// m328v6数控电子负载上位机
/// 单次放电的统计数据
/// Author: cdhigh <https://github.com/cdhigh>
/// 

class LoadStatsModel {
  final double initialV;     //初始电压
  double endV = 0.0;         //放电截止电压
  double avgV = 0.0;         //平均电压
  double? initialI;     //初始电流
  double endI = 0.0;         //放电截止时电流
  double avgI = 0.0;         //平均电流
  final double  initialAh;   //初始安时
  double ah = 0.0;           //本次放电的安时
  double totalAh = 0.0;      //总安时：初始安时+本次安时
  double? initialWh;         //初始瓦时
  double wh = 0.0;           //本次放电的瓦时
  double totalWh = 0.0;      //总瓦时：初始瓦时+本次瓦时
  String mode = "";          //放电模式
  double rSet = 0.0;         //CR模式的参数
  double pSet = 0.0;         //CP模式的参数
  double ra = 0.0;           //本次放电的交流内阻
  double rd = 0.0;           //本次放电的直流内阻
  int temperature1 = 0;      //本次放电结束时的散热器温度
  int temperature2 = 0;      //本次放电结束时的主板温度
  final DateTime startTime; //放电开始时间
  DateTime? endTime;  //放电结束时间
  Duration loadTime = const Duration(); //放电持续时间
  String remark = "";   //备注

  LoadStatsModel({required this.initialV, required this.initialAh})
   : startTime = DateTime.now();
}
