///一个左上角有小字体提示的文本框

import 'package:flutter/material.dart';
import 'package:segment_display/segment_display.dart';

//右上角有小字体的数码管显示
class SevenSegmentWithSuperText extends StatelessWidget {
  final Color? color;
  final String value;
  final double size;
  final String title;
  
  const SevenSegmentWithSuperText({Key? key, required this.value, required this.size, this.color, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 5), 
          child: Text(title, style: const TextStyle(color: Colors.white60, fontSize: 12))),
        SevenSegmentDisplay(size: size, backgroundColor: Colors.transparent,
          value: value,
          segmentStyle: DefaultSegmentStyle(enabledColor: color ?? Colors.red,
            disabledColor: (color ?? Colors.red).withOpacity(0.15),),
    )]));
  }
}

class LeftSuperScriptText extends StatelessWidget {
  final String mainText;
  final String scriptText;
  final TextStyle style;
  final TextStyle? scriptStyle;

  const LeftSuperScriptText(this.mainText, this.scriptText, {Key? key, required this.style, this.scriptStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(child: Text(scriptText, style: scriptStyle), padding: const EdgeInsets.only(left: 20)),
        Text(mainText, style: style,)
      ],);
  }
}
