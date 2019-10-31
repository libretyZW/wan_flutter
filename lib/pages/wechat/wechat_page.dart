import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';

class WeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WeChatState();
  }
}

class _WeChatState extends State<WeChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(GlobalConfig.weChatTab),
      centerTitle: true,
    ));
  }
}
