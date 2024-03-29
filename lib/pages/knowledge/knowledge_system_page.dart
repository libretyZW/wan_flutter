import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wan_flutter/api/Api.dart';
import 'package:wan_flutter/api/CommonService.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/model/knowledge_systems/KnowledgeSystemsChildModel.dart';
import 'package:wan_flutter/model/knowledge_systems/KnowledgeSystemsModel.dart';
import 'package:wan_flutter/model/knowledge_systems/KnowledgeSystemsParentModel.dart';
import 'package:wan_flutter/pages/article_list/ArticleListPage.dart';
import 'package:wan_flutter/widget/EmptyHolder.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KnowledgeSystemState();
  }
}

class _KnowledgeSystemState extends State<KnowledgeSystemPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  KnowledgeSystemsParentModel _currentTreeRootModel;
  KnowledgeSystemsModel _treeModel;
  TabController _tabControllerOutter;
  Map<int, TabController> _tabControllerInnerMaps = Map();
  PreferredSize _appBarBottom;
  double _screenWidth = MediaQueryData
      .fromWindow(window)
      .size
      .width;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadTreeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalConfig.knowledgeSystemsTab),
        centerTitle: true,
        bottom: _buildTitleBottom(),
      ),
      body: _buildBody(_currentTreeRootModel),
    );
  }

  PreferredSize _buildTitleBottom() {
    if (null == _appBarBottom && null != _treeModel)
      _appBarBottom = PreferredSize(
        child: _buildTitleTabs(),
        preferredSize: Size(_screenWidth, kToolbarHeight * 2),
      );
    return _appBarBottom;
  }

  Widget _buildTitleTabs() {
    if (null == _treeModel) {
      return EmptyHolder(
        msg: "Loading",
      );
    }
    _tabControllerOutter =
        TabController(length: _treeModel?.data?.length, vsync: this);
    _tabControllerOutter.addListener(() {
      setState(() {
        _currentTreeRootModel = _treeModel.data[_tabControllerOutter.index];
      });
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: TabBar(
            controller: _tabControllerOutter,
            labelColor: Colors.white,
            isScrollable: true,
            unselectedLabelColor: GlobalConfig.color_white_a80,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 2.0),
            indicatorWeight: 1.0,
            indicatorColor: Colors.white,
            tabs: _buildRootTabs(),
          ),
          width: _screenWidth,
          height: kToolbarHeight,
        ),
        SizedBox(
          child: TabBarView(
            children: _buildSecondTitle(),
            controller: _tabControllerOutter,
          ),
          width: _screenWidth,
          height: kToolbarHeight,
        ),
      ],
    );
  }

  List<Widget> _buildRootTabs() {
    return _treeModel.data?.map((KnowledgeSystemsParentModel model) {
      return Tab(
        text: model?.name,
      );
    })?.toList();
  }

  List<Widget> _buildSecondTitle() {
    return _treeModel.data?.map(_buildSingleSecondTitle)?.toList();
  }

  Widget _buildSingleSecondTitle(KnowledgeSystemsParentModel model) {
    if (null == model) {
      return EmptyHolder(
        msg: "Loading",
      );
    }
    if (null == _tabControllerInnerMaps[model.id])
      _tabControllerInnerMaps[model.id] =
          TabController(length: model.children.length, vsync: this);
    return TabBar(
      controller: _tabControllerInnerMaps[model.id],
      labelColor: Colors.white,
      isScrollable: true,
      unselectedLabelColor: GlobalConfig.color_white_a80,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 1.0,
      indicatorColor: Colors.white,
      tabs: _buildSecondTabs(model),
    );
  }

  List<Widget> _buildSecondTabs(KnowledgeSystemsParentModel model) {
    return model.children.map((KnowledgeSystemsChildModel model) {
      return Tab(
        text: model?.name,
      );
    })?.toList();
  }

  Widget _buildBody(KnowledgeSystemsParentModel model) {
    if (null == model) {
      return EmptyHolder(
        msg: "Loading",
      );
    }
    if (null == _tabControllerInnerMaps[model.id])
      _tabControllerInnerMaps[model.id] =
          TabController(length: model.children.length, vsync: this);
    return TabBarView(
      key: Key("tb${model.id}"),
      children: _buildPages(model),
      controller: _tabControllerInnerMaps[model.id],
    );
  }

  List<Widget> _buildPages(KnowledgeSystemsParentModel model) {
    return model.children?.map(_buildSinglePage)?.toList();
  }

  Widget _buildSinglePage(KnowledgeSystemsChildModel model) {
    return ArticleListPage(
      key: Key("${model.id}"),
      request: (page) {
        return CommonService().getTreeItemList(
            "${Api.TREES_DETAIL_LIST}$page/json?cid=${model.id}");
      },
    );
  }

  void _loadTreeList() {
    CommonService().getTrees((KnowledgeSystemsModel _bean) {
      setState(() {
        _treeModel = _bean;
        _currentTreeRootModel = _treeModel.data[0];
      });
    });
  }
}
