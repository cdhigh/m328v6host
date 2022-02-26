/// 饼图或其他图像的 区段指示器，左边为一个颜色块，右边为文本
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';

///带颜色块的指示器
///color: 颜色； text: 文本指示；
///isSquare: 颜色指示块形状，true-方形（默认），false-圆形
///size: 颜色块和文本的大小，默认16像素(flutter默认字体大小为14)
///textColor: 文本颜色，默认灰色；fontBold: 文本是否粗体，默认粗体
class ColoredIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final bool fontBold;

  const ColoredIndicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16.0,
    this.textColor = const Color(0xff505050),
    this.fontBold = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderColor = color;
    if ((color.alpha <= 50) || ((color.red >= 0xfe) && (color.green >= 0xfe) && (color.blue >= 0xfe))) {
      borderColor = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          margin: const EdgeInsets.only(right: 5.0),
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
            border: Border.all(color: borderColor),
          ),
        ),
        Text(text,
          style: TextStyle(fontSize: size, color: textColor, 
            fontWeight: fontBold ? FontWeight.bold : FontWeight.normal),
        )
      ],
    );
  }
}
