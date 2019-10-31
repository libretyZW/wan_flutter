import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserState();
  }
}

class _UserState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(GlobalConfig.mineTab),
      centerTitle: true,
    ));
  }
}
