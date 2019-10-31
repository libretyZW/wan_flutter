import 'package:flutter/material.dart';
import 'package:wan_flutter/pages/home_page.dart';

import 'common/GlobalConfig.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My_Wan_Android',
      theme: ThemeData(
        primarySwatch: GlobalConfig.colorPrimary,
      ),
      home: MyHomePage(),
    );
  }
}
