import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/model/article_list/ArticleItemModel.dart';
import 'package:wan_flutter/model/article_list/ArticleListModel.dart';
import 'package:wan_flutter/pages/article_list/ArticleItemPage.dart';
import 'package:wan_flutter/widget/EmptyHolder.dart';
import 'package:wan_flutter/widget/QuickTopFloatBtn.dart';

typedef RequestData = Future<Response> Function(int page);
typedef ShowQuickTop = void Function(bool show);

class ArticleListPage extends StatefulWidget {
  final Widget header;
  final RequestData request;
  final String emptyMsg;
  final bool keepAlive;
  final ShowQuickTop showQuickTop;
  final bool selfControl;

  ArticleListPage({Key key,
    this.header,
    this.request,
    this.emptyMsg,
    this.keepAlive = false,
    this.showQuickTop,
    this.selfControl = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleItemModel> _listData = List();
  List<int> _listDataId = List();
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  int _listDataPage = -1;
  var _haveMoreData = true;
  double _screenHeight;
  ListView listView;
  bool isLoading = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var itemCount = ((null == _listData) ? 0 : _listData.length) +
        (null == widget.header ? 0 : 1) +
        (_haveMoreData ? 0 : 1);
    if (itemCount <= 0) {
      return EmptyHolder(
        msg: (widget.emptyMsg == null)
            ? (_haveMoreData ? "Loading" : "Not Found")
            : widget.emptyMsg,
      );
    }

    listView = ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      controller: getControllerForListView(),
      itemBuilder: (context, index) {
        if (index == 0 && null != widget.header) {
          return widget.header;
        } else if (index - (null == widget.header ? 0 : 1) >=
            _listData.length) {
          return _buildLoadMoreItem();
        } else {
          return _buildListViewItemLayout(
              context, index - (null == widget.header ? 0 : 1));
        }
      },
    );

    var body = NotificationListener(
      onNotification: onScrollNotification,
      child: RefreshIndicator(
          color: GlobalConfig.colorPrimary,
          child: listView,
          onRefresh: handleRefresh),
    );
    return (null == widget.showQuickTop)
        ? Scaffold(
      resizeToAvoidBottomPadding: false,
      body: body,
      floatingActionButton: QuickTopFloatBtn(
        key: _quickTopFloatBtnKey,
        onPressed: () {
          handleScroll(0.0);
        },
      ),
    )
        : body;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  bool onScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels >=
        scrollNotification.metrics.maxScrollExtent) {
      _loadNextPage();
    }
    if (null == _screenHeight || _screenHeight <= 0) {
      _screenHeight = MediaQueryData
          .fromWindow(window)
          .size
          .height;
    }
    if (scrollNotification.metrics.axisDirection == AxisDirection.down &&
        _screenHeight >= 10 &&
        scrollNotification.metrics.pixels >= _screenHeight) {
      if (null != widget.showQuickTop) {
        widget.showQuickTop(true);
      } else {
        _quickTopFloatBtnKey.currentState.refreshVisible(true);
      }
    } else {
      if (null != widget.showQuickTop) {
        widget.showQuickTop(false);
      } else {
        _quickTopFloatBtnKey.currentState.refreshVisible(false);
      }
    }
    return false;
  }

  Future<Null> handleRefresh() async {
    _listDataPage = -1;
    _listData.clear();
    _listDataId.clear();
    await _loadNextPage();
  }

  void handleScroll(double offset, {ScrollController controller}) {
    ((null == controller) ? _controller : controller)?.animateTo(offset,
        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
  }

  Future<Null> _loadNextPage() async {
    if (isLoading || !this.mounted) {
      return null;
    }
    isLoading = true;
    _listDataPage++;
    var result = await _loadListData(_listDataPage);
    if (_listData.length < 8) {
      _listDataPage++;
      result = await _loadListData(_listDataPage);
    }
    if (this.mounted) setState(() {});
    isLoading = false;
    return result;
  }

  Future<Null> _loadListData(int page) {
    _haveMoreData = true;
    return widget.request(page).then((response) {
      var newList = ArticleListModel
          .fromJson(response.data)
          .data
          .datas;
      var originListLength = _listData.length;
      if (null != newList && newList.length > 0) {
//        _listData.addAll(newList);
        //防止添加进重复数据
        newList.forEach((item) {
          if (!_listDataId.contains(item.id)) {
            _listData.add(item);
            _listDataId.add(item.id);
          }
        });
      }
      _haveMoreData = originListLength != _listData.length;
    });
  }

  ScrollController getControllerForListView() {
    if (widget.selfControl) {
      if (null == _controller) _controller = ScrollController();
      return _controller;
    } else {
      return null;
    }
  }

  Widget _buildListViewItemLayout(BuildContext context, int index) {
    if (null == _listData ||
        _listData.length <= 0 ||
        index < 0 ||
        index >= _listData.length) {
      return Container();
    }
    return ArticleItemPage(_listData[index]);
  }

  Widget _buildLoadMoreItem() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Loading..."),
      ),
    );
  }
}
