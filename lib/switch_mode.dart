/// m328v6数控电子负载上位机
/// 切换CC/CR/CP模式
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'i18n/switch_mode.i18n.dart';
import 'common/globals.dart';
import 'widgets/modal_dialogs.dart';
import 'models/running_data_provider.dart';
import 'models/connection_provider.dart';

class SwitchModePage extends ConsumerStatefulWidget {
  const SwitchModePage({Key? key}) : super(key: key);
  @override
  _SwitchModePageState createState() => _SwitchModePageState();
}

class _SwitchModePageState extends ConsumerState<SwitchModePage> {
  final _modeParamctrller = TextEditingController();
  late String _modeStr;
  late bool isCR, isCP;
  
  @override
  void initState() {
    super.initState();

    final rdProvider = ref.watch<RunningDataProvider>(Global.runningDataProvider);
    _modeStr = rdProvider.mode;
    isCR = (_modeStr == "CR");
    isCP = (_modeStr == "CP");

    if (isCR) {
      _modeParamctrller.text = rdProvider.rSet.toString();
    } else if (isCP) {
      _modeParamctrller.text = rdProvider.pSet.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Switch Mode'.i18n)),
      body: buildMainList(context),
    );
  }

  ///构建页面主体的ListView
  Widget buildMainList(BuildContext context) {
    isCR = (_modeStr == "CR");
    isCP = (_modeStr == "CP");
    
    return Container(padding: const EdgeInsets.all(10), child:
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton(value: _modeStr, 
            isExpanded: true,
            items: [
              DropdownMenuItem(value: "CC", child: Text("CC Mode".i18n)),
              DropdownMenuItem(value: "CR", child: Text("CR Mode".i18n)),
              DropdownMenuItem(value: "CP", child: Text("CP Mode".i18n)),],
            onChanged: (newValue) {setState(() {
              _modeStr = newValue.toString();
              _modeParamctrller.text = "";
              });},),
          TextField(controller: _modeParamctrller,
            enabled: isCR || isCP,
            //keyboardType: TextInputType.number,
            onTap: () {},
            decoration: InputDecoration(
              labelText: isCR ? "set the resistor value (Ohm)".i18n 
                : (isCP ? "set the power value (W)".i18n : ""),
              prefixIcon: isCR ? const Icon(Icons.dynamic_form_outlined) 
                : (isCP ? const Icon(Icons.battery_charging_full) : null),
            ),),
          Padding(padding: const EdgeInsets.all(20), child: 
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: () => setNewMode(context), 
                child: Text("Set".i18n)),
            ),),
      ]),);
  }

  ///设置新的模式
  void setNewMode(BuildContext context) async {
    final load = ref.watch<ConnectionProvider>(Global.connectionProvider).load;
    
    if (_modeStr == "CC") {
      load.switchToCC();
      await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set CC mode successfully".i18n));
    } else if (_modeStr == "CR") {
      double? resistor = double.tryParse(_modeParamctrller.text);
      if ((resistor != null) && (resistor > 0.0) && (resistor < 65.535)) {
        load.switchToCR(resistor);
        await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set CR mode successfully".i18n));
      } else {
        await showOkAlertDialog(context: context, title: "Error".i18n, content: Text("Resistor value is invalid".i18n));
      }
    } else if (_modeStr == "CP") {
      double? power = double.tryParse(_modeParamctrller.text);
      if ((power != null) && (power > 0.0) && (power < 6553)) {
        load.switchToCP(power);
        await showOkAlertDialog(context: context, title: "Success".i18n, content: Text("set CP mode successfully".i18n));
      } else {
        await showOkAlertDialog(context: context, title: "Error".i18n, content: Text("Power value is invalid".i18n));
      }
    }
  }
}
