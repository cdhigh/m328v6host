/// 从底部弹出的数字键盘
/// Author: cdhigh <https://github.com/cdhigh>
/// 使用方法：
/// 1. 导入此文件
/// 2. 直接使用 await showNumKeyboardDialog()
///   参数 intNumber/doubleNumber 只能传入一个，如果传入两个，则行为未定义（内部实现可能会变化）

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../common/my_widget_chain.dart';

typedef NumKeyBoardCallBack = void Function();

///便捷函数，打开数字键盘
Future<num?> showNumKeyboardDialog({required BuildContext context, int? intNumber, double? doubleNumber, bool darkMode=false}) async {
  var ret = await showModalBottomSheet(
    context: context,
    isScrollControlled: true, //需要此参数保证对话框可以超过屏幕的一半
    builder: (ctx){
      return SafeArea(child: BottomKeyboardWidget(intNumber: intNumber, doubleNumber: doubleNumber, darkMode: darkMode));
    });
  
  return ret;
}

///数字键盘Widget
class BottomKeyboardWidget extends StatefulWidget {
  final double? doubleNumber;  //如果此变量不为空，则为浮点模式
  final int? intNumber;  //如果此变量不为空，则为整数模式
  final ValueChanged<num?>? onValueChanged;
  final bool darkMode;
  final bool firstPressToClear; //第一次按键是否清除原先的数字
  
  const BottomKeyboardWidget({Key? key, this.intNumber=0, this.doubleNumber, this.darkMode=false,
        this.onValueChanged, this.firstPressToClear=true}) : super(key: key);
  
  @override
  _BottomKeyboardWidgetState createState() => _BottomKeyboardWidgetState();
}
 
class _BottomKeyboardWidgetState extends State<BottomKeyboardWidget> {
  late double? doubleNumber;
  late int? intNumber;
  late String text; //显示出来的数值
  bool firstPress = false;

  @override
  void initState() {
    super.initState();
    intNumber = widget.intNumber;
    doubleNumber = widget.doubleNumber;
    if (doubleNumber == null) {
      intNumber = 0;
      text = '0';
    } else if (doubleNumber != null) { //有时候浮点数会有很多位小数点，这里只取小数点后三位
      doubleNumber = (doubleNumber! * 1000).toInt() / 1000;
      text = doubleNumber.toString();
    } else {
      text = intNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 51.0;
    
    //第一行
    var firstLine = Text(text, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold))
      .intoPadding(padding: const EdgeInsets.only(left: 20.0))
      .intoExpanded(flex: 2)
      .addNeighbor(
        TextButton(
          child: const Text('Enter', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),), //color: Theme.of(context).primaryColor, 
          onPressed: ()=>onEnterPressed(context),)
        .intoExpanded(flex: 1)
      )
      .intoRow()
      .intoContainer(height: rowHeight, margin: const EdgeInsets.only(top: 5.0));
    //第二行
    var secondLine = NumButton(text: '1', callback: ()=>pressNumber('1'), darkMode: widget.darkMode)
      .addNeighbor(NumButton(text: '2', callback: ()=>pressNumber('2'), darkMode: widget.darkMode))
      .addNeighbor(NumButton(text: '3', callback: ()=>pressNumber('3'), darkMode: widget.darkMode))
      .intoRow()
      .intoContainer(height: rowHeight);
    //第三行
    var thirdLine = NumButton(text: '4', callback: ()=>pressNumber('4'), darkMode: widget.darkMode)
      .addNeighbor(NumButton(text: '5', callback: ()=>pressNumber('5'), darkMode: widget.darkMode))
      .addNeighbor(NumButton(text: '6', callback: ()=>pressNumber('6'), darkMode: widget.darkMode))
      .intoRow()
      .intoContainer(height: rowHeight);
    //第四行
    var fourthLine = NumButton(text: '7', callback: ()=>pressNumber('7'), darkMode: widget.darkMode)
      .addNeighbor(NumButton(text: '8', callback: ()=>pressNumber('8'), darkMode: widget.darkMode))
      .addNeighbor(NumButton(text: '9', callback: ()=>pressNumber('9'), darkMode: widget.darkMode))
      .intoRow()
      .intoContainer(height: rowHeight);
    
    //第五行
    var fifthLine = NumButton(text: doubleNumber != null ? '.' : '', 
        callback: doubleNumber != null ? pressDot : null,
        darkMode: widget.darkMode)
      .addNeighbor(NumButton(text: '0', callback: ()=>pressNumber('0'), darkMode: widget.darkMode))
      .addNeighbor(NumButton(icon: Icons.backspace, callback: pressBack, darkMode: widget.darkMode))
      .intoRow()
      .intoContainer(height: 50.0, margin: const EdgeInsets.only(bottom: 5.0));
      
    return [firstLine, secondLine, thirdLine, fourthLine, fifthLine]
      .intoColumn()
      .intoContainer(
        height: rowHeight * 5 + 10,
        width: double.infinity,);
        //color: widget.darkMode ? Colors.black54 : Colors.white);
  }

  ///按下了确认键
  void onEnterPressed(BuildContext context) {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(doubleNumber ?? intNumber);
    }
    Navigator.of(context).pop(doubleNumber ?? intNumber);
  }
  
  //将显示的数字字符串转换为数值类型
  void parseNumber() {
    if (doubleNumber != null) {
      var newText = text;
      if (newText.isEmpty) {
        newText = '0.0';
      } else if (newText.endsWith('.')) {
        newText = newText.substring(0, newText.length - 1);
      }
      doubleNumber = newText.isNotEmpty ? (double.tryParse(newText) ?? 0.0) : 0.0;
    } else {
      intNumber = text.isNotEmpty ? (int.tryParse(text) ?? 0) : 0;
    }
  }

  ///通用的按0-9数字键处理函数
  void pressNumber(String numStr) {
    assert(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(numStr));
    SystemSound.play(SystemSoundType.click); //声音反馈

    //第一次按键清除原先的数字
    if (widget.firstPressToClear && !firstPress) {
      text = '';
      firstPress = true;
    }

    setState(() {
      text += numStr;
      parseNumber();
    });
  }

  ///按键 小数点
  void pressDot() {
    if (doubleNumber != null) {
      //第一次按键清除原先的数字
      if (widget.firstPressToClear && !firstPress) {
        text = '';
        firstPress = true;
      }

      if (text.isEmpty) {
        text = '0';
      } else if (text.contains('.')) { //一串数字仅有一个数字点
        return;
      }

      setState(() {
        text += '.';
        parseNumber();
      });
    }
  }

  ///按键 退位
  void pressBack() {
    //退格键和其他数字键不一样，第一次进入数字键盘页面就按退格键说明只是想删最后一位数字，不需要清除全部位数
    firstPress = true;
    
    setState(() {
      if (text.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      }
      parseNumber();
    });
  }
}

///每个按键的控件
class NumButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final NumKeyBoardCallBack? callback;
  final bool enabled;
  final bool darkMode;
  
  const NumButton({Key? key, this.text, this.icon, this.callback, this.enabled=true, this.darkMode=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 3;
    Color txtColor = darkMode ? Colors.white60 : const Color(0xff333333);
    if (!enabled) {
      txtColor = darkMode ? Colors.grey[800]! : Colors.grey[200]!;
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        side: BorderSide(color: darkMode ? Colors.white12 : const Color(0x10333333)),),
      child: (text != null ? 
          Text(text!, style: TextStyle(
              color: txtColor, 
              fontSize: 20.0)) :
          Icon(icon)),
      onPressed: callback,)
      .intoContainer(height: 50.0, width: _width);
  }
}