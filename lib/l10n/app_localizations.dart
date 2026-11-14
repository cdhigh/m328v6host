import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// End button text
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No item text
  ///
  /// In en, this message translates to:
  /// **'No item'**
  String get noItem;

  /// No data text
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// Items count text
  ///
  /// In en, this message translates to:
  /// **'Items: {count}'**
  String itemsCount(int count);

  /// Choose button text
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// Empty text
  ///
  /// In en, this message translates to:
  /// **'[Empty]'**
  String get empty;

  /// Input new text placeholder
  ///
  /// In en, this message translates to:
  /// **'Input new text'**
  String get inputNewText;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Connection timeout error
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// Timeout error
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// Pick a color text
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get pickAColor;

  /// Date text
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Check for update failed error
  ///
  /// In en, this message translates to:
  /// **'Check for update failed'**
  String get checkForUpdateFailed;

  /// Version up to date message
  ///
  /// In en, this message translates to:
  /// **'Your version is up to date'**
  String get versionUpToDate;

  /// New version available message
  ///
  /// In en, this message translates to:
  /// **'There is a new version ({version}), the download link has been copied to the clipboard'**
  String newVersionAvailable(String version);

  /// Device name invalid error
  ///
  /// In en, this message translates to:
  /// **'Name of device invalid'**
  String get deviceNameInvalid;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// External storage directory text
  ///
  /// In en, this message translates to:
  /// **'External storage directory'**
  String get externalStorageDirectory;

  /// App document directory text
  ///
  /// In en, this message translates to:
  /// **'App document directory'**
  String get appDocumentDirectory;

  /// Prompt text
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get prompt;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// General section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Keep screen on dialog title
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keepScreenOn;

  /// Does not keep screen on option
  ///
  /// In en, this message translates to:
  /// **'Does not keep the screen always on'**
  String get doesNotKeepScreenOn;

  /// Keep screen on during discharge option
  ///
  /// In en, this message translates to:
  /// **'Keep screen on during discharge'**
  String get keepScreenOnDuringDischarge;

  /// Keep screen on while app running option
  ///
  /// In en, this message translates to:
  /// **'Keep screen on while the app is running'**
  String get keepScreenOnWhileAppRunning;

  /// Does not keep on option
  ///
  /// In en, this message translates to:
  /// **'Does not keep on'**
  String get doesNotKeepOn;

  /// During discharging option
  ///
  /// In en, this message translates to:
  /// **'During discharging'**
  String get duringDischarging;

  /// During app running option
  ///
  /// In en, this message translates to:
  /// **'During app running'**
  String get duringAppRunning;

  /// Auto theme option
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Restart required message
  ///
  /// In en, this message translates to:
  /// **'Restart required'**
  String get restartRequired;

  /// Restart required message text
  ///
  /// In en, this message translates to:
  /// **'You need to restart the application to apply the language change'**
  String get restartRequiredMessage;

  /// Theme dialog title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Homepage background color setting
  ///
  /// In en, this message translates to:
  /// **'Homepage background color'**
  String get homepageBackgroundColor;

  /// Blue theme option
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// Green theme option
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// Blue Grey theme option
  ///
  /// In en, this message translates to:
  /// **'Blue Grey'**
  String get blueGrey;

  /// Brown theme option
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// Cyan theme option
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get cyan;

  /// Light Blue theme option
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get lightBlue;

  /// Orange theme option
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// Pink theme option
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// Red theme option
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// Teal theme option
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get teal;

  /// Lime theme option
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get lime;

  /// Unconnected status text
  ///
  /// In en, this message translates to:
  /// **'Unconnected'**
  String get unconnected;

  /// Connected status text
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Disconnect button text
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Connect button text
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Voltage set text
  ///
  /// In en, this message translates to:
  /// **'V Set'**
  String get vSet;

  /// Current set text
  ///
  /// In en, this message translates to:
  /// **'I Set'**
  String get iSet;

  /// Voltage text
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get v;

  /// Current text
  ///
  /// In en, this message translates to:
  /// **'I'**
  String get i;

  /// Power text
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// CR mode text
  ///
  /// In en, this message translates to:
  /// **'CR'**
  String get cr;

  /// CP mode text
  ///
  /// In en, this message translates to:
  /// **'CP'**
  String get cp;

  /// Capacity text
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// Energy text
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// Rd label
  ///
  /// In en, this message translates to:
  /// **'Rd'**
  String get rd;

  /// Ra label
  ///
  /// In en, this message translates to:
  /// **'Ra'**
  String get ra;

  /// Heat sink text
  ///
  /// In en, this message translates to:
  /// **'Heat sink'**
  String get heatSink;

  /// Board label
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get board;

  /// Voltage limit error message
  ///
  /// In en, this message translates to:
  /// **'The voltage must be less than 65 volts'**
  String get voltageMustBeLessThan65Volts;

  /// Current limit error message
  ///
  /// In en, this message translates to:
  /// **'The current must be less than 15A'**
  String get currentMustBeLessThan15A;

  /// Confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Clear Ah menu item
  ///
  /// In en, this message translates to:
  /// **'Clear Ah'**
  String get clearAh;

  /// Clear curva data menu item
  ///
  /// In en, this message translates to:
  /// **'Clear curva data'**
  String get clearCurvaData;

  /// Show load stats menu item
  ///
  /// In en, this message translates to:
  /// **'Show load stats'**
  String get showLoadStats;

  /// Turn on electronic load confirmation message
  ///
  /// In en, this message translates to:
  /// **'Turn on the electronic load?\nRemember to clear Ah, if needed'**
  String get turnOnElectronicLoad;

  /// Turn off electronic load confirmation message
  ///
  /// In en, this message translates to:
  /// **'Turn off the electronic load?'**
  String get turnOffElectronicLoad;

  /// Discharge ended notification message
  ///
  /// In en, this message translates to:
  /// **'Discharge has ended'**
  String get dischargeHasEnded;

  /// Connection page title
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// Available devices text
  ///
  /// In en, this message translates to:
  /// **'Available devices'**
  String get availableDevices;

  /// Baud rate label text
  ///
  /// In en, this message translates to:
  /// **'Baud rate'**
  String get baudRate;

  /// No device available text
  ///
  /// In en, this message translates to:
  /// **'No device'**
  String get noDevice;

  /// Baud rate validation error message
  ///
  /// In en, this message translates to:
  /// **'Baud rate is invalid'**
  String get baudRateIsInvalid;

  /// Device connection failed error message
  ///
  /// In en, this message translates to:
  /// **'Open device failed'**
  String get openDeviceFailed;

  /// Data section title
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Auto reconnect setting title
  ///
  /// In en, this message translates to:
  /// **'Auto reconnect'**
  String get autoReconnect;

  /// Auto reconnect setting description
  ///
  /// In en, this message translates to:
  /// **'Auto reconnect if connection interruption'**
  String get autoReconnectIfConnectionInterruption;

  /// Auto synchronize time setting
  ///
  /// In en, this message translates to:
  /// **'Auto synchronize time'**
  String get autoSynchronizeTime;

  /// Auto synchronize time to load description
  ///
  /// In en, this message translates to:
  /// **'Auto synchronize time to load'**
  String get autoSynchronizeTimeToLoad;

  /// Number of points for smooth curve setting
  ///
  /// In en, this message translates to:
  /// **'Number of points for smooth curve'**
  String get numberOfPointsForSmoothCurve;

  /// Threshold for smooth curve setting
  ///
  /// In en, this message translates to:
  /// **'Threshold for smooth curve'**
  String get thresholdForSmoothCurve;

  /// Curve line start color setting
  ///
  /// In en, this message translates to:
  /// **'Curve line start color'**
  String get curveLineStartColor;

  /// Curve line end color setting
  ///
  /// In en, this message translates to:
  /// **'Curve line end color'**
  String get curveLineEndColor;

  /// Version section title
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Current version setting
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get currentVersion;

  /// Check frequency dialog title
  ///
  /// In en, this message translates to:
  /// **'Check frequency'**
  String get checkFrequency;

  /// Check for update now setting
  ///
  /// In en, this message translates to:
  /// **'Check for update now'**
  String get checkForUpdateNow;

  /// Official site link copied message
  ///
  /// In en, this message translates to:
  /// **'The link of the official site has been copied to the clipboard'**
  String get theLinkOfTheOfficialSiteHasBeenCopiedToTheClipboard;

  /// Number of points dialog title
  ///
  /// In en, this message translates to:
  /// **'Number of points'**
  String get numberOfPoints;

  /// Enter threshold value dialog
  ///
  /// In en, this message translates to:
  /// **'Enter a value from 0.000 to 1.000 (V)'**
  String get enterAValueFrom0000To1000V;

  /// Threshold value validation error
  ///
  /// In en, this message translates to:
  /// **'The value must be greater than 0.000 and less than 1.000'**
  String get theValueMustBeGreaterThan0000AndLessThan1000;

  /// Never check frequency option
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// One week check frequency option
  ///
  /// In en, this message translates to:
  /// **'One week'**
  String get oneWeek;

  /// One month check frequency option
  ///
  /// In en, this message translates to:
  /// **'One month'**
  String get oneMonth;

  /// One year check frequency option
  ///
  /// In en, this message translates to:
  /// **'One year'**
  String get oneYear;

  /// Days check frequency option
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String days(String count);

  /// Found new version dialog title
  ///
  /// In en, this message translates to:
  /// **'Found new version [{version}]'**
  String foundNewVersion(String version);

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Whatsnew label
  ///
  /// In en, this message translates to:
  /// **'Whatsnew:'**
  String get whatsnew;

  /// Download link copied message
  ///
  /// In en, this message translates to:
  /// **'The download link has been copied to the clipboard'**
  String get theDownloadLinkHasBeenCopiedToTheClipboard;

  /// Help page title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Help text for menu access
  ///
  /// In en, this message translates to:
  /// **'Swipe on the left side of the screen to popup the menu'**
  String get swipeOnTheLeftSideOfTheScreenToPopupTheMenu;

  /// Help text for Vset double-click
  ///
  /// In en, this message translates to:
  /// **'Double-click \'Vset\' to set a new value'**
  String get doubleClickVsetToSetANewValue;

  /// Help text for Iset double-click
  ///
  /// In en, this message translates to:
  /// **'Double-click \'Iset\' to set a new value'**
  String get doubleClickIsetToSetANewValue;

  /// Help text for Capacity double-click
  ///
  /// In en, this message translates to:
  /// **'Double-click \'Capacity\' to clear Ah of device'**
  String get doubleClickCapacityToClearAhOfDevice;

  /// Help text for Curva area double-click
  ///
  /// In en, this message translates to:
  /// **'Double-click \'Curva area\' to clear curva data'**
  String get doubleClickCurvaAreaToClearCurvaData;

  /// Switch mode page title
  ///
  /// In en, this message translates to:
  /// **'Switch Mode'**
  String get switchMode;

  /// CC mode option
  ///
  /// In en, this message translates to:
  /// **'CC Mode'**
  String get ccMode;

  /// CR mode option
  ///
  /// In en, this message translates to:
  /// **'CR Mode'**
  String get crMode;

  /// CP mode option
  ///
  /// In en, this message translates to:
  /// **'CP Mode'**
  String get cpMode;

  /// Resistor value input label
  ///
  /// In en, this message translates to:
  /// **'set the resistor value (Ohm)'**
  String get setTheResistorValueOhm;

  /// Power value input label
  ///
  /// In en, this message translates to:
  /// **'set the power value (W)'**
  String get setThePowerValueW;

  /// Set button text
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// Success dialog title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// CC mode set success message
  ///
  /// In en, this message translates to:
  /// **'set CC mode successfully'**
  String get setCcModeSuccessfully;

  /// CR mode set success message
  ///
  /// In en, this message translates to:
  /// **'set CR mode successfully'**
  String get setCrModeSuccessfully;

  /// CP mode set success message
  ///
  /// In en, this message translates to:
  /// **'set CP mode successfully'**
  String get setCpModeSuccessfully;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Resistance validation error message
  ///
  /// In en, this message translates to:
  /// **'Resistance must be greater than zero ohm and less than 655 ohms'**
  String get resistanceMustBeGreaterThanZeroOhmAndLessThan655Ohms;

  /// Power validation error message
  ///
  /// In en, this message translates to:
  /// **'Power must be greater than zero watt and less than 650 watts'**
  String get powerMustBeGreaterThanZeroWattAndLessThan650Watts;

  /// App name in drawer
  ///
  /// In en, this message translates to:
  /// **'M328v6 Electronic Load'**
  String get m328v6ElectronicLoad;

  /// Device info text
  ///
  /// In en, this message translates to:
  /// **'Device : {version} [{buildDate}]'**
  String device(String version, String buildDate);

  /// Disconnect port text
  ///
  /// In en, this message translates to:
  /// **'Disconnect [{port}]'**
  String disconnectPort(String port);

  /// Load on text
  ///
  /// In en, this message translates to:
  /// **'Load On'**
  String get loadOn;

  /// Load Off menu item
  ///
  /// In en, this message translates to:
  /// **'Load Off'**
  String get loadOff;

  /// Device operations section title
  ///
  /// In en, this message translates to:
  /// **'Device Operations'**
  String get deviceOperations;

  /// Other operations section title
  ///
  /// In en, this message translates to:
  /// **'Other Operations'**
  String get otherOperations;

  /// Ra On menu item
  ///
  /// In en, this message translates to:
  /// **'Ra On'**
  String get raOn;

  /// Ra Off menu item
  ///
  /// In en, this message translates to:
  /// **'Ra Off'**
  String get raOff;

  /// Zero Ra menu item
  ///
  /// In en, this message translates to:
  /// **'Zero Ra'**
  String get zeroRa;

  /// Zero I menu item
  ///
  /// In en, this message translates to:
  /// **'Zero I'**
  String get zeroI;

  /// Clear Time menu item
  ///
  /// In en, this message translates to:
  /// **'Clear Time'**
  String get clearTime;

  /// Synchronize Time menu item
  ///
  /// In en, this message translates to:
  /// **'Synchronize Time'**
  String get synchronizeTime;

  /// Turn off Buzzer menu item
  ///
  /// In en, this message translates to:
  /// **'Turn off Buzzer'**
  String get turnOffBuzzer;

  /// Mode menu item
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// Delay/Period On/Off menu item
  ///
  /// In en, this message translates to:
  /// **'Delay/Period On/Off'**
  String get delayPeriodOnOff;

  /// Test max capacity text
  ///
  /// In en, this message translates to:
  /// **'Test max capcity'**
  String get testMaxCapcity;

  /// Test short circuit menu item
  ///
  /// In en, this message translates to:
  /// **'Test short circuit'**
  String get testShortCircuit;

  /// Export menu item
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Export curva data page title
  ///
  /// In en, this message translates to:
  /// **'Export curva data'**
  String get exportCurvaData;

  /// Export type label
  ///
  /// In en, this message translates to:
  /// **'Export type'**
  String get exportType;

  /// XLSX file option
  ///
  /// In en, this message translates to:
  /// **'XLSX file'**
  String get xlsxFile;

  /// TXT file option
  ///
  /// In en, this message translates to:
  /// **'TXT file'**
  String get txtFile;

  /// Export folder label
  ///
  /// In en, this message translates to:
  /// **'Export folder'**
  String get exportFolder;

  /// Select folder placeholder
  ///
  /// In en, this message translates to:
  /// **'Select a folder to save'**
  String get selectAFolderToSave;

  /// File name label
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// Enter name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter a name to save'**
  String get enterANameToSave;

  /// Remark label
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get remark;

  /// Enter remark placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter a remark'**
  String get enterARemark;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Export {type} file success'**
  String exportFileSuccess(String type);

  /// Time column header
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Voltage label
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltage;

  /// Load stats page title
  ///
  /// In en, this message translates to:
  /// **'Load Stats'**
  String get loadStats;

  /// Click to add remark text
  ///
  /// In en, this message translates to:
  /// **'Click to add remark'**
  String get clickToAddRemark;

  /// Input remark dialog title
  ///
  /// In en, this message translates to:
  /// **'Input a remark'**
  String get inputARemark;

  /// Initial voltage text
  ///
  /// In en, this message translates to:
  /// **'Initial V'**
  String get initialV;

  /// End voltage text
  ///
  /// In en, this message translates to:
  /// **'End V'**
  String get endV;

  /// Average voltage text
  ///
  /// In en, this message translates to:
  /// **'Average V'**
  String get averageV;

  /// Initial current text
  ///
  /// In en, this message translates to:
  /// **'Initial I'**
  String get initialI;

  /// End I label
  ///
  /// In en, this message translates to:
  /// **'End I'**
  String get endI;

  /// Average I label
  ///
  /// In en, this message translates to:
  /// **'Average I'**
  String get averageI;

  /// Initial Ah label
  ///
  /// In en, this message translates to:
  /// **'Initial Ah'**
  String get initialAh;

  /// Ah label
  ///
  /// In en, this message translates to:
  /// **'Ah'**
  String get ah;

  /// Total Ah label
  ///
  /// In en, this message translates to:
  /// **'Total Ah'**
  String get totalAh;

  /// Initial Wh label
  ///
  /// In en, this message translates to:
  /// **'Initial Wh'**
  String get initialWh;

  /// Wh label
  ///
  /// In en, this message translates to:
  /// **'Wh'**
  String get wh;

  /// Total Wh label
  ///
  /// In en, this message translates to:
  /// **'Total Wh'**
  String get totalWh;

  /// CR value label
  ///
  /// In en, this message translates to:
  /// **'CR value'**
  String get crValue;

  /// CP value label
  ///
  /// In en, this message translates to:
  /// **'CP value'**
  String get cpValue;

  /// Head sink label
  ///
  /// In en, this message translates to:
  /// **'Head sink'**
  String get headSink;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Export load stats data title
  ///
  /// In en, this message translates to:
  /// **'Export load stats data'**
  String get exportLoadStatsData;

  /// Item column header
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// Value column header
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// Delay&Period page title
  ///
  /// In en, this message translates to:
  /// **'Delay&Period'**
  String get delayPeriod;

  /// Current status section title
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// Delay on text
  ///
  /// In en, this message translates to:
  /// **'Delay on   : {time}'**
  String delayOn(String time);

  /// Delay off text
  ///
  /// In en, this message translates to:
  /// **'Delay off  : {time}'**
  String delayOff(String time);

  /// Period on text
  ///
  /// In en, this message translates to:
  /// **'Period on  : {time}'**
  String periodOn(String time);

  /// Period off text
  ///
  /// In en, this message translates to:
  /// **'Period off : {time}'**
  String periodOff(String time);

  /// Set delay on section title
  ///
  /// In en, this message translates to:
  /// **'set Delay on'**
  String get setDelayOn;

  /// Set delay off section title
  ///
  /// In en, this message translates to:
  /// **'set Delay off'**
  String get setDelayOff;

  /// Set period on/off section title
  ///
  /// In en, this message translates to:
  /// **'set Period On/Off'**
  String get setPeriodOnOff;

  /// On time label
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// Off time label
  ///
  /// In en, this message translates to:
  /// **'Off time'**
  String get offTime;

  /// Time validation error message
  ///
  /// In en, this message translates to:
  /// **'Time must be less than 18 hours'**
  String get timeMustBeLessThan18Hours;

  /// Set delay on success message
  ///
  /// In en, this message translates to:
  /// **'set Delay On successfully'**
  String get setDelayOnSuccessfully;

  /// Set delay off success message
  ///
  /// In en, this message translates to:
  /// **'set Delay Off successfully'**
  String get setDelayOffSuccessfully;

  /// Set period on/off success message
  ///
  /// In en, this message translates to:
  /// **'set Period On/Off successfully'**
  String get setPeriodOnOffSuccessfully;

  /// Test PSU max capacity page title
  ///
  /// In en, this message translates to:
  /// **'Test PSU max capacity'**
  String get testPsuMaxCapacity;

  /// Parameters section title
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get parameters;

  /// Start test current label
  ///
  /// In en, this message translates to:
  /// **'Start test current (A)'**
  String get startTestCurrent;

  /// End test current label
  ///
  /// In en, this message translates to:
  /// **'End test current (A)'**
  String get endTestCurrent;

  /// Current step label
  ///
  /// In en, this message translates to:
  /// **'Current step (A)'**
  String get currentStep;

  /// Step time label
  ///
  /// In en, this message translates to:
  /// **'Step time'**
  String get stepTime;

  /// End condition label
  ///
  /// In en, this message translates to:
  /// **'End condition'**
  String get endCondition;

  /// Voltage drop percentage option
  ///
  /// In en, this message translates to:
  /// **'Voltage drop (%)'**
  String get voltageDropPercent;

  /// Voltage drop voltage option
  ///
  /// In en, this message translates to:
  /// **'Voltage drop (V)'**
  String get voltageDropVolt;

  /// End voltage option
  ///
  /// In en, this message translates to:
  /// **'End voltage (V)'**
  String get endVoltage;

  /// Process and results section title
  ///
  /// In en, this message translates to:
  /// **'Process and results'**
  String get processAndResults;

  /// Max power label
  ///
  /// In en, this message translates to:
  /// **'Max power'**
  String get maxPower;

  /// Max current label
  ///
  /// In en, this message translates to:
  /// **'Max current'**
  String get maxCurrent;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Resume button text
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Pause button text
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Stop button text
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Start current validation error
  ///
  /// In en, this message translates to:
  /// **'Start current value is invalid'**
  String get startCurrentValueIsInvalid;

  /// End current validation error
  ///
  /// In en, this message translates to:
  /// **'End current value is invalid'**
  String get endCurrentValueIsInvalid;

  /// Current step validation error
  ///
  /// In en, this message translates to:
  /// **'Current step value is invalid'**
  String get currentStepValueIsInvalid;

  /// Voltage drop percentage validation error
  ///
  /// In en, this message translates to:
  /// **'The voltage drop percentage is invalid'**
  String get voltageDropPercentageIsInvalid;

  /// Voltage drop value validation error
  ///
  /// In en, this message translates to:
  /// **'The voltage drop value is invalid'**
  String get voltageDropValueIsInvalid;

  /// End voltage value validation error
  ///
  /// In en, this message translates to:
  /// **'The end voltage value is invalid'**
  String get endVoltageValueIsInvalid;

  /// Testing status
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get testing;

  /// Paused status
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Stopped status
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Waiting status
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// Short circuit tester page title
  ///
  /// In en, this message translates to:
  /// **'Short circuit tester!!!'**
  String get shortCircuitTester;

  /// Warning message about dangerous test
  ///
  /// In en, this message translates to:
  /// **'Warning: This test is very dangerous!'**
  String get warningThisTestIsVeryDangerous;

  /// Warning about not testing battery
  ///
  /// In en, this message translates to:
  /// **'Please do not test the battery.'**
  String get pleaseDoNotTestTheBattery;

  /// Warning about power supply protection
  ///
  /// In en, this message translates to:
  /// **'Before the test, make sure that the power supply has short circuit protection.'**
  String get beforeTheTestMakeSureThatThePowerSupplyHasShortCircuitProtection;

  /// Warning about voltage limit
  ///
  /// In en, this message translates to:
  /// **'Only for power supply under 10V.'**
  String get onlyForPowerSupplyUnder10V;

  /// Shorted status
  ///
  /// In en, this message translates to:
  /// **'Shorted'**
  String get shorted;

  /// In the gap status
  ///
  /// In en, this message translates to:
  /// **'In the gap'**
  String get inTheGap;

  /// Power supply not connected status
  ///
  /// In en, this message translates to:
  /// **'Power supply not connected'**
  String get powerSupplyNotConnected;

  /// Voltage too high status
  ///
  /// In en, this message translates to:
  /// **'Voltage is too high'**
  String get voltageIsTooHigh;

  /// Number of tests label
  ///
  /// In en, this message translates to:
  /// **'Number of tests'**
  String get numberOfTests;

  /// Enter number of tests placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter the number of tests'**
  String get enterTheNumberOfTests;

  /// Short circuit time label
  ///
  /// In en, this message translates to:
  /// **'short circuit time'**
  String get shortCircuitTime;

  /// Gap time label
  ///
  /// In en, this message translates to:
  /// **'Gap time'**
  String get gapTime;

  /// Current label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Test progress label
  ///
  /// In en, this message translates to:
  /// **'Test progress'**
  String get testProgress;

  /// Number of tests validation error
  ///
  /// In en, this message translates to:
  /// **'Number of tests is invalid'**
  String get numberOfTestsIsInvalid;

  /// Device name validation error
  ///
  /// In en, this message translates to:
  /// **'Name of device invalid'**
  String get nameOfDeviceInvalid;

  /// Years later time format
  ///
  /// In en, this message translates to:
  /// **'{count} years later'**
  String yearsLater(String count);

  /// Days later time format
  ///
  /// In en, this message translates to:
  /// **'{count} days later'**
  String daysLater(String count);

  /// Hours later time format
  ///
  /// In en, this message translates to:
  /// **'{count} hours later'**
  String hoursLater(String count);

  /// Minutes later time format
  ///
  /// In en, this message translates to:
  /// **'{count} minutes later'**
  String minutesLater(String count);

  /// Seconds later time format
  ///
  /// In en, this message translates to:
  /// **'{count} seconds later'**
  String secondsLater(String count);

  /// Just now time format
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// Seconds ago time format
  ///
  /// In en, this message translates to:
  /// **'{count} seconds ago'**
  String secondsAgo(String count);

  /// Minutes ago time format
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(String count);

  /// Hours ago time format
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(String count);

  /// Days ago time format
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(String count);

  /// Years ago time format
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(String count);

  /// Unit column header
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Export load stats file success'**
  String get exportLoadStatsFileSuccess;

  /// Test max capacity menu item
  ///
  /// In en, this message translates to:
  /// **'Test max capcity'**
  String get testMaxCapacity;

  /// Does not keep screen on option
  ///
  /// In en, this message translates to:
  /// **'Does not keep the screen always on'**
  String get doesNotKeepTheScreenAlwaysOn;

  /// Keep screen on while app running option
  ///
  /// In en, this message translates to:
  /// **'Keep screen on while the app is running'**
  String get keepScreenOnWhileTheAppIsRunning;

  /// Bluetooth permission required message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission required to connect device, please re-authorize'**
  String get bluetoothPermissionRequired;

  /// Bluetooth connection timeout error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection timeout, please check if device is accessible and retry'**
  String get bluetoothConnectionTimeout;

  /// Bluetooth connection closed error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection closed, please reconnect device'**
  String get bluetoothConnectionClosed;

  /// Bluetooth connection refused error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection refused, please check device status'**
  String get bluetoothConnectionRefused;

  /// Bluetooth device not found error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth device not found, please check if device is paired'**
  String get bluetoothDeviceNotFound;

  /// Bluetooth permission denied error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission denied, please allow Bluetooth permission in settings'**
  String get bluetoothPermissionDenied;

  /// Bluetooth connection failed error message
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection failed: {error}'**
  String bluetoothConnectionFailed(String error);

  /// Simulated terminal menu item
  ///
  /// In en, this message translates to:
  /// **'Simulated Terminal'**
  String get simulatedTerminal;

  /// Terminal page title
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminal;

  /// Display mode label
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get displayMode;

  /// Decimal display mode
  ///
  /// In en, this message translates to:
  /// **'Decimal'**
  String get decimal;

  /// Hexadecimal display mode
  ///
  /// In en, this message translates to:
  /// **'Hexadecimal'**
  String get hexadecimal;

  /// Terminal output label
  ///
  /// In en, this message translates to:
  /// **'Terminal Output'**
  String get terminalOutput;

  /// No data received message
  ///
  /// In en, this message translates to:
  /// **'No data received'**
  String get noDataReceived;

  /// Clear terminal button text
  ///
  /// In en, this message translates to:
  /// **'Clear Terminal'**
  String get clearTerminal;

  /// Terminal paused status message
  ///
  /// In en, this message translates to:
  /// **'Terminal Paused'**
  String get terminalPaused;

  /// Terminal resumed status message
  ///
  /// In en, this message translates to:
  /// **'Terminal Resumed'**
  String get terminalResumed;

  /// Message shown when exporting a file fails
  ///
  /// In en, this message translates to:
  /// **'Export file failed, please check the path and storage permission'**
  String get exportFileFailed;

  /// Message shown when the entered time text cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Invalid time format, please enter a time between 00:00:00 and 23:59:59'**
  String get timeFormatIsInvalid;

  /// Warning shown when the serial connection is lost while the short-circuit test is running
  ///
  /// In en, this message translates to:
  /// **'Connection lost during the test! The device MOS may still be forced. Please check the device manually after reconnecting'**
  String get connectionLostDuringTest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
