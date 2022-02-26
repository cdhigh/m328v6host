//补充widget_chain缺少的控件方法
import 'package:flutter/material.dart';
export 'widget_extensions.dart';
export 'widget_list_extensions.dart';

extension MyWidgetChain on Widget {
  Widget intoInkWell({
    Key? key, 
    GestureTapCallback? onTap, 
    GestureTapCallback? onDoubleTap, 
    GestureLongPressCallback? onLongPress, 
    GestureTapDownCallback? onTapDown, 
    GestureTapCancelCallback? onTapCancel, 
    }) {
    return InkWell(
      key: key,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      child: this,
    );
  }

  Widget intoElevatedButton({
    Key? key, 
    @required VoidCallback? onPressed, 
    VoidCallback? onLongPress, 
    ButtonStyle? style,
    }) {
    return ElevatedButton(
      key: key, 
      onPressed: onPressed, 
      onLongPress: onLongPress, 
      style: style,
      child: this,
    );
  }

  Widget intoOutlinedButton({
    Key? key, 
    required VoidCallback? onPressed, 
    VoidCallback? onLongPress, 
    ButtonStyle? style,
    }) {
    return OutlinedButton(
      key: key, 
      onPressed: onPressed, 
      onLongPress: onLongPress, 
      style: style, 
      child: this,
    );
  }

  Widget intoDefaultTextStyle({
    Key? key,
    required TextStyle style,
    TextAlign? textAlign,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
  }) {
    return DefaultTextStyle(
      key: key,
      style: style,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      child: this,
    );
  }

  Widget intoFractionallySizedBox({
        Key? key, 
        AlignmentGeometry alignment=Alignment.center, 
        double? widthFactor, 
        double? heightFactor}) {
    return FractionallySizedBox(
      key: key,
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  Widget intoSafeArea({Key? key, left = true, top = true, right = true, bottom = true}) {
    return SafeArea(key: key, left: left, top: top, right: right, bottom: bottom, child: this);
  }
  
}
