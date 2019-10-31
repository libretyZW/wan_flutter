import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/fonts/IconF.dart';
import 'package:wan_flutter/pages/project/project_page.dart';
import 'package:wan_flutter/pages/user/user_page.dart';
import 'package:wan_flutter/pages/wechat/wechat_page.dart';

import 'knowledge/knowledge_system_page.dart';
import 'main/main_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  PageController _pageController;

  final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(IconF.blog),
        title: Text(GlobalConfig.homeTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.project),
        title: Text(GlobalConfig.projectTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.wechat),
        title: Text(GlobalConfig.weChatTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.tree),
        title: Text(GlobalConfig.knowledgeSystemsTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.me),
        title: Text(GlobalConfig.mineTab),
        backgroundColor: GlobalConfig.colorPrimary),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: this._page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          MainPage(),
          ProjectPage(),
          WeChatPage(),
          KnowledgeSystemPage(),
          UserPage()
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomTabs,
        currentIndex: _page,
        fixedColor: GlobalConfig.colorPrimary,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
      ),
    );
  }

  void onTap(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
