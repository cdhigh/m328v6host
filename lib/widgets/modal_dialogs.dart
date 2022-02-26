/// 定义几种弹出的模态对话框
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../common/my_widget_chain.dart';
import '../i18n/common.i18n.dart';

///弹出有两个选择的对话框，选择Ok返回true，选择Cancel返回false
///title为字符串，content为Widget(一般传入一个Text)
Future<bool?> showOkCancelAlertDialog({required BuildContext context, required String title, required Widget content, 
                              String? okText, String? cancelText}) async {
  okText ??= 'Okay'.i18n;
  cancelText ??= 'Cancel'.i18n;

  return showDialog<bool?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            Text(cancelText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop(false)),
            Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop(true)),
          ],
        );
      },
    );
}

///弹出只有一个确定按钮的对话框
///title为字符串，content为Widget(一般传入一个Text)
Future<void> showOkAlertDialog({required BuildContext context, required String title, required Widget content, String? okText}) async {
  okText ??= 'Okay'.i18n;

  await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop()),
          ],
        );
      },
    );
}

///弹出输入框，要求输入一个字符串
Future<String> showInputDialog({required BuildContext context, required String title, String? okText, String? cancelText,
    String? initialText, TextInputType? keyboardType}) async {
  okText ??= 'Okay'.i18n;
  cancelText ??= 'Cancel'.i18n;
  var controller = TextEditingController();
  if (initialText != null) {
    controller.text = initialText;
    controller.selection = TextSelection(baseOffset: 0, extentOffset: initialText.length);
  }
  
  var ret = await showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Row(
          children: <Widget>[
            Expanded(child: TextField(autofocus: true, 
              keyboardType: keyboardType, controller: controller))
          ]),
        actions: <Widget>[
            Text(cancelText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop()),
            Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop(controller.text.trim())),
          ],
      );
    },
  );

  return ret ?? "";
}

///显示取色对话框
Future<Color?> showColorPickerDialog({required BuildContext context, String? title, String? okText, String? cancelText,
    Color initialColor = Colors.white}) async {
  okText ??= 'Okay'.i18n;
  cancelText ??= 'Cancel'.i18n;
  
  var currentColor = initialColor;

  //内嵌函数
  void colorChanged(Color color) => currentColor = color;

  var ret = await showDialog<Color>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title ?? ('Pick a color'.i18n)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: colorChanged,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          Text(cancelText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop()),
          Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop(currentColor)),
        ],
      );
    }
  );

  return ret;
}