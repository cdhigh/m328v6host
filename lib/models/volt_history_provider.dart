/// m328v6数控电子负载上位机
/// 封装放电历史电压数据为Provider使用
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import '../common/globals.dart';

///用于Provider的容器类
class VoltHistoryProvider extends ChangeNotifier {
  final _filter = _VoltHistoryFilter();
  final _vHistory = <double>[]; //下位机上报的实时电压历史
  final _xTitles = <int>[]; //在此列表中的电压位置会绘制时间标签
  final _yTitles = <double>[]; //在此列表中的电压位置会绘制电压标签
  double _maxV = 0;    //电压历史列表中最大电压
  double _minV = double.maxFinite; //电压历史列表中最小电压
  
  double get maxV => _maxV;
  //保证Y轴最小有1V的区域
  //double get minV => min<double>(_minV, (_maxV > 1.0) ? (_maxV - 1.0) : 0.0);
  double get minV => _minV;
  int get dotNum => _vHistory.length;
  List<double> get vHistory => _vHistory; //暴露此列表有些不合适，但是效率高，以后再改吧

  ///添加一个实时电压
  void add(double volt) {
    _vHistory.add(_filter.add(volt));
    if (volt > _maxV) {
      _maxV = volt;
    }
    if (volt < _minV) {
      _minV = volt;
    }

    //更新需要绘制标签的索引
    _xTitles.clear();
    _yTitles.clear();
    //cnt先往上取整为10的倍数
    final cnt = ((_vHistory.length / 10).ceil() * 10);
    if (cnt > 120){
      _xTitles.add(cnt * 30 ~/ 100);
      _xTitles.add(cnt * 60 ~/ 100);
      _xTitles.add(cnt - 10);
    } else if (cnt > 60) {
      _xTitles.add(cnt ~/ 2);
      _xTitles.add(cnt);
    } else {
      _xTitles.add(cnt);
    }

    if (cnt > 0) {
      _yTitles.add(_minV);
      _yTitles.add(_maxV);
      final mid = (((_minV + _maxV) / 2) * 1000).round() / 1000; //仅保留三位小数
      if (_vHistory.contains(mid)) {
        _yTitles.add(mid);
      }
    }

    notifyListeners();
  }

  ///确定一个数值位置是否需要绘制X轴标签
  bool needDrawXTitle(int x) {
    return _xTitles.contains(x);
  }

  bool needDrawYTitle(double y) {
    return _yTitles.contains(y);
  }

  ///清除电压历史
  void clear() {
    _vHistory.clear();
    _xTitles.clear();
    _yTitles.clear();
    _filter.reset();
    _maxV = 0;
    _minV = double.maxFinite;
    notifyListeners();
  }

  ///仅复位滤波器
  void resetFilter() {
    _filter.reset();
  }

  ///创建一个原始数据备份返回，用于数据导出
  List<double> cloneList() {
    return [..._vHistory];
  }

  ///返回一个迭代器，第一个元素为索引，第二个元素为元素本身
  Iterable<T> mapIndexed<T>(T Function(int index, double elem) convert) sync* {
    for (var index = 0; index < _vHistory.length; index++) {
      yield convert(index, _vHistory[index]);
    }
  }
}

///用于电压历史数据滤波
class _VoltHistoryFilter {
  static const maxFilterNum = 10; //最多10个数据进行平滑

  final _list = List<double>.filled(maxFilterNum, 0.0);
  var _cnt = 0;  //数据个数
  var _idx = 0;  //下一个数据的索引
  var _prevValue = 0.0;

  ///往滤波器里面添加一个数据，并且返回一个滤波后的数据
  double add(double volt) {
    assert(Global.curvaFilterDotNum <= maxFilterNum);

    //避免因为传输误码或同时收发等原因导致解析失败，产生偶尔的零，来两个零才输出零
    if (volt == 0.0) {
      if (_prevValue != 0.0) {
        final prevTemp = _prevValue;
        _prevValue = 0.0;
        return prevTemp;
      } else { //清空缓冲区，返回零
        reset();
        return 0.0;
      }
    }

    //对阀值进行处理
    if ((volt - _prevValue).abs() > Global.curvaFilterThreshold) {
      reset();
    }

    _prevValue = volt;
    _list[_idx] = volt;
    _idx++;
    if (_idx >= Global.curvaFilterDotNum) {
      _idx = 0;
    }
    
    if (_cnt >= Global.curvaFilterDotNum) {
      var sum = 0.0;
      for (var i = 0; i < Global.curvaFilterDotNum; i++) {
        sum += _list[i];
      }
      //仅保留三位小数，避免曲线不够平滑
      return ((sum / Global.curvaFilterDotNum) * 1000).round() / 1000;
    } else {
      _cnt++;
      return volt;
    }
  }

  //复位过滤器
  void reset() {
    for (var i = 0; i < maxFilterNum; i++) {
      _list[_idx] = 0.0;
    }
    _prevValue = 0.0;
    _cnt = 0;
    _idx = 0;
  }
}
