#!/usr/bin/env python3
# -*- coding:utf-8 -*-
"""
将 阿里图标库 <http://iconfont.cn> 下载的 iconfont.json转换为 iconfont.dart
兼容python2.x和3.x
Author: cdhigh <https://github.com/cdhigh>
"""

__Version__ = '2020-06-10'

import os, sys, json

if sys.version_info[0] == 2:
    import io
    open = io.open

#返回dart文件头部固定信息
def dartHeader(fontFamily='iconfont'):
    return '\n'.join(["///项目中使用的自定义图标字体，先在阿里图标网站 <https://www.iconfont.cn> 上选择需要的图标，",
        "///添加到购物车，添加到一个项目，然后下载到本地，再使用脚本iconfont2dart.py可以生成dart代码",
        "///或使用网站<https://xwrite.gitee.io/blog/>也可以转换css文件为dart代码",
        "",
        "import 'package:flutter/widgets.dart';",
        "class IconFont {", 
        "  static const String _family = '%s';" % fontFamily,
        "  IconFont._();"])
    
#iconfont.json转dart，返回一个文件字符串
def iconFontJsonToDart(inputFile):
    lineBuff = []
    data = None
    with open(inputFile, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if not isinstance(data, dict):
        print('Input file not is valid iconfont json: %s' % inputFile)
        return
    
    lineBuff.append(dartHeader(data.get('font_family', 'iconfont')))
    
    for icon in data.get('glyphs', []):
        name = icon.get('font_class', '').replace('-', '_')
        #为了符合dart的命名规则，第一个字母变为小写
        if len(name) > 1:
            name = name[0].lower() + name[1:]
        code = icon.get('unicode_decimal', 0)
        
        lineBuff.append("  static const IconData %s = IconData(0x%x, fontFamily: _family);" % (name, code))
    
    lineBuff.append('}')
    lineBuff.append('')
    return '\n'.join(lineBuff)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('\tIconFont json to dart [build: %s]' % __Version__)
        print('\nConvert iconfont.json of <http://iconfont.cn> to dart file.')
        print('\nUsage: \n\tpython iconfont2dart.py input_file [output_file]')
        sys.exit()
    
    dirName = os.path.dirname(__file__)
    if len(sys.argv) >= 2:
        inputFile = os.path.join(dirName, sys.argv[1])
        outputFile = os.path.join(dirName, 'iconfont.dart')
        
    if len(sys.argv) >= 3:
        outputFile = os.path.join(os.path.dirname(__file__), sys.argv[2])
    
    
    with open(outputFile, 'w', encoding='utf-8') as f:
        f.write(iconFontJsonToDart(inputFile))
    
    print('\nConverted json to dart: %s\n' % outputFile)
    
    