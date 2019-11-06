import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_flutter/model/article_list/ArticleItemModel.dart';
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

  ArticleListPage(
      {Key key,
      this.header,
      this.request,
      this.emptyMsg,
      this.keepAlive,
      this.showQuickTop,
      this.selfControl})
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
  int _listDataPae = -1;
  var _haveMoreData = true;
  double _screenHeight;
  ListView listView;

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

    return null;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  void handleScroll(double offset, {ScrollController controller}) {
    ((null == controller) ? _controller : controller)?.animateTo(offset,
        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
  }

  void _loadNextPage() {}

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
