/// m328v6数控电子负载上位机
/// 主界面侧滑弹出菜单
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../i18n/main_drawer.i18n.dart';
import '../common/globals.dart';
import '../common/event_bus.dart';
import '../models/connection_provider.dart';
import '../models/running_data_provider.dart';
import '../common/iconfont.dart';

///侧滑菜单Widget
class MainDrawer extends ConsumerWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final _controller = ScrollController();
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
          portName = portName.substring(0, iStart);
        }
      }
    }

    final portConnected = (portName != "");

    return SingleChildScrollView(controller: _controller,
        child: Column(children: <Widget>[
          UserAccountsDrawerHeader(accountName: Text("M328v6 Electronic Load".i18n + 
            (Global.version != "" ? " V" + Global.version : "")),
            accountEmail: Text((!portConnected) ? "Unconnected".i18n :
              rdProvider.ver != "" ? "Device : %s [%s]".i18n.fill([rdProvider.ver, rdProvider.buildDate]) : "Connected".i18n),
            currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/drawer_header.jpg"),
            ),
            otherAccountsPictures: const <Widget>[
              Icon(Icons.bluetooth_outlined, color: Colors.white54), 
              Icon(Icons.usb_outlined, color: Colors.white54),
              Icon(IconFont.serialPort, color: Colors.white54)],
          ),
          Column(children: [
            if (!portConnected) ListTile(leading: const Icon(Icons.bluetooth),
              title: Text("Connect".i18n),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                Navigator.pushNamed(context, "/connection");
              },
            ),
            if (portConnected) ListTile(leading: const Icon(Icons.bluetooth_disabled),
              title: Text("Disconnect [%s]".i18n.fill([portName])),
              onTap: () {
                Global.bus.sendBroadcast(EventBus.connectionChanged, arg: "0", sendAsync: false);
                Navigator.of(context).pop(); //关闭drawer
              },
            ),
            if (topLoadMenu) const Divider(),
            if (topLoadMenu) ListTile(title: Text("Load On".i18n),
              leading: const Icon(Icons.power),
              enabled: portConnected,
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                connProvider.load.setLoadOn(true);
              },
            ),
            if (topLoadMenu) ListTile(title: Text("Load Off".i18n),
              leading: const Icon(Icons.power_off),
              enabled: portConnected,
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                connProvider.load.setLoadOn(false);
              },
            ),
            ExpansionTile(title: Text("Other Operations".i18n), 
              leading: const Icon(Icons.account_tree),
              children: <Widget>[MainDrawerOperations(topLoadMenu: topLoadMenu)]),
            const Divider(),
            ListTile(title: Text("Settings".i18n),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop(); //关闭drawer
                Navigator.of(context).pushNamed('/settings');
              },
            ),
            ListTile(title: Text("Help".i18n),
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
class MainDrawerOperations extends ConsumerWidget {
  final bool topLoadMenu; //Load On/Load Off菜单是否置于顶层
  const MainDrawerOperations({Key? key, required this.topLoadMenu}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    final load = connProvider.load;
    String portName = connProvider.name;
    bool loadMenuEnabled = (portName != "");

    return Column(
      children: <Widget>[
        if (!topLoadMenu) ListTile(title: Text("Load On".i18n),
          //leading: const Icon(Icons.power),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setLoadOn(true);
          },
        ),
        if (!topLoadMenu) ListTile(title: Text("Load Off".i18n),
          //leading: const Icon(Icons.power_off),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setLoadOn(false);
          },
        ),
        ListTile(title: Text("Clear Ah".i18n),
          //leading: const Icon(Icons.battery_unknown),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.clearAh();
          },
        ),
        ListTile(title: Text("Ra On".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setRaOn(true);
          },
        ),
        ListTile(title: Text("Ra Off".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setRaOn(false);
          },
        ),
        ListTile(title: Text("Zero Ra".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.zeroRa();
          },
        ),
        ListTile(title: Text("Zero I".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.zeroI();
          },
        ),
        ListTile(title: Text("Clear Time".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.clearTime();
          },
        ),
        ListTile(title: Text("Turn off Buzzer".i18n),
          enabled: loadMenuEnabled,
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            load.setBuzzerTime(0);
          },
        ),
        ListTile(title: Text("Mode".i18n),
          enabled: loadMenuEnabled,
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop(); //关闭drawer
            Navigator.pushNamed(context, "/mode");
          },
        ),
        //const Divider(),
        ListTile(title: Text("Delay/Period On/Off".i18n),
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
