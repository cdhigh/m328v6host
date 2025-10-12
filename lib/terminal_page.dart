/// m328v6数控电子负载上位机
/// 模拟终端页面
/// Author: cdhigh <https://github.com/cdhigh>
/// 
library;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'common/globals.dart';
import 'models/connection_provider.dart';
import 'widgets/colored_safe_area.dart';

class TerminalPage extends ConsumerStatefulWidget {
  const TerminalPage({super.key});

  @override
  _TerminalPageState createState() => _TerminalPageState();
}

class _TerminalPageState extends ConsumerState<TerminalPage> {
  final List<String> _terminalLines = [];
  final ScrollController _scrollController = ScrollController();
  bool _isHexMode = false;
  bool _isPaused = false;
  StreamSubscription? _serialSubscription;
  static const int _maxLines = 500;

  @override
  void initState() {
    super.initState();
    _setupSerialListener();
  }

  @override
  void dispose() {
    _serialSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupSerialListener() {
    final connProvider = ref.read<ConnectionProvider>(Global.connectionProvider);
    if (connProvider.name.isNotEmpty) {
      // 注册串口数据监听
      connProvider.serial.registerListenFunction(_onSerialDataReceived);
    }
  }

  void _onSerialDataReceived(Uint8List data) {
    if (!mounted || _isPaused) return;

    setState(() {
      final timestamp = DateTime.now().toString().substring(11, 23); // 获取时分秒毫秒
      final dataStr = _isHexMode ? _bytesToHex(data) : String.fromCharCodes(data);
      final line = '[$timestamp] $dataStr';
      
      _terminalLines.add(line);
      
      // 限制最大行数
      if (_terminalLines.length > _maxLines) {
        _terminalLines.removeAt(0);
      }
    });

    // 自动滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');
  }

  void _clearTerminal() {
    setState(() {
      _terminalLines.clear();
    });
  }

  void _toggleDisplayMode() {
    setState(() {
      _isHexMode = !_isHexMode;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    
    // 显示状态提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPaused 
          ? AppLocalizations.of(context)!.terminalPaused 
          : AppLocalizations.of(context)!.terminalResumed),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connProvider = ref.watch<ConnectionProvider>(Global.connectionProvider);
    final isConnected = connProvider.name.isNotEmpty;

    return ColoredSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.terminal),
          actions: [
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: isConnected ? _togglePause : null,
              tooltip: _isPaused 
                ? AppLocalizations.of(context)!.resume 
                : AppLocalizations.of(context)!.pause,
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _clearTerminal,
              tooltip: AppLocalizations.of(context)!.clearTerminal,
            ),
          ],
        ),
        body: Column(
          children: [
            // 控制面板
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.displayMode,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: _isHexMode,
                    onChanged: isConnected ? (_) => _toggleDisplayMode() : null,
                    activeThumbColor: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isHexMode 
                      ? AppLocalizations.of(context)!.hexadecimal 
                      : AppLocalizations.of(context)!.decimal,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  if (_isPaused)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.pause,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isConnected ? AppLocalizations.of(context)!.connected : AppLocalizations.of(context)!.unconnected,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 终端输出区域
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: _terminalLines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isPaused ? Icons.pause_circle_outline : Icons.terminal,
                              size: 64,
                              color: _isPaused ? Colors.orange[400] : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isPaused 
                                ? AppLocalizations.of(context)!.terminalPaused
                                : AppLocalizations.of(context)!.noDataReceived,
                              style: TextStyle(
                                fontSize: 16,
                                color: _isPaused ? Colors.orange[600] : Colors.grey[600],
                              ),
                            ),
                            if (!isConnected) ...[
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.unconnected,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _terminalLines.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                            child: SelectableText(
                              _terminalLines[index],
                              style: const TextStyle(
                                fontFamily: 'CourierPrime',
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
