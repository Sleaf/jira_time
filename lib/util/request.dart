import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

class Request extends Dio {
  final cookieManager = CookieManager(CookieJar());
  String cookie;

  Request() {
    super.options = BaseOptions(
      connectTimeout: 10 * 1000,
      receiveTimeout: 20 * 1000,
      headers: {
        "Content-Type": 'application/json',
      },
    );
    super.interceptors
      // 使用 CookieJar 保存 cookies
      ..add(cookieManager)
      // 添加拦截器
      ..add(InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          this.cookie = options.headers['cookie'];
          return options; //continue
        },
//          onResponse: (Response response) {
//            // Do something with response data
//            return response; // continue
//          },
//          onError: (DioError e) {
//            // Do something with response error
//            return e; //continue
//          },
      ));
  }

  void updateBaseUrl(String baseUrl) {
    super.options.baseUrl = baseUrl;
  }
}

Request request = Request();
