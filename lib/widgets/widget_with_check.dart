///生成一个右边有一个选中符号的Widget行
///
library;
import 'package:flutter/material.dart';

class WidgetWithCheck extends StatelessWidget {
  final Widget title;
  final Color? iconColor;
  const WidgetWithCheck(this.title, {super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final primaryColor = currentTheme.primaryColor;
    var color = iconColor ?? primaryColor;
    if (currentTheme.brightness == Brightness.dark) {
      color = Colors.white70;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: title),
        Icon(Icons.check, color: color),
      ],
    );
  }
}
