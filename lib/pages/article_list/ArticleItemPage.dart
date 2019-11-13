import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan_flutter/api/Api.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/common/Router.dart';
import 'package:wan_flutter/fonts/IconF.dart';
import 'package:wan_flutter/model/article_list/ArticleItemModel.dart';
import 'package:wan_flutter/utils/StringUtil.dart';
import 'package:wan_flutter/widget/StrokeWidget.dart';

class ArticleItemPage extends StatelessWidget {
  final ArticleItemModel item;

  ArticleItemPage(this.item);

  @override
  Widget build(BuildContext context) {
    item.title = StringUtil.strClean(item.title);
    item.desc = (null == item.desc) ? "" : StringUtil.strClean(item.desc);
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod("TextInput.hide");
        Router().openArticle(context, item);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
          elevation: 5.0,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: _buildListViewItem()),
        ),
      ),
    );
  }

  Widget _buildListViewItem() {
    var widget = (null != item.envelopePic &&
            item.envelopePic.isNotEmpty &&
            item.envelopePic.endsWith(Api.DEFAULT_PROJECT_IMG))
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(child: _buildItemLeftSide()),
              Container(
                width: 30.0,
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  imageUrl: item.envelopePic,
                ),
              )
            ],
          )
        : _buildItemLeftSide();

    return widget;
  }

  Widget _buildItemLeftSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildItemLeftColumns(),
    );
  }

  List<Widget> _buildItemLeftColumns() {
    List<Widget> list = List();
    list.add(Text(
      item.title,
      style: TextStyle(
          fontSize: 16.0,
          color: GlobalConfig.color_black,
          fontWeight: FontWeight.w500),
      textAlign: TextAlign.left,
    ));

    if (item.desc.length > item.title.length) {
      list.add(Text(
        item.desc,
        maxLines: 3,
        style: TextStyle(
          color: GlobalConfig.color_dark_gray,
          fontSize: 13.0,
        ),
      ));
    }

    list.add(Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            IconF.time,
            size: 13.0,
            color: GlobalConfig.color_dark_gray,
          ),
          Text(
            " ${item.niceDate} @${item.author}",
            style:
                TextStyle(color: GlobalConfig.color_dark_gray, fontSize: 13.0),
          )
        ],
      ),
    ));

    var tags = _buildTagsAndDate();
    if (tags.length > 0) {
      list.add(Row(
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: tags,
      ));
    }
    return list;
  }

  List<Widget> _buildTagsAndDate() {
    List<Widget> list = List();
    item.tags?.forEach((tag) {
      list.add(StrokeWidget(
          strokeWidth: 0.5,
          edgeInsets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          color: GlobalConfig.color_tags,
          childWidget: Text(
            tag.name,
            style: TextStyle(
                fontSize: 11.0,
                color: GlobalConfig.color_tags,
                fontWeight: FontWeight.w100),
          )));
    });
    String chapterNameStr =
        "${StringUtil.isNullOrEmpty(item.superChapterName) ? "" : "${(list.length <= 0 ? "分类：" : "  ")}${item.superChapterName}"}"
        "${(StringUtil.isNullOrEmpty(item.superChapterName) || StringUtil.isNullOrEmpty(item.chapterName)) ? "" : "/"}"
        "${StringUtil.isNullOrEmpty(item.chapterName) ? "" : item.chapterName}";
    if (!StringUtil.isNullOrEmpty(chapterNameStr.trim())) {
      list.add(Text(
        chapterNameStr,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13.0, color: GlobalConfig.color_dark_gray),
      ));
    }
    return list;
  }
}
