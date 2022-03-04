/// m328v6数控电子负载上位机
/// 设置页面ui的某一项设置项，两行结构，上面一行正常字体，下面一行小字体，灰色
/// 还有可能在右边有一个Switch
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import '../common/my_widget_chain.dart';
import '../common/globals.dart';
import '../common/widget_utils.dart';
import '../widgets/widget_with_check.dart';

///设置页面ui的某一项设置项，两行结构，上面一行正常字体，下面一行灰色小字体
///subTitle: 可以传入String或Widget，如果传入String，则内部使用Text包裹
class SettingTile extends StatelessWidget {
  static const tileHeight = 71.0;
  final String title;
  final dynamic subTitle;
  final int subMaxLines;
  final bool? switchValue; //null则不显示Switch
  final ValueChanged? switchCallback; //Switch改变回调

  const SettingTile({Key? key, required this.title, required this.subTitle, this.switchValue, this.switchCallback, this.subMaxLines=1}) : 
    assert((subTitle is String) || (subTitle is Widget)), super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(title)
      .intoPadding(padding: const EdgeInsets.only(bottom: 5.0))
      .addNeighbor(subTitle is String 
        ? Text(subTitle, style: TextStyle(color: Global.isDarkMode ? Colors.white38 : Colors.grey[800]), 
          textScaleFactor: 0.9, maxLines: subMaxLines, overflow: TextOverflow.ellipsis)
        : subTitle)
      .intoColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min);

    if (switchValue != null) { //添加右边的Switch
      titleWidget = titleWidget.intoExpanded()
        .addNeighbor(Switch(value: switchValue!, onChanged: switchCallback))
        .intoRow();
    }
    
    return titleWidget.intoContainer(
        height: tileHeight,
        alignment: Alignment.centerLeft,
        decoration: containerDivider(bottom: true),
      );
  }
}

///主题标识行，左边一个小颜色方块，文本描述，如果当前的主题和此标识符对应，右边添加一个选中勾
///mark和title不一样，title为显示出来的文本，mark与语种无关，为程序内部的标识，序列化和反序列化需要的字符串
class SettingsThemeTile extends StatelessWidget {
  final String title;
  final String mark;  //保存到本机的标识符，与特定语言无关
  final Color color;
  const SettingsThemeTile({Key? key, required this.title, required this.mark, this.color = Colors.black87}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //颜色块和文本行
    var titleBlock = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //小色块
          Container(width: 16.0, height: 16.0,
            margin: const EdgeInsets.only(left: 5.0, right: 10.0),
            decoration: BoxDecoration(color: color, border: Border.all(color: color)),),
          Text(title),
        ]
      );

    return Container(
      height: 30.0,
      alignment: Alignment.centerLeft,
      decoration: containerDivider(bottom: true, bkColor: Global.currentTheme?.dialogBackgroundColor),
      child: (Global.selectedTheme == mark) ? WidgetWithCheck(titleBlock) : titleBlock
    );
  }
}

///设置菜单中的链接行
class LinkTile extends StatelessWidget {
  static const tileHeight = 50.0;
  final String title;
  
  const LinkTile({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(title)
      .intoPadding(padding: const EdgeInsets.only(bottom: 3.0));
      
    return titleWidget.intoContainer(
        height: tileHeight,
        alignment: Alignment.centerLeft,
        decoration: containerDivider(bottom: true),
      );
  }
}
