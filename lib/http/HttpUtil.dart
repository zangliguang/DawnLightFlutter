import 'package:dio/dio.dart';
import 'package:liguang_flutter/constants.dart';

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  Options options;

  static HttpUtil getInstance() {
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }

  HttpUtil() {
    options = Options(
//      baseUrl: Constants.BaseUrl,
      connectTimeout: 10000,
      receiveTimeout: 3000,
      headers: {},
    );
    dio = new Dio(options);
  }

  get(String url, {Map<String, String> params}) async {
    Response response;
    if (null == params) {
      response = await dio.get(url);
    } else {
      response = await dio.get(url, data: params);
    }

    return response.data;
  }
}
