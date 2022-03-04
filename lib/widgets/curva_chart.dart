/// m328v6数控电子负载上位机
/// 放电曲线控件
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:collection/collection.dart'; //for mapIndexed
import '../common/globals.dart';
import '../common/common_utils.dart';
import '../models/volt_history_provider.dart';
import '../models/app_info_provider.dart';

///填充数据，用于绘制曲线图
LineChartData _fillCurvaData(VoltHistoryProvider vhProvider, AppInfoProvider appInfo) {
  return LineChartData(
    gridData: FlGridData( //格子数据
      show: true,
      drawVerticalLine: true,
      horizontalInterval: null, //为null时是自动计算格子间隔
      verticalInterval: null, //为null时是自动计算格子间隔
      getDrawingHorizontalLine: (value) { //水平线
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {  //垂直线
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(  //X轴下面的标题
        showTitles: true,
        reservedSize: 20,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 14),
        getTitles: (value) { //数值单位为秒
          if (vhProvider.needDrawXTitle(value.toInt())) {
            return readableSeconds(value.toInt());
          }
          return '';
        },
        margin: 10,
      ),
      leftTitles: SideTitles(  //Y轴左边的标题
        showTitles: true,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) { //单位为毫伏
          if (vhProvider.needDrawYTitle(value)) {
            return value.toStringAsFixed(2);
          }
          return '';
        },
        reservedSize: 30,
        margin: 5,
      ),
    ),
    borderData: FlBorderData( //边框属性
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)
    ),
    minX: 0,  //X轴最小值
    maxX: ((vhProvider.dotNum / 10).ceil() * 10.0), //X轴最大值，整数向上取整为10的倍数
    minY: vhProvider.minV,  //Y轴最小值
    maxY: vhProvider.maxV,  //Y轴最大值
    lineBarsData: [ //曲线实际数据，如果需要多个曲线，添加多个 LineChartBarData()
      LineChartBarData(
        spots: vhProvider.mapIndexed<FlSpot>((idx, elem) => FlSpot(idx.toDouble(), elem)).toList(),
        isCurved: false,
        colors: <Color>[appInfo.curvaStartColor, appInfo.curvaEndColor],
        barWidth: 2, //曲线宽度
        isStrokeCapRound: true,
        dotData: FlDotData( //是否在曲线上显示数据对应的点
          show: false,
        ),
      ),
    ],
  );
}

///竖屏曲线图
class CurvaChart extends ConsumerWidget {
  const CurvaChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vhProvider = ref.watch<VoltHistoryProvider>(Global.vHistoryProvider);
    final appInfo = ref.watch<AppInfoProvider>(Global.infoProvider);
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: Color(0xff232d37)),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: IndexedStack(alignment: AlignmentDirectional.center,
              index: vhProvider.dotNum == 0 ? 0 : 1,
              children: [
                //没有数据时显示m328v6文本，有数据时显示曲线
                Text('m328v6', textAlign: TextAlign.center,
                  style: TextStyle(color: appInfo.curvaStartColor, fontSize: 32, 
                    fontWeight: FontWeight.bold, letterSpacing: 5,),),
                LineChart(_fillCurvaData(vhProvider, appInfo),),
          ]),
        ),
      ),
    );
  }
}

///横屏曲线图，横屏曲线图位于屏幕左侧，占满竖向空间，横向最大占屏幕宽度-100
class CurvaChartLandscape extends ConsumerWidget {
  final double scrWidth;
  const CurvaChartLandscape({Key? key, required this.scrWidth}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vhProvider = ref.watch<VoltHistoryProvider>(Global.vHistoryProvider);
    final appInfo = ref.watch<AppInfoProvider>(Global.infoProvider);
    return Container(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        maxWidth: scrWidth - 250,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5),),
        color: Color(0xff232d37)),
      child: Padding(
        padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
        child: IndexedStack(alignment: AlignmentDirectional.center,
          index: vhProvider.dotNum == 0 ? 0 : 1,
          children: [
            //有数据时显示曲线，没有数据时显示m328v6字样
            Text('m328v6', textAlign: TextAlign.center,
              style: TextStyle(color: appInfo.curvaStartColor, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5,),),
            LineChart(_fillCurvaData(vhProvider, appInfo),),
      ]),),
    );
  }
}
