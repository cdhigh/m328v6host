#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
自动修改代码编译apk，即使屏蔽 flutter_libserialport 也经常编译失败，只能靠运气编译成功
"""
import os, sys, re, shutil, datetime

__VERSION__ = "v1.0 2022-02-22"

#构建的命令，这些命令会逐个运行
cmdList = ["flutter clean", "flutter pub get", "flutter build apk"]
#cmdList = ["flutter pub get", "flutter build apk"]

#经过多次测试，发现将此文件恢复到默认状态即可每次编译成功
FLUTTER_DIR = r"D:/flutter"
GEN_SNAPSHOT_FILE = os.path.join(FLUTTER_DIR, "bin/cache/artifacts/engine/android-arm-release/windows-x64/gen_snapshot.EXE")
GEN_SNAPSHOT_ORIGNAL_FILE = os.path.join(FLUTTER_DIR, "bin/cache/artifacts/engine/android-arm-release/windows-x64/gen_snapshot_orignal.EXE")

M328V6_DIR = os.path.dirname(__file__)
PUB_YAML_FILE = os.path.join(M328V6_DIR, "pubspec.yaml")
UNI_SERIAL_FILE = os.path.join(M328V6_DIR, "lib", "uni_serial.dart")
GLOBAL_FILE = os.path.join(M328V6_DIR, "lib", "common", "globals.dart")
FINAL_APK_FILE = os.path.join(M328V6_DIR, "build", "app", "outputs", "flutter-apk", "app-release.apk")

#pubspec.yaml
VERSION_PAT = re.compile(r'^version: (.+)$')
YAML_LIBSERIAL_PAT = re.compile(r'^  (#{0,1})(flutter_libserialport: .+)$')

#lib/uni_serial.dart
DART_LIBSERIAL_PAT = re.compile(r"^(/{0,2})(import 'package:flutter_libserialport/flutter_libserialport.dart' as lib_serial;.*)$")
DART_LIBSERIAL_STUB_PAT = re.compile(r"^(/{0,2})(import 'flutter_libserialport_stub.dart' as lib_serial;.*)$")

#"lib/common/globals.dart
GLOBAL_VERSION_PAT = re.compile(r"^( *static +const +version += +[\"'])([0-9\.]+)([\"'].*)$")

VERSION_MASK = 0x01
YAML_LIBSERIAL_MASK = 0x02
DART_LIBSERIAL_MASK = 0x04
DART_LIBSERIAL_STUB_MASK = 0x08
GLOBAL_VERSION_MASK = 0x10
MODIFIED_ALL_MASK = 0x1f

#获取桌面路径
def getDesktopPath():
    return os.path.join(os.path.expanduser("~"), "Desktop")

#修改pubspec.yaml，返回元祖(version, foundFlag)
def modifyPubspecYaml() -> tuple:
    foundFlag = 0
    version = ""
    with open(PUB_YAML_FILE, 'r', encoding='utf-8') as f:
        lines = f.read().split('\n')
    
    for idx, line in enumerate(lines):
        mat = VERSION_PAT.match(line)
        if mat:
            foundFlag = VERSION_MASK
            version = mat.group(1)
            break

    if (not version):
        return ("", 0)

    for idx, line in enumerate(lines):
        mat = YAML_LIBSERIAL_PAT.match(line)
        if mat:
            foundFlag |= YAML_LIBSERIAL_MASK
            lines[idx] = "  #" + mat.group(2)  #注释掉libeserial
            break
    
    if (foundFlag == (VERSION_MASK | YAML_LIBSERIAL_MASK)):
        with open(PUB_YAML_FILE, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        
    return version, foundFlag

#修改lib/uni_serial.dart，返回foundFlag
def modifyUniSerialDart() -> int:
    foundFlag = 0

    with open(UNI_SERIAL_FILE, 'r', encoding='utf-8') as f:
        lines = f.read().split('\n')
    
    for idx, line in enumerate(lines):
        mat = DART_LIBSERIAL_PAT.match(line)
        if mat:
            foundFlag |= DART_LIBSERIAL_MASK
            lines[idx] = "//" + mat.group(2) #注释掉libserial
        
        mat = DART_LIBSERIAL_STUB_PAT.match(line)
        if mat:
            foundFlag |= DART_LIBSERIAL_STUB_MASK
            lines[idx] = mat.group(2) #取消注释stub

        if (foundFlag == (DART_LIBSERIAL_MASK | DART_LIBSERIAL_STUB_MASK)):
            break

    if (foundFlag == (DART_LIBSERIAL_MASK | DART_LIBSERIAL_STUB_MASK)):
        with open(UNI_SERIAL_FILE, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))

    return foundFlag

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

    #恢复gen_snapshot.exe
    if os.path.exists(GEN_SNAPSHOT_ORIGNAL_FILE):
        try:
            os.remove(GEN_SNAPSHOT_FILE)
        except Exception as e:
            print("Delete gen_snapshot.exe failed: {}".format(str(e)))

        shutil.copyfile(GEN_SNAPSHOT_ORIGNAL_FILE, GEN_SNAPSHOT_FILE)
    else: #第一次编译，备份gen_snapshot.exe
        shutil.copyfile(GEN_SNAPSHOT_FILE, GEN_SNAPSHOT_ORIGNAL_FILE)
    
    #先备份要修改的文件
    bakDir = os.path.join(M328V6_DIR, "buildBak")
    bakPubspecYaml = os.path.join(bakDir, "pubspec.yaml")
    bakUniSerialDart = os.path.join(bakDir, "uni_serial.dart")
    bakGlobalsDart = os.path.join(bakDir, "globals.dart")
    if not os.path.exists(bakDir):
        os.makedirs(bakDir)
    try:
        os.remove(bakPubspecYaml)
        os.remove(bakUniSerialDart)
        os.remove(bakGlobalsDart)
    except:
        pass
    shutil.copyfile(PUB_YAML_FILE, bakPubspecYaml)
    shutil.copyfile(UNI_SERIAL_FILE, bakUniSerialDart)
    shutil.copyfile(GLOBAL_FILE, bakGlobalsDart)

    #开始修改文件
    version, foundFlag = modifyPubspecYaml()
    if not version:
        print('\nVersion string not found in pubspec.yaml\n')
        #恢复备份文件
        os.remove(PUB_YAML_FILE)
        os.remove(UNI_SERIAL_FILE)
        os.remove(GLOBAL_FILE)
        shutil.copyfile(bakPubspecYaml, PUB_YAML_FILE)
        shutil.copyfile(bakUniSerialDart, UNI_SERIAL_FILE)
        shutil.copyfile(bakGlobalsDart, GLOBAL_FILE)
        shutil.rmtree(bakDir)
        os.system('pause')
        return

    ok = input('\nVersion found [{}]\n\nCorrect?[y/n]'.format(version))
    if ok.lower() not in ('', 'y', 'yes', 'ok'):
        #恢复备份文件
        os.remove(PUB_YAML_FILE)
        os.remove(UNI_SERIAL_FILE)
        os.remove(GLOBAL_FILE)
        shutil.copyfile(bakPubspecYaml, PUB_YAML_FILE)
        shutil.copyfile(bakUniSerialDart, UNI_SERIAL_FILE)
        shutil.copyfile(bakGlobalsDart, GLOBAL_FILE)
        shutil.rmtree(bakDir)
        return

    foundFlag |= modifyUniSerialDart()
    foundFlag |= modifyGlobalDart(version)
    if (foundFlag != MODIFIED_ALL_MASK):
        print('foundFlag : 0x{:x} != 0x{:x}!'.format(foundFlag, MODIFIED_ALL_MASK))
        #恢复备份文件
        os.remove(PUB_YAML_FILE)
        os.remove(UNI_SERIAL_FILE)
        os.remove(GLOBAL_FILE)
        shutil.copyfile(bakPubspecYaml, PUB_YAML_FILE)
        shutil.copyfile(bakUniSerialDart, UNI_SERIAL_FILE)
        shutil.copyfile(bakGlobalsDart, GLOBAL_FILE)
        shutil.rmtree(bakDir)
        return

    ok = input('\nPlease confirm modifications in pubspec.yaml/uni_serial.dart/globals.dart\n\nCorrect?[y/n]')
    if ok.lower() not in ('', 'y', 'yes', 'ok'):
        #恢复备份文件
        os.remove(PUB_YAML_FILE)
        os.remove(UNI_SERIAL_FILE)
        os.remove(GLOBAL_FILE)
        shutil.copyfile(bakPubspecYaml, PUB_YAML_FILE)
        shutil.copyfile(bakUniSerialDart, UNI_SERIAL_FILE)
        shutil.copyfile(bakGlobalsDart, GLOBAL_FILE)
        shutil.rmtree(bakDir)
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
        print("\n\nCopy apk file failed: {}\n\n".format(ste(e)))
    
    #恢复备份文件
    os.remove(PUB_YAML_FILE)
    os.remove(UNI_SERIAL_FILE)
    os.remove(GLOBAL_FILE)
    shutil.copyfile(bakPubspecYaml, PUB_YAML_FILE)
    shutil.copyfile(bakUniSerialDart, UNI_SERIAL_FILE)
    shutil.copyfile(bakGlobalsDart, GLOBAL_FILE)
    try:
        shutil.rmtree(bakDir)
    except:
        #print("Delete backup directory [{}] failed:".format(bakDir))
        pass

    elaspsedTime = datetime.datetime.now() - startTime
    print('\nExecution time : {}\n'.format(elaspsedTime))
    os.system('pause')

process()
