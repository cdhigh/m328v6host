/// m328v6数控电子负载上位机
/// 切换CC/CR/CP模式
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'common/globals.dart';
import 'widgets/modal_dialogs.dart';
import 'models/running_data_provider.dart';
import 'models/connection_provider.dart';

class SwitchModePage extends ConsumerStatefulWidget {
  const SwitchModePage({super.key});
  @override
  _SwitchModePageState createState() => _SwitchModePageState();
}

class _SwitchModePageState extends ConsumerState<SwitchModePage> {
  final _modeParamctrller = TextEditingController();
  String _modeStr = "CC";
  bool isCR = false, isCP = false;
  
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final rdProvider = ref.read<RunningDataProvider>(Global.runningDataProvider);
      final currentMode = rdProvider.mode;
      _modeStr = const ["CC", "CR", "CP"].contains(currentMode) ? currentMode : "CC";
      isCR = (_modeStr == "CR");
      isCP = (_modeStr == "CP");
      if (isCR) {
        _modeParamctrller.text = rdProvider.rSet.toStringAsFixed(2);
      } else if (isCP) {
        _modeParamctrller.text = rdProvider.pSet.toStringAsFixed(2);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _modeParamctrller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.switchMode)),
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
          SizedBox(width: 300, child: DropdownButton(value: _modeStr, 
            isExpanded: true,
            items: [
              DropdownMenuItem(value: "CC", child: Text(AppLocalizations.of(context)!.ccMode)),
              DropdownMenuItem(value: "CR", child: Text(AppLocalizations.of(context)!.crMode)),
              DropdownMenuItem(value: "CP", child: Text(AppLocalizations.of(context)!.cpMode)),],
            onChanged: (newValue) {setState(() {
              _modeStr = newValue.toString();
              _modeParamctrller.text = "";
          });},),),
          SizedBox(width: 300, child: TextField(controller: _modeParamctrller,
            enabled: isCR || isCP,
            keyboardType: TextInputType.number,
            onTap: () {},
            decoration: InputDecoration(
              labelText: isCR ? AppLocalizations.of(context)!.setTheResistorValueOhm 
                : (isCP ? AppLocalizations.of(context)!.setThePowerValueW : ""),
              prefixIcon: isCR ? const Icon(Icons.dynamic_form_outlined) 
                : (isCP ? const Icon(Icons.battery_charging_full) : null),
          ),),),
          Padding(padding: const EdgeInsets.all(20), child: 
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              child: ElevatedButton(
                onPressed: () => setNewMode(context), 
                child: Text(AppLocalizations.of(context)!.set)),
            ),),
      ]),);
  }

  ///设置新的模式
  void setNewMode(BuildContext context) async {
    final load = ref.read<ConnectionProvider>(Global.connectionProvider).load;
    
    if (_modeStr == "CC") {
      load.switchToCC();
      await showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.success, content: Text(AppLocalizations.of(context)!.setCcModeSuccessfully));
    } else if (_modeStr == "CR") {
      double? resistor = double.tryParse(_modeParamctrller.text);
      if ((resistor != null) && (resistor > 0.0) && (resistor < 655.0)) {
        load.switchToCR(resistor);
        await showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.success, content: Text(AppLocalizations.of(context)!.setCrModeSuccessfully));
      } else {
        await showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.error, content: Text(AppLocalizations.of(context)!.resistanceMustBeGreaterThanZeroOhmAndLessThan655Ohms));
      }
    } else if (_modeStr == "CP") {
      double? power = double.tryParse(_modeParamctrller.text);
      if ((power != null) && (power > 0.0) && (power < 650.0)) {
        load.switchToCP(power);
        await showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.success, content: Text(AppLocalizations.of(context)!.setCpModeSuccessfully));
      } else {
        await showOkAlertDialog(context: context, title: AppLocalizations.of(context)!.error, content: Text(AppLocalizations.of(context)!.powerMustBeGreaterThanZeroWattAndLessThan650Watts));
      }
    }
  }
}
