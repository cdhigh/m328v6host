///使用此Widget代替SafeArea可以让系统的标题栏也变成和自己选择的主题颜色一致，否则会是黑色的

import 'package:flutter/material.dart';

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color? color;

  const ColoredSafeArea({Key? key, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
