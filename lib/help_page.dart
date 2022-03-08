/// m328v6数控电子负载上位机
/// 帮助页面ui实现
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/my_widget_chain.dart';
import 'i18n/help.i18n.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  //所有的简单的帮助信息都写在这里
  final _helpText = <String>[
    "Swipe on the left side of the screen to popup the menu".i18n,
    "Double-click 'Vset' to set a new value".i18n,
    "Double-click 'Iset' to set a new value".i18n,
    "Double-click 'Capacity' to clear Ah of device".i18n,
    "Double-click 'Curva area' to clear curva data".i18n,
  ];
  
  //所有需要带链接的帮助信息都放在这里
  final List<Map<String, String>> _linkText = [
    {"title": "M328V6 App源码仓库", "link": "https://github.com/cdhigh/m328v6host"},
    {"title": "M8V6电子负载升级版M328V6(12864版本)发布", "link": "https://www.yleee.com.cn/thread-90734-1-1.html"},
    {"title": "M328V6电子负载开工", "link": "https://www.yleee.com.cn/thread-90686-1-1.html"},
    {"title": "M8电子负载及交流内阻测试仪V6", "link": "https://www.yleee.com.cn/thread-6795-1-2.html"},
    {"title": "M8电子负载及交流内阻测试仪", "link": "https://www.yleee.com.cn/thread-1603-1-1.html"},
    {"title": "M8电子负载实现四线测量", "link": "https://www.yleee.com.cn/thread-29978-1-1.html"},
    {"title": "M8V6负载之电压零点补偿", "link": "https://www.yleee.com.cn/thread-56373-1-1.html"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help'.i18n)),
      body: buildMainView(context),
    );
  }

  ///页面主体
  Widget buildMainView(BuildContext context) {
    return Container(padding: const EdgeInsets.all(5), child: ListView.separated(
      separatorBuilder: (BuildContext context, int index) {return const Divider(height: 1,);},
      shrinkWrap: true,
      itemCount: _helpText.length + _linkText.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(12.0),
        child: (index < _helpText.length) ? ListTile(title: Text(_helpText[index]), leading: const Icon(Icons.star_border_rounded),)
        : ListTile(title: Text(_linkText[index - _helpText.length]["title"] ?? ""), leading: const Icon(Icons.link),)
          .intoInkWell(onTap: () async {await launch(_linkText[index - _helpText.length]["link"] ?? "");}),
      ),
  ),);
  }
}
