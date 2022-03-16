/// 一些简单的常用的小工具函数
/// Author: cdhigh <https://github.com/cdhigh>
import 'dart:math';
import 'package:flutter/material.dart';

///将秒数转换为分钟或小时表示
String readableSeconds(int seconds) {
  if (seconds < 60) {
    return "${seconds}s";
  } else if (seconds < 60 * 60) {
    return "${(seconds ~/ 60)}m${seconds % 60}s";
  } else {
    return "${(seconds ~/ 3600)}h${(seconds % 3600)}m";
  }
}

///比较两个版本号，确定新版本号是否比老版本号更新，
///版本号格式为：1.1.0，可能在最后还有一个修订版本号: 1.1.0+1，但是会忽略修订版本号(我不用修订版本号)
bool isVersionGreaterThan(String newVersion, String currVersion){
  final newV = newVersion.replaceAll("+", ".").split(".");
  final currV = currVersion.replaceAll("+", ".").split(".");
  final maxSeg = min(newV.length, currV.length);
  for (var i = 0 ; i <= maxSeg - 1; i++) {
    final vn = int.tryParse(newV[i]);
    final vc = int.tryParse(currV[i]);
    if ((vn == null) || (vc == null)) {
      return false;
    }
    
    if (vn != vc) {
      return (vn > vc);
    }
  }
  return false;
}

///将字节数转换为可以直读的字符串（比如：xxx KB, xxx MB）
String formatBytes(int bytes, {int decimals=2}) {
  if (bytes <= 0) {
    return "0 B";
  }
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

///判断一个字符串是否是合法的URL
bool isUrl(String txt) {
  if (isNullEmpty(txt)) {
    return false;
  }

  var regEx = RegExp(r"^(?=^.{3,255}$)(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:\d+)*(\/\w+\.\w+)*([\?&]\w+=\w*)*$",
        caseSensitive: false, multiLine: false);
  return regEx.hasMatch(txt);
}

///返回一个随机颜色
Color randomColor() {
  return Color.fromARGB(0xff, Random().nextInt(254), Random().nextInt(254), Random().nextInt(254));
}

///计算出ARGB叠加背景色后的真实颜色，返回的颜色Alpha通道固定为0xff
///背景色仅取RGB通道，如果背景色还有Alpha通道，还需要先计算真实的背景色然后再调用此函数
///算法：<https://en.wikipedia.org/wiki/Alpha_compositing>
Color alphaCompositing(Color srcColor, Color bkColor) {
  var srcAlpha = srcColor.opacity;
  var srcRed = srcColor.red / 0xff;
  var srcGreen = srcColor.green / 0xff;
  var srcBlue = srcColor.blue / 0xff;
  var bkRed = bkColor.red / 0xff;
  var bkGreen = bkColor.green / 0xff;
  var bkBlue = bkColor.blue / 0xff;
  var targetRed = ((1.0 - srcAlpha) * bkRed) + (srcAlpha * srcRed);
  var targetGreen = ((1.0 - srcAlpha) * bkGreen) + (srcAlpha * srcGreen);
  var targetBlue = ((1.0 - srcAlpha) * bkBlue) + (srcAlpha * srcBlue);

  return Color.fromARGB(0xff, 
    (targetRed >= 1.0) ? 0xff : (targetRed * 0xff).toInt(),
    (targetGreen >= 1.0) ? 0xff : (targetGreen * 0xff).toInt(),
    (targetBlue >= 1.0) ? 0xff : (targetBlue * 0xff).toInt());
}

///判断一个颜色是深色还是浅色，用于动态适配文字或按钮颜色，此函数不使用Alpha通道
///如果有Alpha通道，则需要使用alphaCompositing()计算出真实呈现的颜色再调用此函数
bool isDarkColor(Color color) {
  //return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) < 192;
  //改成flutter内部使用的方式
  return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
}

///判断一个变量是否为空，可以用于字符串，列表，Map等
bool isNullEmpty(dynamic v) {
  return ((v == null) || v.isEmpty);
}

///判断一个变量是否不为空，可以用于字符串，列表，Map等
bool isNotNullEmpty(dynamic v) {
  return ((v != null) && v.isNotEmpty);
}

///字符串的几个扩展
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  ///根据指定长度截断字符串，添加省略号
  String truncateWithEllipsis(int cutoff) {
    return (length <= cutoff) ? this : '${substring(0, cutoff)}...';
  }
}


