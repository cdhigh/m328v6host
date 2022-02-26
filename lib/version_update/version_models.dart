/// 服务器上的软件版本数据结构
/// Author: cdhigh <https://github.com/cdhigh>

///某一个版本信息实体类
class SingleVersion {
  final String version;
  final DateTime buildDate;
  final String androidFile;
  final String windowsFile;
  final String whatsNew;

  const SingleVersion({required this.version, required this.buildDate, 
    required this.androidFile, required this.windowsFile, required this.whatsNew});

  factory SingleVersion.fromJson(Map<String, dynamic> data) {
    return SingleVersion(
      version: data["version"] ?? "", 
      buildDate: DateTime.tryParse(data["build"]) ?? DateTime(2022),
      androidFile: data["android"] ?? "",
      windowsFile: data["windows"] ?? "",
      whatsNew: data["whatsnew"] ?? "",
    );
  }
}


///Github服务器上保存的version.json对应的实体类
class VersionModel {
  final String lastest;
  final List<SingleVersion> versionList;
  
  const VersionModel({required this.lastest, required this.versionList});

  factory VersionModel.fromJson(Map<String, dynamic> data) {
    return VersionModel(
      lastest: data['lastest'] ?? "",
      versionList: (data['history'] ?? []).map((i)=>SingleVersion.fromJson(i)).toList(),
    );
  }
}
