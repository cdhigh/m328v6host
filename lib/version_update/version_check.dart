/// m328v6数控电子负载上位机
/// 查询github服务器上的版本信息，如果有更新的版本，提示用户更新
/// Author: cdhigh <https://github.com/cdhigh>
import 'dart:io' show Platform;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart'; //for paste
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;
import '../i18n/common.i18n.dart';
import '../common/widget_utils.dart';
import '../common/globals.dart';
import '../common/common_utils.dart';
import 'version_models.dart';

const kVersionJsonUri = 'https://raw.githubusercontent.com/cdhigh/m328v6host/main/versions/version.json';

///现在检查更新版本
/// version: 目前的版本
/// silent: 是否静默检查
/// 如果有心版本，返回新版本详细信息，否则返回null
Future<SingleVersion?> checkUpdate({bool silent=true}) async {
  if (Global.version.isEmpty) {
    return null;
  }

  Global.lastCheckUpdateTime = DateTime.now();
  Global.saveProfile();
  if (!silent) {
    BotToast.showLoading();
  }
  final ret = await getAllUpdateInfo();
  if (!silent) {
    BotToast.closeAllLoading();
  }
  if (ret == null) {
    if (!silent) {
      showToast("Check for update failed".i18n);
    }
    return null;
  }

  final lastest = ret.lastest;
  if (lastest.isEmpty || !isVersionGreaterThan(lastest, Global.version)) {
    if (!silent) {
      showToast("Your version is up to date".i18n);
    }
    return null;
  }

  //具体版本的详细信息
  final lastestVersion = getVersionDetails(ret, lastest);
  if (lastestVersion != null) {
    if (silent) { //如果是静默检查，则检查到新版本后显示一个Toast，否则调用方会显示一个对话框
      BotToast.showText(text: "There is a new version (%s), the download link has been copied to the clipboard".i18n.fill([lastest]),
        duration: const Duration(seconds: 30), clickClose: true);
    }
    
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      pasteText(lastestVersion.androidFile);
    } else {
      pasteText(lastestVersion.windowsFile);
    }
    return lastestVersion;
  } else {
    return null;
  }
}

///连接服务器，检查更新，返回更新信息包
Future<VersionModel?> getAllUpdateInfo() async {
  final url = Uri.parse(kVersionJsonUri);
  http.Response response;
  try {
    response = await http.get(url).timeout(const Duration(seconds: 10),
      onTimeout: () => http.Response('Timeout', 408),);
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
  if (response.statusCode == 200) {
    try {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return VersionModel.fromJson(jsonResponse);
    } on FormatException catch (e) {
      debugPrint(e.toString());  //change log after
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  } else {
    return null;
  }
}

///将文本粘贴到系统剪贴板
void pasteText(String txt) {
  Clipboard.setData(ClipboardData(text: txt));
}

///在服务器返回的所有版本历史库信息里面查询对应某个版本的详细信息
SingleVersion? getVersionDetails(VersionModel model, String version) {
  final idx = model.versionList.indexWhere((elem) => elem.version == version);
  if (idx >= 0) {
    return model.versionList[idx];
  } else {
    return null;
  }
}

