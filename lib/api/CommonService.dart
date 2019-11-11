import 'package:dio/dio.dart';
import 'package:wan_flutter/common/User.dart';
import 'package:wan_flutter/model/homebanner/HomeBannerModel.dart';

import 'Api.dart';

class CommonService {
  void getBanner(Function callback) async {
    Dio().get(Api.HOME_BANNER, options: _getOptions()).then((response) {
      callback(HomeBannerModel.fromJson(response.data));
    });
  }

  Future<Response> getArticleListData(int page) async {
    return await Dio().get(
        "${Api.HOME_LIST}$page/json", options: _getOptions());
  }

  Future<Response> getCollectListData(int page) async {
    return await Dio()
        .get("${Api.COLLECTED_ARTICLE}$page/json", options: _getOptions());
  }

  Future<Response> login(String username, String password) async {
    FormData formData = new FormData.fromMap({
      "username": "$username",
      "password": "$password",
    });
    return await Dio().post(Api.LOGIN, data: formData);
  }

  Future<Response> register(String username, String password) async {
    FormData formData = new FormData.fromMap({
      "username": "$username",
      "password": "$password",
      "repassword": "$password",
    });
    return await Dio().post(Api.REGISTER, data: formData);
  }

  Options _getOptions() {
    return Options(headers: User().getHeader());
  }
}
