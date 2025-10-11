// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get okay => 'Okay';

  @override
  String get cancel => 'Cancel';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get noItem => 'No item';

  @override
  String get noData => 'No data';

  @override
  String itemsCount(int count) {
    return 'Items: $count';
  }

  @override
  String get choose => 'Choose';

  @override
  String get empty => '[Empty]';

  @override
  String get inputNewText => 'Input new text';

  @override
  String get search => 'Search';

  @override
  String get connectionTimeout => 'Connection timeout';

  @override
  String get timeout => 'Timeout';

  @override
  String get pickAColor => 'Pick a color';

  @override
  String get date => 'Date';

  @override
  String get checkForUpdateFailed => 'Check for update failed';

  @override
  String get versionUpToDate => 'Your version is up to date';

  @override
  String newVersionAvailable(String version) {
    return 'There is a new version ($version), the download link has been copied to the clipboard';
  }

  @override
  String get deviceNameInvalid => 'Name of device invalid';

  @override
  String get settings => 'Settings';

  @override
  String get externalStorageDirectory => 'External storage directory';

  @override
  String get appDocumentDirectory => 'App document directory';

  @override
  String get prompt => 'Prompt';

  @override
  String get clear => 'Clear';

  @override
  String get yes => 'Yes';

  @override
  String get general => 'General';

  @override
  String get keepScreenOn => 'Keep screen on';

  @override
  String get doesNotKeepScreenOn => 'Does not keep the screen always on';

  @override
  String get keepScreenOnDuringDischarge => 'Keep screen on during discharge';

  @override
  String get keepScreenOnWhileAppRunning =>
      'Keep screen on while the app is running';

  @override
  String get doesNotKeepOn => 'Does not keep on';

  @override
  String get duringDischarging => 'During discharging';

  @override
  String get duringAppRunning => 'During app running';

  @override
  String get auto => 'Auto';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get language => 'Language';

  @override
  String get restartRequired => 'Restart required';

  @override
  String get restartRequiredMessage =>
      'You need to restart the application to apply the language change';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get homepageBackgroundColor => 'Homepage background color';

  @override
  String get blue => 'Blue';

  @override
  String get green => 'Green';

  @override
  String get blueGrey => 'Blue Grey';

  @override
  String get brown => 'Brown';

  @override
  String get cyan => 'Cyan';

  @override
  String get lightBlue => 'Light Blue';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Pink';

  @override
  String get red => 'Red';

  @override
  String get teal => 'Teal';

  @override
  String get lime => 'Lime';

  @override
  String get unconnected => 'Unconnected';

  @override
  String get connected => 'Connected';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connect => 'Connect';

  @override
  String get vSet => 'V Set';

  @override
  String get iSet => 'I Set';

  @override
  String get v => 'V';

  @override
  String get i => 'I';

  @override
  String get power => 'Power';

  @override
  String get cr => 'CR';

  @override
  String get cp => 'CP';

  @override
  String get capacity => 'Capacity';

  @override
  String get energy => 'Energy';

  @override
  String get rd => 'Rd';

  @override
  String get ra => 'Ra';

  @override
  String get heatSink => 'Heat sink';

  @override
  String get board => 'Board';

  @override
  String get voltageMustBeLessThan65Volts =>
      'The voltage must be less than 65 volts';

  @override
  String get currentMustBeLessThan15A => 'The current must be less than 15A';

  @override
  String get confirm => 'Confirm';

  @override
  String get clearAh => 'Clear Ah';

  @override
  String get clearCurvaData => 'Clear curva data';

  @override
  String get showLoadStats => 'Show load stats';

  @override
  String get turnOnElectronicLoad =>
      'Turn on the electronic load?\nRemember to clear Ah, if needed';

  @override
  String get turnOffElectronicLoad => 'Turn off the electronic load?';

  @override
  String get dischargeHasEnded => 'Discharge has ended';

  @override
  String get connection => 'Connection';

  @override
  String get availableDevices => 'Available devices';

  @override
  String get baudRate => 'Baud rate';

  @override
  String get noDevice => 'No device';

  @override
  String get baudRateIsInvalid => 'Baud rate is invalid';

  @override
  String get openDeviceFailed => 'Open device failed';

  @override
  String get data => 'Data';

  @override
  String get autoReconnect => 'Auto reconnect';

  @override
  String get autoReconnectIfConnectionInterruption =>
      'Auto reconnect if connection interruption';

  @override
  String get autoSynchronizeTime => 'Auto synchronize time';

  @override
  String get autoSynchronizeTimeToLoad => 'Auto synchronize time to load';

  @override
  String get numberOfPointsForSmoothCurve =>
      'Number of points for smooth curve';

  @override
  String get thresholdForSmoothCurve => 'Threshold for smooth curve';

  @override
  String get curveLineStartColor => 'Curve line start color';

  @override
  String get curveLineEndColor => 'Curve line end color';

  @override
  String get version => 'Version';

  @override
  String get currentVersion => 'Current version';

  @override
  String get checkFrequency => 'Check frequency';

  @override
  String get checkForUpdateNow => 'Check for update now';

  @override
  String get theLinkOfTheOfficialSiteHasBeenCopiedToTheClipboard =>
      'The link of the official site has been copied to the clipboard';

  @override
  String get numberOfPoints => 'Number of points';

  @override
  String get enterAValueFrom0000To1000V =>
      'Enter a value from 0.000 to 1.000 (V)';

  @override
  String get theValueMustBeGreaterThan0000AndLessThan1000 =>
      'The value must be greater than 0.000 and less than 1.000';

  @override
  String get never => 'Never';

  @override
  String get oneWeek => 'One week';

  @override
  String get oneMonth => 'One month';

  @override
  String get oneYear => 'One year';

  @override
  String days(String count) {
    return '$count days';
  }

  @override
  String foundNewVersion(String version) {
    return 'Found new version [$version]';
  }

  @override
  String get download => 'Download';

  @override
  String get whatsnew => 'Whatsnew:';

  @override
  String get theDownloadLinkHasBeenCopiedToTheClipboard =>
      'The download link has been copied to the clipboard';

  @override
  String get help => 'Help';

  @override
  String get swipeOnTheLeftSideOfTheScreenToPopupTheMenu =>
      'Swipe on the left side of the screen to popup the menu';

  @override
  String get doubleClickVsetToSetANewValue =>
      'Double-click \'Vset\' to set a new value';

  @override
  String get doubleClickIsetToSetANewValue =>
      'Double-click \'Iset\' to set a new value';

  @override
  String get doubleClickCapacityToClearAhOfDevice =>
      'Double-click \'Capacity\' to clear Ah of device';

  @override
  String get doubleClickCurvaAreaToClearCurvaData =>
      'Double-click \'Curva area\' to clear curva data';

  @override
  String get switchMode => 'Switch Mode';

  @override
  String get ccMode => 'CC Mode';

  @override
  String get crMode => 'CR Mode';

  @override
  String get cpMode => 'CP Mode';

  @override
  String get setTheResistorValueOhm => 'set the resistor value (Ohm)';

  @override
  String get setThePowerValueW => 'set the power value (W)';

  @override
  String get set => 'Set';

  @override
  String get success => 'Success';

  @override
  String get setCcModeSuccessfully => 'set CC mode successfully';

  @override
  String get setCrModeSuccessfully => 'set CR mode successfully';

  @override
  String get setCpModeSuccessfully => 'set CP mode successfully';

  @override
  String get error => 'Error';

  @override
  String get resistanceMustBeGreaterThanZeroOhmAndLessThan655Ohms =>
      'Resistance must be greater than zero ohm and less than 655 ohms';

  @override
  String get powerMustBeGreaterThanZeroWattAndLessThan650Watts =>
      'Power must be greater than zero watt and less than 650 watts';

  @override
  String get m328v6ElectronicLoad => 'M328v6 Electronic Load';

  @override
  String device(String version, String buildDate) {
    return 'Device : $version [$buildDate]';
  }

  @override
  String disconnectPort(String port) {
    return 'Disconnect [$port]';
  }

  @override
  String get loadOn => 'Load On';

  @override
  String get loadOff => 'Load Off';

  @override
  String get deviceOperations => 'Device Operations';

  @override
  String get otherOperations => 'Other Operations';

  @override
  String get raOn => 'Ra On';

  @override
  String get raOff => 'Ra Off';

  @override
  String get zeroRa => 'Zero Ra';

  @override
  String get zeroI => 'Zero I';

  @override
  String get clearTime => 'Clear Time';

  @override
  String get synchronizeTime => 'Synchronize Time';

  @override
  String get turnOffBuzzer => 'Turn off Buzzer';

  @override
  String get mode => 'Mode';

  @override
  String get delayPeriodOnOff => 'Delay/Period On/Off';

  @override
  String get testMaxCapcity => 'Test max capcity';

  @override
  String get testShortCircuit => 'Test short circuit';

  @override
  String get export => 'Export';

  @override
  String get exportCurvaData => 'Export curva data';

  @override
  String get exportType => 'Export type';

  @override
  String get xlsxFile => 'XLSX file';

  @override
  String get txtFile => 'TXT file';

  @override
  String get exportFolder => 'Export folder';

  @override
  String get selectAFolderToSave => 'Select a folder to save';

  @override
  String get fileName => 'File name';

  @override
  String get enterANameToSave => 'Enter a name to save';

  @override
  String get remark => 'Remark';

  @override
  String get enterARemark => 'Enter a remark';

  @override
  String exportFileSuccess(String type) {
    return 'Export $type file success';
  }

  @override
  String get time => 'Time';

  @override
  String get voltage => 'Voltage';

  @override
  String get loadStats => 'Load Stats';

  @override
  String get clickToAddRemark => 'Click to add remark';

  @override
  String get inputARemark => 'Input a remark';

  @override
  String get initialV => 'Initial V';

  @override
  String get endV => 'End V';

  @override
  String get averageV => 'Average V';

  @override
  String get initialI => 'Initial I';

  @override
  String get endI => 'End I';

  @override
  String get averageI => 'Average I';

  @override
  String get initialAh => 'Initial Ah';

  @override
  String get ah => 'Ah';

  @override
  String get totalAh => 'Total Ah';

  @override
  String get initialWh => 'Initial Wh';

  @override
  String get wh => 'Wh';

  @override
  String get totalWh => 'Total Wh';

  @override
  String get crValue => 'CR value';

  @override
  String get cpValue => 'CP value';

  @override
  String get headSink => 'Head sink';

  @override
  String get startTime => 'Start time';

  @override
  String get endTime => 'End time';

  @override
  String get duration => 'Duration';

  @override
  String get exportLoadStatsData => 'Export load stats data';

  @override
  String get item => 'Item';

  @override
  String get value => 'Value';

  @override
  String get delayPeriod => 'Delay&Period';

  @override
  String get currentStatus => 'Current Status';

  @override
  String delayOn(String time) {
    return 'Delay on   : $time';
  }

  @override
  String delayOff(String time) {
    return 'Delay off  : $time';
  }

  @override
  String periodOn(String time) {
    return 'Period on  : $time';
  }

  @override
  String periodOff(String time) {
    return 'Period off : $time';
  }

  @override
  String get setDelayOn => 'set Delay on';

  @override
  String get setDelayOff => 'set Delay off';

  @override
  String get setPeriodOnOff => 'set Period On/Off';

  @override
  String get onTime => 'On time';

  @override
  String get offTime => 'Off time';

  @override
  String get timeMustBeLessThan18Hours => 'Time must be less than 18 hours';

  @override
  String get setDelayOnSuccessfully => 'set Delay On successfully';

  @override
  String get setDelayOffSuccessfully => 'set Delay Off successfully';

  @override
  String get setPeriodOnOffSuccessfully => 'set Period On/Off successfully';

  @override
  String get testPsuMaxCapacity => 'Test PSU max capacity';

  @override
  String get parameters => 'Parameters';

  @override
  String get startTestCurrent => 'Start test current (A)';

  @override
  String get endTestCurrent => 'End test current (A)';

  @override
  String get currentStep => 'Current step (A)';

  @override
  String get stepTime => 'Step time';

  @override
  String get endCondition => 'End condition';

  @override
  String get voltageDropPercent => 'Voltage drop (%)';

  @override
  String get voltageDropVolt => 'Voltage drop (V)';

  @override
  String get endVoltage => 'End voltage (V)';

  @override
  String get processAndResults => 'Process and results';

  @override
  String get maxPower => 'Max power';

  @override
  String get maxCurrent => 'Max current';

  @override
  String get status => 'Status';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get startCurrentValueIsInvalid => 'Start current value is invalid';

  @override
  String get endCurrentValueIsInvalid => 'End current value is invalid';

  @override
  String get currentStepValueIsInvalid => 'Current step value is invalid';

  @override
  String get voltageDropPercentageIsInvalid =>
      'The voltage drop percentage is invalid';

  @override
  String get voltageDropValueIsInvalid => 'The voltage drop value is invalid';

  @override
  String get endVoltageValueIsInvalid => 'The end voltage value is invalid';

  @override
  String get testing => 'Testing';

  @override
  String get paused => 'Paused';

  @override
  String get stopped => 'Stopped';

  @override
  String get completed => 'Completed';

  @override
  String get waiting => 'Waiting';

  @override
  String get shortCircuitTester => 'Short circuit tester!!!';

  @override
  String get warningThisTestIsVeryDangerous =>
      'Warning: This test is very dangerous!';

  @override
  String get pleaseDoNotTestTheBattery => 'Please do not test the battery.';

  @override
  String get beforeTheTestMakeSureThatThePowerSupplyHasShortCircuitProtection =>
      'Before the test, make sure that the power supply has short circuit protection.';

  @override
  String get onlyForPowerSupplyUnder10V => 'Only for power supply under 10V.';

  @override
  String get shorted => 'Shorted';

  @override
  String get inTheGap => 'In the gap';

  @override
  String get powerSupplyNotConnected => 'Power supply not connected';

  @override
  String get voltageIsTooHigh => 'Voltage is too high';

  @override
  String get numberOfTests => 'Number of tests';

  @override
  String get enterTheNumberOfTests => 'Enter the number of tests';

  @override
  String get shortCircuitTime => 'short circuit time';

  @override
  String get gapTime => 'Gap time';

  @override
  String get current => 'Current';

  @override
  String get testProgress => 'Test progress';

  @override
  String get numberOfTestsIsInvalid => 'Number of tests is invalid';

  @override
  String get nameOfDeviceInvalid => 'Name of device invalid';

  @override
  String yearsLater(String count) {
    return '$count years later';
  }

  @override
  String daysLater(String count) {
    return '$count days later';
  }

  @override
  String hoursLater(String count) {
    return '$count hours later';
  }

  @override
  String minutesLater(String count) {
    return '$count minutes later';
  }

  @override
  String secondsLater(String count) {
    return '$count seconds later';
  }

  @override
  String get justNow => 'just now';

  @override
  String secondsAgo(String count) {
    return '$count seconds ago';
  }

  @override
  String minutesAgo(String count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(String count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(String count) {
    return '$count days ago';
  }

  @override
  String yearsAgo(String count) {
    return '$count years ago';
  }

  @override
  String get unit => 'Unit';

  @override
  String get exportLoadStatsFileSuccess => 'Export load stats file success';

  @override
  String get testMaxCapacity => 'Test max capcity';

  @override
  String get doesNotKeepTheScreenAlwaysOn =>
      'Does not keep the screen always on';

  @override
  String get keepScreenOnWhileTheAppIsRunning =>
      'Keep screen on while the app is running';

  @override
  String get bluetoothPermissionRequired =>
      'Bluetooth permission required to connect device, please re-authorize';

  @override
  String get bluetoothConnectionTimeout =>
      'Bluetooth connection timeout, please check if device is accessible and retry';

  @override
  String get bluetoothConnectionClosed =>
      'Bluetooth connection closed, please reconnect device';

  @override
  String get bluetoothConnectionRefused =>
      'Bluetooth connection refused, please check device status';

  @override
  String get bluetoothDeviceNotFound =>
      'Bluetooth device not found, please check if device is paired';

  @override
  String get bluetoothPermissionDenied =>
      'Bluetooth permission denied, please allow Bluetooth permission in settings';

  @override
  String bluetoothConnectionFailed(String error) {
    return 'Bluetooth connection failed: $error';
  }
}
