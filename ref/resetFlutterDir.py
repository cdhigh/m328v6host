#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
将flutter目录恢复到刚下载时的状态
"""
import os, sys, re, shutil, datetime

__VERSION__ = "v1.0 2022-02-26"


FLUTTER_DIR = "D:/flutter"

#需要删除的目录
DIR_TO_DELETE = [
    r".pub-cache/hosted/pub.dartlang.org",
    r"packages/flutter_tools/.dart_tool",
]

#需要删除的文件
FILE_TO_DELETE = [
    r"bin/cache/artifacts/engine/android-arm-release/windows-x64/gen_snapshot.exe",
    r"packages/flutter_tools/.packages",
]

#启动替换
def process():
    print('Resetting flutter directory {}\n'.format(FLUTTER_DIR))

    for dirPath in DIR_TO_DELETE:
        print("Deleting dir: {}".format(os.path.join(FLUTTER_DIR, dirPath)))
        shutil.rmtree(os.path.join(FLUTTER_DIR, dirPath))

    for file in FILE_TO_DELETE:
        print("Deleting file: {}".format(os.path.join(FLUTTER_DIR, file)))
        os.remove(os.path.join(FLUTTER_DIR, file))
        
    os.system('pause')

process()
