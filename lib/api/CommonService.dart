import 'package:dio/dio.dart';
import 'package:wan_flutter/model/homebanner/HomeBannerModel.dart';

import 'Api.dart';

class CommonService {
  void getBanner(Function callback) async {
    Dio().get(Api.HOME_BANNER).then((response) {
      callback(HomeBannerModel.fromJson(response.data));
    });
  }

  Future<Response> getArticleListData(int page) async {
    return await Dio().get("${Api.HOME_LIST}$page/json");
  }
}
