import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _KnowledgeSystemState();
  }
}

class _KnowledgeSystemState extends State<KnowledgeSystemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(GlobalConfig.knowledgeSystemsTab),
      centerTitle: true,
    ));
  }
}
