#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
自动修改代码编译apk
升级版本只需要修改pubspec.yaml里面的version属性，此脚本将此版本同步到globals.dart
"""
import os, sys, re, shutil, datetime

__VERSION__ = "2025-10-11"

#构建的命令，这些命令会逐个运行
cmdList = ["flutter clean", "flutter pub get", "flutter build apk"]
#cmdList = ["flutter pub get", "flutter build apk"]

M328V6_DIR = os.path.dirname(os.path.abspath(__file__))
PUB_YAML_FILE = os.path.join(M328V6_DIR, "pubspec.yaml")
GLOBAL_FILE = os.path.join(M328V6_DIR, "lib", "common", "globals.dart")
FINAL_APK_FILE = os.path.join(M328V6_DIR, "build", "app", "outputs", "flutter-apk", "app-release.apk")

#pubspec.yaml
VERSION_PAT = re.compile(r'^version: (.+)$')

#"lib/common/globals.dart
#版本号可能带有+N后缀（如1.3.0+1），因此中间部分不能限制为纯数字
GLOBAL_VERSION_PAT = re.compile(r"^( *static +const +version += +[\"'])([^\"']+)([\"'].*)$")

GLOBAL_VERSION_MASK = 0x10

#获取桌面路径
def getDesktopPath():
    return os.path.join(os.path.expanduser("~"), "Desktop")

#从pubspec.yaml获取版本号
def getPubspecVersion() -> str:
    version = ""
    with open(PUB_YAML_FILE, 'r', encoding='utf-8') as f:
        lines = f.read().split('\n')
    
    for idx, line in enumerate(lines):
        mat = VERSION_PAT.match(line)
        if mat:
            version = mat.group(1)
            break

    return version

#修改lib/common/globals.dart，返回foundFlag
def modifyGlobalDart(ver: str):
    foundFlag = 0

    with open(GLOBAL_FILE, 'r', encoding='utf-8') as f:
        lines = f.read().split('\n')
    
    for idx, line in enumerate(lines):
        mat = GLOBAL_VERSION_PAT.match(line)
        if mat:
            foundFlag = GLOBAL_VERSION_MASK
            lines[idx] = mat.group(1) + ver + mat.group(3)
            break

    if (foundFlag == GLOBAL_VERSION_MASK):
        with open(GLOBAL_FILE, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))

    return foundFlag

#启动替换
def process():
    print('Auto Compile M328V6Host APK {}\n'.format(__VERSION__))

    deskPath = getDesktopPath()
    if (not deskPath):
        print("Cannot deteminate desktop path")
        return
    else:
        print("Desktop path : {}".format(deskPath))

            
    #开始修改文件
    version = getPubspecVersion()
    if not version:
        print('\nVersion string not found in pubspec.yaml\n')
        os.system('pause')
        return

    ok = input('\nVersion number [{}] in pubspec.yaml will be sync to globals.dart\n\nConfirm version and continue?[y/n]'.format(version))
    if ok.lower() not in ('', 'y', 'yes', 'ok'):
        return

    foundFlag = modifyGlobalDart(version)
    if (foundFlag != GLOBAL_VERSION_MASK):
        print('Modify version number in globals.dart failed')
        return

    startTime = datetime.datetime.now()

    #编译，每次都清除后全新编译
    os.chdir(M328V6_DIR)
    for cmd in cmdList:
        print("\n{}\n".format(cmd))
        os.system(cmd)
    
    #拷贝生成的apk文件到桌面
    desktopApk = os.path.join(deskPath, "m328v6_V{}.apk".format(version))
    try:
        if (os.path.exists(FINAL_APK_FILE)):
            if (os.path.exists(desktopApk)):
                os.remove(desktopApk)
            print("\n\nCopy apk file to {}\n\n".format(desktopApk))
            shutil.copyfile(FINAL_APK_FILE, desktopApk)
    except Exception as e:
        print("\n\nCopy apk file failed: {}\n\n".format(str(e)))
    
    elaspsedTime = datetime.datetime.now() - startTime
    print('\nExecution time : {}\n'.format(elaspsedTime))
    os.system('pause')

process()
