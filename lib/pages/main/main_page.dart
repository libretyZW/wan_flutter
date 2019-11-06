import 'dart:ui';

import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wan_flutter/api/CommonService.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/model/homebanner/HomeBannerItemModel.dart';
import 'package:wan_flutter/model/homebanner/HomeBannerModel.dart';
import 'package:wan_flutter/pages/article_list/ArticleListPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainPage> {
  List<HomeBannerItemModel> _bannerData;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalConfig.homeTab),
        centerTitle: true,
      ),
      body: ArticleListPage(
        header: _buildBanner(context),
        request: (page) {
          return CommonService().getArticleListData(page);
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    if (null == _bannerData || _bannerData.length <= 0) {
      return Center(
        child: Text("Loading"),
      );
    } else {
      double screenWidth = MediaQueryData.fromWindow(window).size.width;
      return Container(
        height: screenWidth * 500 / 900,
        width: screenWidth,
        child: Card(
          elevation: 5.0,
          shape: Border(),
          margin: EdgeInsets.all(0.0),
          child: BannerView(
            data: _bannerData,
            delayTime: 10,
            onBannerClickListener: (int index, dynamic itemData) {
              HomeBannerItemModel item = itemData;
//              Router().openWeb(context, item.url, item.title);
            },
            buildShowView: (index, data) {
              return CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                imageUrl: (data as HomeBannerItemModel).imagePath,
              );
            },
          ),
        ),
      );
    }
  }

  void _loadBannerData() {
    CommonService().getBanner((HomeBannerModel _bean) {
      if (_bean.data.length > 0) {
        setState(() {
          _bannerData = _bean.data;
        });
      }
    });
  }
}
