import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
/**
 * Cookie拦截器
 */
import 'package:dio/dio.dart';

class CookieInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    var cookies = await LocalStorage.get(Inputs.COOKIES_KEY); // 获取登录后保存的cookies
    var token = await LocalStorage.get(Inputs.TOKEN_KEY);
    if (cookies != null) {
      options.headers["Cookie"] = cookies;
    }
    if (token != null) {
      options.headers["token"] = token;
    }
    return options;
  }
}
