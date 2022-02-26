///项目中使用的自定义图标字体，先在阿里图标网站 <https://www.iconfont.cn> 上选择需要的图标，
///添加到购物车，添加到一个项目，然后下载到本地，再使用脚本iconfont2dart.py可以生成dart代码
///或使用网站<https://xwrite.gitee.io/blog/>也可以转换css文件为dart代码

import 'package:flutter/widgets.dart';
class IconFont {
  static const String _family = 'iconfont';
  IconFont._();
  static const IconData serialPort = IconData(0xe895, fontFamily: _family);
}
