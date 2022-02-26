/// 一些Widget需要的公共便捷函数或工具
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'my_widget_chain.dart';
import 'globals.dart';

///创建页面中一行信息, 左边为标题，右边为一个Text/TextField，很多页面都用到的基本组件
///lines: TextField需要多少行文本显示
///rowHeight: 单行高度
///fontSize: 如果提供，则要全页面都按同一个字体大小，否则很难看
///titleFlex: title占一行的比例，0-1的数值
Widget buildTitleValueItemRow(String title, Widget textField, {double rowHeight=52.0, 
                          int lines=1, double? fontSize, double titleFlex=0.3}) {
  Widget titleWidget;
  titleWidget = Text(title, textAlign: TextAlign.start,
            style: TextStyle(fontSize: fontSize, color: Colors.grey[600]));
  

  return titleWidget
        .intoExpanded(flex: (titleFlex * 10).toInt())
        .addNeighbor(textField.intoExpanded(flex: (10 - (titleFlex * 10)).toInt()))
        .intoRow()
        .intoContainer(
          height: rowHeight + ((lines - 1) * 20.0), //每多一行，则添加一行文本的高度(适当多一点)
          padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5.0),
          decoration: containerDivider(bottom: true),
        );
}

///构建页面行分组之间的分割区域
///一般和buildTitleValueItemRow()结合使用
Widget buildEmptyRow(double height, {bool hasTopBorder=false, bool hasBottomBorder=true}) {
  return Container(height: height, 
    decoration: containerDivider(top: hasTopBorder, bottom: hasBottomBorder, bkColor: Colors.transparent));
}

///显示简单的Toast，可以在任何地方调用
void showToast(String text, {TextStyle textStyle = const TextStyle(fontSize: 17, color: Colors.white)}) {
  BotToast.showText(text: text, duration: const Duration(seconds: 3), textStyle: textStyle);
}

///显示简单的顶端通知信息
void showNotification(String title, {String? subTitle, bool hideCloseButton=true}) {
  BotToast.showSimpleNotification(title: title, subTitle: subTitle, hideCloseButton: hideCloseButton, duration: null);
}

///显示最简单SnackBar，注意需要在scaffold上下文调用
void showSimpleSnackBar(BuildContext context, String text) {
  var snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

///Container分割线，使用在Container的 decoration 属性
///如果需要定义Container的背景色，则使用参数 bkColor
Decoration containerDivider({bool left=false, bool top=false, bool right=false, bool bottom=false, Color? bkColor}) {
  final divider = BorderSide(width: 0.5, color: Global.tileDividerColor);
  return BoxDecoration(
    color: bkColor ?? Global.tileBkColor,
    border: Border(
      left: left ? divider : BorderSide.none,
      top: top ? divider : BorderSide.none,
      right: right ? divider : BorderSide.none,
      bottom: bottom ? divider : BorderSide.none,
    )
  );
}
