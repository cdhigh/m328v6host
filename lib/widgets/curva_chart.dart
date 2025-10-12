/// m328v6数控电子负载上位机
/// 放电曲线控件
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../common/globals.dart';
import '../common/common_utils.dart';
import '../models/volt_history_provider.dart';
import '../models/app_info_provider.dart';

/// 填充数据，用于绘制曲线图 (已修正 meta 参数缺失错误)
LineChartData _fillCurvaData(VoltHistoryProvider vhProvider, AppInfoProvider appInfo) {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: null,
      verticalInterval: null,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return const FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            );
            Widget text;
            if (vhProvider.needDrawXTitle(value.toInt())) {
              text = Text(readableSeconds(value.toInt()), style: style);
            } else {
              text = const Text('');
            }
            return SideTitleWidget(
              meta: meta,
              space: 5.0,
              child: text,
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: 1,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            );
            Widget text;
            if (vhProvider.needDrawYTitle(value)) {
              text = Text(value.toStringAsFixed(2), style: style);
            } else {
              text = const Text('');
            }
            return SideTitleWidget(
              meta: meta,
              space: 4.0,
              child: text,
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)
    ),
    minX: 0,
    maxX: ((vhProvider.dotNum / 10).ceil() * 10.0),
    minY: vhProvider.minV,
    maxY: vhProvider.maxV,
    lineBarsData: [
      LineChartBarData(
        spots: vhProvider.mapIndexed<FlSpot>((idx, elem) => FlSpot(idx.toDouble(), elem)).toList(),
        isCurved: false,
        color: appInfo.curvaStartColor,
        gradient: LinearGradient(colors: [appInfo.curvaStartColor, appInfo.curvaEndColor]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
      ),
    ],
  );
}

///竖屏曲线图
class CurvaChart extends ConsumerWidget {
  const CurvaChart({super.key});

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
  const CurvaChartLandscape({super.key, required this.scrWidth});

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
