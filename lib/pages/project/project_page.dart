import 'package:flutter/material.dart';
import 'package:wan_flutter/api/Api.dart';
import 'package:wan_flutter/api/CommonService.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/model/project/ProjectClassifyItemModel.dart';
import 'package:wan_flutter/model/project/ProjectClassifyModel.dart';
import 'package:wan_flutter/pages/article_list/ArticleListPage.dart';
import 'package:wan_flutter/widget/EmptyHolder.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectState();
  }
}

class _ProjectState extends State<ProjectPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController _tabController;
  List<ProjectClassifyItemModel> _list = List();
  var _maxCachePageNums = 5;
  var _cachedPageNum = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadClassifysDelay(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalConfig.projectTab),
        centerTitle: true,
        bottom: _buildTabBar(),
      ),
      body: _buildBody(),
    );
  }

  TabBar _buildTabBar() {
    if (_list.length <= 0) {
      return null;
    }
    if (null == _tabController)
      _tabController = TabController(length: _list.length, vsync: this);
    return TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        isScrollable: true,
        unselectedLabelColor: GlobalConfig.color_white_a80,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(bottom: 2.0),
        indicatorWeight: 1.0,
        indicatorColor: Colors.white,
        tabs: _buildTabs());
  }

  List<Widget> _buildTabs() {
    return _list?.map(_buildSingleTab)?.toList();
  }

  Widget _buildSingleTab(ProjectClassifyItemModel bean) {
    return Tab(
      text: bean?.name,
    );
  }

  Widget _buildBody() {
    return (null == _tabController || _list.length <= 0)
        ? EmptyHolder()
        : TabBarView(controller: _tabController, children: _buildPages());
  }

  List<Widget> _buildPages() {
    return _list?.map(_buildSinglePage)?.toList();
  }

  Widget _buildSinglePage(ProjectClassifyItemModel bean) {
    return ArticleListPage(
      keepAlive: _keepAlive(),
      request: (page) {
        return CommonService().getProjectListData((bean.url == null)
            ? ("${Api.PROJECT_LIST}$page/json?cid=${bean.id}")
            : ("${bean.url}$page/json"));
      },
    );
  }

  bool _keepAlive() {
    if (_cachedPageNum < _maxCachePageNums) {
      _cachedPageNum++;
      return true;
    } else {
      return false;
    }
  }

  void _loadClassifysDelay(int delays) async {
    Future.delayed(Duration(milliseconds: delays)).then((_) {
      CommonService().getProjectClassify((ProjectClassifyModel _bean) {
        if (_bean.data.length > 0) {
          setState(() {
            _loadNewestProjects();
            _bean.data.forEach((_projectClassifyItemModel) {
              _list.add(_projectClassifyItemModel);
            });
          });
        }
      });
    });
  }

  void _loadNewestProjects() {
    _list.insert(
        0, ProjectClassifyItemModel(name: "最新项目", url: Api.PROJECT_NEWEST));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
