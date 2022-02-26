/// 事件总线，实现单例模式的订阅者模式，一个页面可以广播信息给其他订阅的页面
/// Author: cdhigh <https://github.com/cdhigh>
/// 使用方法：
/// 1. 定义一个top-level变量 bus
/// 2. 在 initState() 中添加监听，监听函数建议使用mounted先做判断再更新状态
///    bus.addListener(EventBus.connectionChanged, (arg){if (mounted) setState((){})});
/// 3. 在 dispose() 移除监听
///    bus.removeListener(EventBus.connectionChanged, func);
/// 4. 其他页面发送广播
///    bus.sendBroadcast(EventBus.connectionChanged, arg: "额外信息");
import 'package:flutter/material.dart';

///订阅者回调函数签名
typedef EventCallback = void Function(String arg);

class EventBus {
  //广播的类型，其他函数调用不要直接使用字符串，要使用这些常量，避免字符串输入错误时编译器无法提取报告错误
  static const connectionChanged = 'connectionChanged';
  static const curvaFilterDotNumChanged = "curvaFilterDotNumChanged";
  static const serialDataReceived = "serialDataReceived";
  static const setLoadOnOff = "setLoadOnOff";
  
  EventBus._internal(); //私有构造函数
  static final EventBus _singleton = EventBus._internal();
  factory EventBus() => _singleton;

  //保存事件订阅者队列
  //key: 事件名， value: 对应事件的订阅者列表
  final _emap = <String, List<EventCallback>>{};

  ///添加订阅者，如果调用方使用匿名函数的话，可以保存此函数的返回值用于之后remove
  EventCallback addListener(String eventName, EventCallback f) {
    assert (eventName != "");
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]?.add(f);
    return f;
  }

  ///移除订阅者，
  ///暂时禁止此功能，避免误用[如果f为空，则删除对应名字的所有订阅者]
  void removeListener(String eventName, EventCallback f) {
    assert (eventName != "");
    var list = _emap[eventName];
    if ((list == null) || list.isEmpty) {
      return;
    }
    list.remove(f);
  }

  ///触发事件，触发后该事件的所有订阅者都会被调用
  ///sendAsync: 标识调用回调函数是同步调用还是异步调用
  void sendBroadcast(String eventName, {String arg = "", bool sendAsync=true}) async {
    var list = _emap[eventName];
    if ((list == null) || list.isEmpty) {
      return;
    }

    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    if (sendAsync) { //异步方式
      return Future(() {
        for (var i = len; i > -1; --i) {
          list[i](arg);
        }
      }).catchError((e){debugPrint(e.toString()); return null;});
    } else {
      for (var i = len; i > -1; --i) {
        list[i](arg);
      }
    }
  }
}

///定义一个top-level变量，页面引入该文件后可以直接使用 bus
//final bus = EventBus();
