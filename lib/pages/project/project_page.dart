import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectState();
  }
}

class _ProjectState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(GlobalConfig.projectTab),
      centerTitle: true,
    ));
  }
}
