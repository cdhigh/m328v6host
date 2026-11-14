/// m328v6数控电子负载上位机
/// 主界面侧滑弹出菜单
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../common/globals.dart';
import '../common/event_bus.dart';
import '../models/connection_provider.dart';
import '../models/running_data_provider.dart';
import '../common/iconfont.dart';

///侧滑菜单Widget
class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    final serial = connProvider.serial;
    var portName = connProvider.name;
    final portType = serial.getPortType(portName);
    var topLoadMenu = false;  //手机版本横屏时没有AppBar，所以将打开/关闭放电开关移出来方便使用
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      topLoadMenu = (orientation == Orientation.landscape);

      if (portType == "BLUETOOTH") { //蓝牙模块的名字后附加了MAC地址，这里去掉，短一些好看
        final iStart = portName.indexOf("[");
        //final iEnd = portName.indexOf("]");
        if (iStart >= 0) {
          portName = portName.substring(0, iStart).trim();
        }
      }
    }

    final portConnected = (portName != "");

    return SingleChildScrollView(
        child: Column(children: <Widget>[
          UserAccountsDrawerHeader(accountName: Text(AppLocalizations.of(context)!.m328v6ElectronicLoad + 
            (Global.version != "" ? " V${Global.version}" : "")),
            accountEmail: Text((!portConnected) ? AppLocalizations.of(context)!.unconnected :
              rdProvider.ver != "" ? AppLocalizations.of(context)!.device(rdProvider.ver, rdProvider.buildDate) : AppLocalizations.of(context)!.connected),
            currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/drawer_header.jpg"),
            ),
            otherAccountsPictures: const <Widget>[
              Icon(Icons.bluetooth_outlined, color: Colors.white54), 
              Icon(Icons.usb_outlined, color: Colors.white54),
              Icon(IconFont.serialPort, color: Colors.white54)],
          ),
          Column(children: [
            if (!portConnected) ListTile(leading: const Icon(IconFont.connect),
              title: Text(AppLocalizations.of(context)!.connect),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                Navigator.pushNamed(context, "/connection");
              },
            ),
            if (portConnected) ListTile(leading: const Icon(IconFont.disconnect),
              title: Text(AppLocalizations.of(context)!.disconnectPort(portName)),
              onTap: () {
                Global.bus.sendBroadcast(EventBus.connectionChanged, arg: "0", sendAsync: false);
                Navigator.of(context).pop(); //关闭drawer
              },
            ),
            if (topLoadMenu) const Divider(),
            if (topLoadMenu) ListTile(title: Text(AppLocalizations.of(context)!.loadOn),
              leading: const Icon(Icons.power),
              enabled: portConnected,
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                connProvider.load.setLoadOn(true);
              },
            ),
            if (topLoadMenu) ListTile(title: Text(AppLocalizations.of(context)!.loadOff),
              leading: const Icon(Icons.power_off),
              enabled: portConnected,
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                connProvider.load.setLoadOn(false);
              },
            ),
            ExpansionTile(title: Text(AppLocalizations.of(context)!.deviceOperations), 
              leading: const Icon(IconFont.device3),
              children: <Widget>[MainDrawerDeviceOperations(topLoadMenu: topLoadMenu)]),
            ExpansionTile(title: Text(AppLocalizations.of(context)!.otherOperations), 
              leading: const Icon(Icons.account_tree),
              children: const <Widget>[MainDrawerOtherOperations()]),
            const Divider(),
            ListTile(title: Text(AppLocalizations.of(context)!.settings),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                Navigator.of(context).pushNamed('/settings');
              },
            ),
            ListTile(title: Text(AppLocalizations.of(context)!.help),
              leading: const Icon(Icons.help),
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                Navigator.of(context).pushNamed('/help');
              },
            ),
          ]),
      ])
    );
  }
}

///侧滑菜单-针对下位机的操作列表
class MainDrawerDeviceOperations extends ConsumerWidget {
  final bool topLoadMenu; //Load On/Load Off菜单是否置于顶层
  const MainDrawerDeviceOperations({super.key, required this.topLoadMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    final load = connProvider.load;
    String portName = connProvider.name;
    bool loadMenuEnabled = (portName != "");

    return Column(
      children: <Widget>[
        if (!topLoadMenu) ListTile(title: Text(AppLocalizations.of(context)!.loadOn),
          //leading: const Icon(Icons.power),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setLoadOn(true);
          },
        ),
        if (!topLoadMenu) ListTile(title: Text(AppLocalizations.of(context)!.loadOff),
          //leading: const Icon(Icons.power_off),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setLoadOn(false);
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.clearAh),
          //leading: const Icon(Icons.battery_unknown),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.clearAh();
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.raOn),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setRaOn(true);
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.raOff),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setRaOn(false);
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.zeroRa),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.zeroRa();
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.zeroI),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.zeroI();
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.clearTime),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.clearTime();
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.synchronizeTime),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.synchronizeTime();
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.turnOffBuzzer),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setBuzzerTime(0);
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.mode),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/mode");
          },
        ),
        //const Divider(),
        ListTile(title: Text(AppLocalizations.of(context)!.delayPeriodOnOff),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/delay_period_on_off");
          },
        ),
      ],
    );
  }
}


///侧滑菜单-其他操作列表
class MainDrawerOtherOperations extends ConsumerWidget {
  const MainDrawerOtherOperations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    bool loadMenuEnabled = (connProvider.name != "");
    
    return Column(
      children: <Widget>[
        ListTile(title: Text(AppLocalizations.of(context)!.testMaxCapacity),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/max_i_tester");
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.testShortCircuit),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/sc_tester");
          },
        ),
        ListTile(title: Text(AppLocalizations.of(context)!.simulatedTerminal),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/terminal");
          },
        ),
        const Divider(),
        ListTile(title: Text(AppLocalizations.of(context)!.export),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/export");
          },
        ),
      ],
    );
  }
}