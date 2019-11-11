import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wan_flutter/api/Api.dart';
import 'package:wan_flutter/api/CommonService.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/common/Router.dart';
import 'package:wan_flutter/common/User.dart';
import 'package:wan_flutter/pages/article_list/ArticleListPage.dart';
import 'package:wan_flutter/widget/EmptyHolder.dart';
import 'package:wan_flutter/widget/QuickTopFloatBtn.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserState();
  }
}

class _UserState extends State<UserPage> {
  double _screenWidth = MediaQueryData
      .fromWindow(window)
      .size
      .width;
  ScrollController _controller;
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  ArticleListPage _itemListPage;
  GlobalKey<ArticleListPageState> _itemListPageKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    _controller = FixedExtentScrollController();
    return Scaffold(
      body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool boxIsScrilled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: _screenWidth * 2 / 3,
                forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(getUserName()),
                  background: _buildHead(context),
                ),
              )
            ];
          },
          body: User().isLogin()
              ? _buildMineBody()
              : EmptyHolder(
            msg: "要查看收藏的文章请先登录哈",
          )),
      floatingActionButton: QuickTopFloatBtn(
        key: _quickTopFloatBtnKey,
        onPressed: () {
          _itemListPageKey.currentState
              ?.handleScroll(0, controller: _controller);
        },
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: GlobalConfig.colorPrimary),
      child: GestureDetector(
        onTap: () {
          if (User().isLogin()) {
            _showLogout(context);
          } else {
            _toLogin(context);
          }
        },
        child: _buildAvatar(),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
        child: Container(
          width: _screenWidth / 4,
          height: _screenWidth / 4,
          decoration: BoxDecoration(
              color: const Color(0xffffff),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      "${Api.AVATAR_CODING}${getUserName().hashCode % 20 +
                          1}.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(500))),
        ));
  }

  String getUserName() {
    return (!User().isLogin()) ? "Login" : User().userName;
  }

  void _toLogin(BuildContext context) async {
    await Router().openLogin(context);
    User().refreshUserData(callback: () {
      setState(() {});
    });
  }

  Future<Null> _showLogout(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _buildLogout(context);
        });
  }

  Widget _buildLogout(BuildContext context) {
    return AlertDialog(
      content: Text("确定退出登录？"),
      actions: <Widget>[
        RaisedButton(
            elevation: 0,
            child: Text("OK"),
            color: Colors.transparent,
            textColor: GlobalConfig.colorPrimary,
            onPressed: () {
              User().logout();
              User().refreshUserData(callback: () {
                setState(() {});
              });
              Navigator.pop(context);
            }),
        RaisedButton(
            elevation: 0,
            child: Text("No"),
            color: Colors.transparent,
            textColor: GlobalConfig.colorPrimary,
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget _buildMineBody() {
    if (null == _itemListPage) {
      _itemListPage = ArticleListPage(
        key: _itemListPageKey,
        keepAlive: true,
        selfControl: false,
        showQuickTop: (show) {
          _quickTopFloatBtnKey.currentState.refreshVisible(show);
        },
        request: (page) {
          return CommonService().getCollectListData(page);
        },
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
