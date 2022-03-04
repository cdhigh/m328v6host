/// 定义几种弹出的模态对话框
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/services.dart';
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
            Text(cancelText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop<bool>(false)),
            Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop<bool>(true)),
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
Future<String?> showInputDialog({required BuildContext context, required String title, String? okText, String? cancelText,
    String? initialText, TextInputType? keyboardType, List<TextInputFormatter>? formatters}) async {
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
            Expanded(child: TextField(autofocus: true, keyboardType: keyboardType, controller: controller,
              inputFormatters: formatters,))
          ]),
        actions: <Widget>[
            Text(cancelText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop()),
            Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop<String>(controller.text.trim())),
          ],
      );
    },
  );

  return ret;
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
          Text(okText!, style: const TextStyle(color: Colors.black)).intoTextButton(onPressed: ()=>Navigator.of(ctx).pop<Color>(currentColor)),
        ],
      );
    }
  );

  return ret;
}

///TextField可用的几个定制的inputFormatter
///DecimalTextInputFormatter: 仅允许输入一个数字
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d*');
    final String newStr = regEx.stringMatch(newValue.text) ?? '';
    return (newStr == newValue.text) ? TextEditingValue(text: newStr) : oldValue;
  }
}

///仅允许小于某个浮点数的数值
class CustomMaxValueInputFormatter extends TextInputFormatter {
  final double maxInputValue;
  CustomMaxValueInputFormatter(this.maxInputValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final TextSelection newSel = newValue.selection;
    String truncated = newValue.text;
    final double? value = double.tryParse(newValue.text);
    if (value == null) {
      return newValue;
    } else if (value > maxInputValue) {
        truncated = maxInputValue.toString();
    }
    return TextEditingValue(text: truncated, selection: newSel);
  }
}

