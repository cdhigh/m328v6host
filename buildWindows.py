#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
自动修改代码编译Windows版本的exe
"""
import os, sys, re, shutil, datetime
import zipfile

__VERSION__ = "2025-10-11"

#构建的命令，这些命令会逐个运行
cmdList = ["flutter clean", "flutter pub get", "flutter build windows"]

M328V6_DIR = os.path.dirname(os.path.abspath(__file__))
PUB_YAML_FILE = os.path.join(M328V6_DIR, "pubspec.yaml")
GLOBAL_FILE = os.path.join(M328V6_DIR, "lib", "common", "globals.dart")
FINAL_EXE_DIR = os.path.join(M328V6_DIR, "build", "windows", "runner", "Release")
FINAL_EXE_FILE = os.path.join(M328V6_DIR, "build", "windows", "runner", "Release", "m328v6.exe")

#pubspec.yaml
VERSION_PAT = re.compile(r'^version: (.+)$')

#"lib/common/globals.dart
GLOBAL_VERSION_PAT = re.compile(r"^( *static +const +version += +[\"'])([0-9\.]+)([\"'].*)$")

VERSION_MASK = 0x01
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

#将整个目录打包到一个ZIP文件
def zipDirectoryToFile(dirName: str, fileName: str):
    with zipfile.ZipFile(fileName, 'w', zipfile.ZIP_DEFLATED) as f:
        for dirRoot, subDirNames, fileNames in os.walk(dirName):
            for name in fileNames:
                if (dirRoot.startswith(FINAL_EXE_DIR)):
                    dirInZip = dirRoot[len(FINAL_EXE_DIR):]
                if (dirInZip.startswith(("/", "\\"))):
                    dirInZip = dirInZip[1:]
                #print(os.path.join(dirInZip, name))
                f.write(os.path.join(dirRoot, name), os.path.join(dirInZip, name))


#启动替换
def process():
    print('Auto Compile M328V6Host Windows execute release {}\n'.format(__VERSION__))

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

    #将生成的EXE目录压缩到桌面一个zip文件
    desktopZip = os.path.join(deskPath, "m328v6_win_V{}.zip".format(version))
    try:
        if (os.path.exists(FINAL_EXE_FILE)):
            if (os.path.exists(desktopZip)):
                os.remove(desktopZip)
            print("\n\nCompressing release directory to {}\n\n".format(desktopZip))
            zipDirectoryToFile(FINAL_EXE_DIR, desktopZip)
    except Exception as e:
        print("\n\nCompress release directory failed: {}\n\n".format(str(e)))
    
    elaspsedTime = datetime.datetime.now() - startTime
    print('\nExecution time : {}\n'.format(elaspsedTime))
    os.system('pause')

process()
