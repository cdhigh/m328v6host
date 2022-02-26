#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
自动修改代码编译Windows版本的exe
"""
import os, sys, re, shutil, datetime
import zipfile

__VERSION__ = "v1.0 2022-02-22"

#构建的命令，这些命令会逐个运行
cmdList = ["flutter clean", "flutter pub get", "flutter build windows"]

M328V6_DIR = os.path.dirname(__file__)
PUB_YAML_FILE = os.path.join(M328V6_DIR, "pubspec.yaml")
UNI_SERIAL_FILE = os.path.join(M328V6_DIR, "lib", "uni_serial.dart")
GLOBAL_FILE = os.path.join(M328V6_DIR, "lib", "common", "globals.dart")
FINAL_EXE_DIR = os.path.join(M328V6_DIR, "build", "windows", "runner", "Release")
FINAL_EXE_FILE = os.path.join(M328V6_DIR, "build", "windows", "runner", "Release", "m328v6.exe")

#pubspec.yaml
VERSION_PAT = re.compile(r'^version: (.+)$')
YAML_LIBSERIAL_PAT = re.compile(r'^  (#{0,1})(flutter_libserialport: .+)$')

#lib/uni_serial.dart
DART_LIBSERIAL_PAT = re.compile(r"^(/{0,2})(import 'package:flutter_libserialport/flutter_libserialport.dart' as lib_serial;.*)$")
DART_LIBSERIAL_STUB_PAT = re.compile(r"^(/{0,2})(import 'flutter_libserialport_stub.dart' as lib_serial;.*)$")

#"lib/common/globals.dart
GLOBAL_VERSION_PAT = re.compile(r"^( *static +const +version += +[\"'])(1.0.0)([\"'].*)$")

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
            lines[idx] = "  " + mat.group(2)  #取消注释libeserial
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
            lines[idx] = mat.group(2) #取消注释libserial
        
        mat = DART_LIBSERIAL_STUB_PAT.match(line)
        if mat:
            foundFlag |= DART_LIBSERIAL_STUB_MASK
            lines[idx] = "//" + mat.group(2) #注释stub

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
            lines[idx] = mat.group(1) + ver + mat.group(3) #将yaml里面的版本号拷贝过来
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

    #将生成的EXE目录压缩到桌面一个zip文件
    desktopZip = os.path.join(deskPath, "m328v6_win_V{}.zip".format(version))
    try:
        if (os.path.exists(FINAL_EXE_FILE)):
            if (os.path.exists(desktopZip)):
                os.remove(desktopZip)
            print("\n\nCompressing release directory to {}\n\n".format(desktopZip))
            zipDirectoryToFile(FINAL_EXE_DIR, desktopZip)
    except Execution as e:
        print("\n\nCompress release directory failed: {}\n\n".format(ste(e)))
    
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
        #print("Cannot delete backup directory {}".format(bakDir))
        pass

    elaspsedTime = datetime.datetime.now() - startTime
    print('\nExecution time : {}\n'.format(elaspsedTime))
    os.system('pause')

process()
