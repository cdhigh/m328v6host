// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get okay => '好的';

  @override
  String get cancel => '取消';

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get noItem => '没有项目';

  @override
  String get noData => '没有数据';

  @override
  String itemsCount(int count) {
    return '条目: $count';
  }

  @override
  String get choose => '选择';

  @override
  String get empty => '[空白]';

  @override
  String get inputNewText => '输入新文本';

  @override
  String get search => '搜索';

  @override
  String get connectionTimeout => '连接超时';

  @override
  String get timeout => '超时错误';

  @override
  String get pickAColor => '选取一个颜色';

  @override
  String get date => '日期';

  @override
  String get checkForUpdateFailed => '检查更新失败';

  @override
  String get versionUpToDate => '您的版本为最新的';

  @override
  String newVersionAvailable(String version) {
    return '发现新版本($version), 下载链接已经拷贝到系统剪贴板';
  }

  @override
  String get deviceNameInvalid => '设备名字错误';

  @override
  String get settings => '设置';

  @override
  String get externalStorageDirectory => '外部存储目录';

  @override
  String get appDocumentDirectory => '应用文档目录';

  @override
  String get prompt => '提示';

  @override
  String get clear => '清除';

  @override
  String get yes => '确定';

  @override
  String get general => '通用';

  @override
  String get keepScreenOn => '保持屏幕常亮';

  @override
  String get doesNotKeepScreenOn => '不保持屏幕常亮';

  @override
  String get keepScreenOnDuringDischarge => '放电时保持屏幕常亮';

  @override
  String get keepScreenOnWhileAppRunning => '在应用运行时保持屏幕常亮';

  @override
  String get doesNotKeepOn => '不保持常亮';

  @override
  String get duringDischarging => '放电时';

  @override
  String get duringAppRunning => '应用运行时';

  @override
  String get auto => '自动';

  @override
  String get english => '英语';

  @override
  String get chinese => '简体汉语';

  @override
  String get language => '语种';

  @override
  String get restartRequired => '需要重启';

  @override
  String get restartRequiredMessage => '您需要重新启动应用程序以应用语言更改';

  @override
  String get theme => '主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get homepageBackgroundColor => '主页背景颜色';

  @override
  String get blue => '蓝色';

  @override
  String get green => '绿色';

  @override
  String get blueGrey => '蓝灰色';

  @override
  String get brown => '棕色';

  @override
  String get cyan => '青色';

  @override
  String get lightBlue => '浅蓝色';

  @override
  String get orange => '橙色';

  @override
  String get pink => '粉色';

  @override
  String get red => '红色';

  @override
  String get teal => '青绿色';

  @override
  String get lime => '酸橙绿';

  @override
  String get unconnected => '未连接';

  @override
  String get connected => '已连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get connect => '连接';

  @override
  String get vSet => '电压设置';

  @override
  String get iSet => '电流设置';

  @override
  String get v => '电压';

  @override
  String get i => '电流';

  @override
  String get power => '功率';

  @override
  String get cr => '恒阻';

  @override
  String get cp => '恒功率';

  @override
  String get capacity => '容量';

  @override
  String get energy => '能量';

  @override
  String get rd => '内阻';

  @override
  String get ra => '内阻A';

  @override
  String get heatSink => '散热器';

  @override
  String get board => '主板';

  @override
  String get voltageMustBeLessThan65Volts => '电压必须小于65伏';

  @override
  String get currentMustBeLessThan15A => '电流必须小于15安';

  @override
  String get confirm => '确认';

  @override
  String get clearAh => '清除安时';

  @override
  String get clearCurvaData => '清除曲线数据';

  @override
  String get showLoadStats => '显示负载统计';

  @override
  String get turnOnElectronicLoad => '开启电子负载？\n如果需要，请记住清除安时';

  @override
  String get turnOffElectronicLoad => '关闭电子负载？';

  @override
  String get dischargeHasEnded => '放电已结束';

  @override
  String get connection => '连接';

  @override
  String get availableDevices => '可用设备';

  @override
  String get baudRate => '波特率';

  @override
  String get noDevice => '没有设备';

  @override
  String get baudRateIsInvalid => '波特率无效';

  @override
  String get openDeviceFailed => '打开设备失败';

  @override
  String get data => '数据';

  @override
  String get autoReconnect => '自动重连';

  @override
  String get autoReconnectIfConnectionInterruption => '连接中断时自动重连';

  @override
  String get autoSynchronizeTime => '自动同步时间';

  @override
  String get autoSynchronizeTimeToLoad => '自动同步时间到负载';

  @override
  String get numberOfPointsForSmoothCurve => '平滑曲线点数';

  @override
  String get thresholdForSmoothCurve => '平滑曲线阈值';

  @override
  String get curveLineStartColor => '曲线起始颜色';

  @override
  String get curveLineEndColor => '曲线结束颜色';

  @override
  String get version => '版本';

  @override
  String get currentVersion => '当前版本';

  @override
  String get checkFrequency => '检查频率';

  @override
  String get checkForUpdateNow => '立即检查更新';

  @override
  String get theLinkOfTheOfficialSiteHasBeenCopiedToTheClipboard =>
      '官方网站链接已复制到剪贴板';

  @override
  String get numberOfPoints => '点数';

  @override
  String get enterAValueFrom0000To1000V => '输入 0.000 到 1.000 之间的值 (V)';

  @override
  String get theValueMustBeGreaterThan0000AndLessThan1000 =>
      '值必须大于 0.000 且小于 1.000';

  @override
  String get never => '从不';

  @override
  String get oneWeek => '一周';

  @override
  String get oneMonth => '一个月';

  @override
  String get oneYear => '一年';

  @override
  String days(String count) {
    return '$count天';
  }

  @override
  String foundNewVersion(String version) {
    return '发现新版本 [$version]';
  }

  @override
  String get download => '下载';

  @override
  String get whatsnew => '更新内容：';

  @override
  String get theDownloadLinkHasBeenCopiedToTheClipboard => '下载链接已复制到剪贴板';

  @override
  String get help => '帮助';

  @override
  String get swipeOnTheLeftSideOfTheScreenToPopupTheMenu => '在屏幕左侧滑动以弹出菜单';

  @override
  String get doubleClickVsetToSetANewValue => '双击\'电压设置\'以设置新值';

  @override
  String get doubleClickIsetToSetANewValue => '双击\'电流设置\'以设置新值';

  @override
  String get doubleClickCapacityToClearAhOfDevice => '双击\'容量\'以清除设备安时';

  @override
  String get doubleClickCurvaAreaToClearCurvaData => '双击\'曲线区域\'以清除曲线数据';

  @override
  String get switchMode => '切换模式';

  @override
  String get ccMode => '恒流模式';

  @override
  String get crMode => '恒阻模式';

  @override
  String get cpMode => '恒功率模式';

  @override
  String get setTheResistorValueOhm => '设置电阻值(欧姆)';

  @override
  String get setThePowerValueW => '设置功率值(瓦)';

  @override
  String get set => '设置';

  @override
  String get success => '成功';

  @override
  String get setCcModeSuccessfully => '设置恒流模式成功';

  @override
  String get setCrModeSuccessfully => '设置恒阻模式成功';

  @override
  String get setCpModeSuccessfully => '设置恒功率模式成功';

  @override
  String get error => '错误';

  @override
  String get resistanceMustBeGreaterThanZeroOhmAndLessThan655Ohms =>
      '电阻必须大于0欧姆且小于655欧姆';

  @override
  String get powerMustBeGreaterThanZeroWattAndLessThan650Watts =>
      '功率必须大于0瓦且小于650瓦';

  @override
  String get m328v6ElectronicLoad => 'M328v6电子负载';

  @override
  String device(String version, String buildDate) {
    return '设备 : $version [$buildDate]';
  }

  @override
  String disconnectPort(String port) {
    return '断开连接 [$port]';
  }

  @override
  String get loadOn => '开启负载';

  @override
  String get loadOff => '负载关闭';

  @override
  String get deviceOperations => '设备操作';

  @override
  String get otherOperations => '其他操作';

  @override
  String get raOn => '内阻A开启';

  @override
  String get raOff => '内阻A关闭';

  @override
  String get zeroRa => '内阻A归零';

  @override
  String get zeroI => '电流归零';

  @override
  String get clearTime => '清除时间';

  @override
  String get synchronizeTime => '同步时间';

  @override
  String get turnOffBuzzer => '关闭蜂鸣器';

  @override
  String get mode => '模式';

  @override
  String get delayPeriodOnOff => '延时/周期开关机';

  @override
  String get testMaxCapcity => '测试最大容量';

  @override
  String get testShortCircuit => '测试短路';

  @override
  String get export => '导出';

  @override
  String get exportCurvaData => '导出曲线数据';

  @override
  String get exportType => '导出类型';

  @override
  String get xlsxFile => 'XLSX文件';

  @override
  String get txtFile => 'TXT文件';

  @override
  String get exportFolder => '导出文件夹';

  @override
  String get selectAFolderToSave => '选择保存文件夹';

  @override
  String get fileName => '文件名';

  @override
  String get enterANameToSave => '输入保存名称';

  @override
  String get remark => '备注';

  @override
  String get enterARemark => '输入备注';

  @override
  String exportFileSuccess(String type) {
    return '导出$type文件成功';
  }

  @override
  String get time => '时间';

  @override
  String get voltage => '电压';

  @override
  String get loadStats => '负载统计';

  @override
  String get clickToAddRemark => '点击添加备注';

  @override
  String get inputARemark => '输入备注';

  @override
  String get initialV => '初始电压';

  @override
  String get endV => '结束电压';

  @override
  String get averageV => '平均电压';

  @override
  String get initialI => '初始电流';

  @override
  String get endI => '结束电流';

  @override
  String get averageI => '平均电流';

  @override
  String get initialAh => '初始安时';

  @override
  String get ah => '安时';

  @override
  String get totalAh => '总安时';

  @override
  String get initialWh => '初始瓦时';

  @override
  String get wh => '瓦时';

  @override
  String get totalWh => '总瓦时';

  @override
  String get crValue => '恒阻值';

  @override
  String get cpValue => '恒功率值';

  @override
  String get headSink => '散热器';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get duration => '持续时间';

  @override
  String get exportLoadStatsData => '导出负载统计数据';

  @override
  String get item => '项目';

  @override
  String get value => '数值';

  @override
  String get delayPeriod => '延时&周期';

  @override
  String get currentStatus => '当前状态';

  @override
  String delayOn(String time) {
    return '延时开机   : $time';
  }

  @override
  String delayOff(String time) {
    return '延时关机  : $time';
  }

  @override
  String periodOn(String time) {
    return '周期开机  : $time';
  }

  @override
  String periodOff(String time) {
    return '周期关机 : $time';
  }

  @override
  String get setDelayOn => '设置预约开机';

  @override
  String get setDelayOff => '设置预约关机';

  @override
  String get setPeriodOnOff => '设置周期开关机';

  @override
  String get onTime => '开机时间';

  @override
  String get offTime => '关机时间';

  @override
  String get timeMustBeLessThan18Hours => '时间必须小于18小时';

  @override
  String get setDelayOnSuccessfully => '设置预约开机成功';

  @override
  String get setDelayOffSuccessfully => '设置预约关机成功';

  @override
  String get setPeriodOnOffSuccessfully => '设置周期开关机成功';

  @override
  String get testPsuMaxCapacity => '测试电源最大容量';

  @override
  String get parameters => '参数';

  @override
  String get startTestCurrent => '起始测试电流 (A)';

  @override
  String get endTestCurrent => '结束测试电流 (A)';

  @override
  String get currentStep => '电流步长 (A)';

  @override
  String get stepTime => '步长时间';

  @override
  String get endCondition => '结束条件';

  @override
  String get voltageDropPercent => '电压下降 (%)';

  @override
  String get voltageDropVolt => '电压下降 (V)';

  @override
  String get endVoltage => '结束电压 (V)';

  @override
  String get processAndResults => '过程和结果';

  @override
  String get maxPower => '最大功率';

  @override
  String get maxCurrent => '最大电流';

  @override
  String get status => '状态';

  @override
  String get resume => '恢复';

  @override
  String get pause => '暂停';

  @override
  String get stop => '停止';

  @override
  String get startCurrentValueIsInvalid => '起始电流值无效';

  @override
  String get endCurrentValueIsInvalid => '结束电流值无效';

  @override
  String get currentStepValueIsInvalid => '电流步长值无效';

  @override
  String get voltageDropPercentageIsInvalid => '电压下降百分比无效';

  @override
  String get voltageDropValueIsInvalid => '电压下降值无效';

  @override
  String get endVoltageValueIsInvalid => '结束电压值无效';

  @override
  String get testing => '测试中';

  @override
  String get paused => '已暂停';

  @override
  String get stopped => '已停止';

  @override
  String get completed => '已完成';

  @override
  String get waiting => '等待中';

  @override
  String get shortCircuitTester => '短路测试器!!!';

  @override
  String get warningThisTestIsVeryDangerous => '警告：此测试非常危险！';

  @override
  String get pleaseDoNotTestTheBattery => '请不要测试电池。';

  @override
  String get beforeTheTestMakeSureThatThePowerSupplyHasShortCircuitProtection =>
      '测试前，请确保电源具有短路保护。';

  @override
  String get onlyForPowerSupplyUnder10V => '仅适用于10V以下的电源。';

  @override
  String get shorted => '短路';

  @override
  String get inTheGap => '间隙中';

  @override
  String get powerSupplyNotConnected => '电源未连接';

  @override
  String get voltageIsTooHigh => '电压过高';

  @override
  String get numberOfTests => '测试次数';

  @override
  String get enterTheNumberOfTests => '输入测试次数';

  @override
  String get shortCircuitTime => '短路时间';

  @override
  String get gapTime => '间隙时间';

  @override
  String get current => '电流';

  @override
  String get testProgress => '测试进度';

  @override
  String get numberOfTestsIsInvalid => '测试次数无效';

  @override
  String get nameOfDeviceInvalid => '设备名称无效';

  @override
  String yearsLater(String count) {
    return '$count年后';
  }

  @override
  String daysLater(String count) {
    return '$count天后';
  }

  @override
  String hoursLater(String count) {
    return '$count小时后';
  }

  @override
  String minutesLater(String count) {
    return '$count分钟后';
  }

  @override
  String secondsLater(String count) {
    return '$count秒后';
  }

  @override
  String get justNow => '刚刚';

  @override
  String secondsAgo(String count) {
    return '$count秒前';
  }

  @override
  String minutesAgo(String count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(String count) {
    return '$count小时前';
  }

  @override
  String daysAgo(String count) {
    return '$count天前';
  }

  @override
  String yearsAgo(String count) {
    return '$count年前';
  }

  @override
  String get unit => '单位';

  @override
  String get exportLoadStatsFileSuccess => '导出负载统计文件成功';

  @override
  String get testMaxCapacity => '测试最大容量';

  @override
  String get doesNotKeepTheScreenAlwaysOn => '不保持屏幕常亮';

  @override
  String get keepScreenOnWhileTheAppIsRunning => '应用运行时保持屏幕常亮';

  @override
  String get bluetoothPermissionRequired => '需要蓝牙权限才能连接设备，请重新授权';

  @override
  String get bluetoothConnectionTimeout => '蓝牙连接超时，请检查设备是否可访问并重试';

  @override
  String get bluetoothConnectionClosed => '蓝牙连接已关闭，请重新连接设备';

  @override
  String get bluetoothConnectionRefused => '蓝牙连接被拒绝，请检查设备状态';

  @override
  String get bluetoothDeviceNotFound => '蓝牙设备未找到，请检查设备是否已配对';

  @override
  String get bluetoothPermissionDenied => '蓝牙权限被拒绝，请在设置中允许蓝牙权限';

  @override
  String bluetoothConnectionFailed(String error) {
    return '蓝牙连接失败: $error';
  }

  @override
  String get simulatedTerminal => '模拟终端';

  @override
  String get terminal => '终端';

  @override
  String get displayMode => '显示模式';

  @override
  String get decimal => '十进制';

  @override
  String get hexadecimal => '十六进制';

  @override
  String get terminalOutput => '终端输出';

  @override
  String get noDataReceived => '未收到数据';

  @override
  String get clearTerminal => '清空终端';

  @override
  String get terminalPaused => '终端已暂停';

  @override
  String get terminalResumed => '终端已恢复';

  @override
  String get exportFileFailed => '导出文件失败，请检查保存路径和存储权限';

  @override
  String get timeFormatIsInvalid => '时间格式不合法，请输入00:00:00～23:59:59之间的时间';

  @override
  String get connectionLostDuringTest =>
      '测试过程中连接已断开！下位机MOS可能仍处于强制状态，重连后请手动检查下位机状态';
}
