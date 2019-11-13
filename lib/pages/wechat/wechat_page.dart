import 'package:flutter/material.dart';
import 'package:wan_flutter/api/Api.dart';
import 'package:wan_flutter/api/CommonService.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/common/Pair.dart';
import 'package:wan_flutter/fonts/IconF.dart';
import 'package:wan_flutter/model/wechart/WeChatItemModel.dart';
import 'package:wan_flutter/model/wechart/WeChatModel.dart';
import 'package:wan_flutter/pages/article_list/ArticleListPage.dart';

class WeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeChatState();
  }
}

class _WeChatState extends State<WeChatPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<WeChatItemModel> _list = List();
  Map<int, Pair<ArticleListPage, GlobalKey<ArticleListPageState>>>
  _itemListPageMap = Map();
  TabController _tabController;
  var _controller = TextEditingController();
  int _currentItemIndex = 0;
  String _searchKey = "";
  bool _isSearching = false;
  var _maxCachePageNums = 5;
  var _cachedPageNum = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadWeChatNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _isSearching ? _buildSearchingAppbar() : _buildNormalAppbar(),
      body: _list.length <= 0
          ? null
          : TabBarView(
        children: _buildPages(context),
        controller: _tabController,
      ),
    );
  }

  AppBar _buildNormalAppbar() {
    return AppBar(
      title: Text(GlobalConfig.homeTab),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(IconF.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            })
      ],
      bottom: _buildSubTitle(),
    );
  }

  AppBar _buildSearchingAppbar() {
    var originTheme = Theme.of(context);
    return AppBar(
      leading: IconButton(
          icon: Icon(IconF.back),
          onPressed: () {
            handleRefreshSearchKey(key: "");
            setState(() {
              _isSearching = false;
            });
          }),
      centerTitle: true,
      title: Theme(
          data: originTheme.copyWith(
              hintColor: GlobalConfig.color_white_a80,
              textTheme: TextTheme(subhead: TextStyle(color: Colors.white))),
          child: TextField(
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
                hintText: "搜索公众号历史文章", border: InputBorder.none),
            onChanged: (str) {
              handleRefreshSearchKey(key: str);
            },
          )),
      bottom: _buildSubTitle(),
    );
  }

  TabBar _buildSubTitle() {
    return _list.length <= 0
        ? null
        : TabBar(
      tabs: _buildTabs(),
      controller: _tabController,
      labelColor: Colors.white,
      isScrollable: true,
      unselectedLabelColor: GlobalConfig.color_white_a80,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 1.0,
      indicatorColor: Colors.white,
    );
  }

  List<Widget> _buildTabs() {
    return _list?.map((WeChatItemModel _bean) {
      return Tab(
        text: _bean?.name,
      );
    })?.toList();
  }

  List<Widget> _buildPages(BuildContext context) {
    return _list?.map((_bean) {
      if (!_itemListPageMap.containsKey(_bean.id)) {
        var key = GlobalKey<ArticleListPageState>();
        _itemListPageMap[_bean.id] = Pair(
            ArticleListPage(
                key: key,
                keepAlive: _keepAlive(),
                emptyMsg: "臣妾搜不到呀",
                request: (page) {
                  return CommonService().getWeChatListData(
                      "${Api.MP_WECHAT_LIST}${_bean
                          .id}/$page/json?k=$_searchKey");
                }),
            key);
      }
      return _itemListPageMap[_bean.id].first;
    })?.toList();
  }

  bool _keepAlive() {
    if (_cachedPageNum < _maxCachePageNums) {
      _cachedPageNum++;
      return true;
    } else {
      return false;
    }
  }

  void _loadWeChatNames() async {
    CommonService().getWeChatNames((WeChatModel model) {
      if (model.data.length > 0) {
        setState(() {
          _updateState(model.data);
        });
      }
    });
  }

  void _updateState(List<WeChatItemModel> list) {
    _list = list;
    _tabController = TabController(length: _list.length, vsync: this);
    _tabController.addListener(() {
      _currentItemIndex = _tabController.index;
      handleRefreshSearchKey();
    });
  }

  void handleRefreshSearchKey({String key}) {
    if (null != key) _searchKey = key;
    _itemListPageMap[_list[_currentItemIndex].id]
        ?.second
        ?.currentState
        ?.handleRefresh();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
