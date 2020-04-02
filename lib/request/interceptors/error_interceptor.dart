import 'package:connectivity/connectivity.dart';
import 'package:crm_flutter_app/config/error_code.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:dio/dio.dart';

/*
 * 错误拦截
 */
class ErrorInterceptors extends InterceptorsWrapper {
  ErrorInterceptors();

  @override
  onRequest(RequestOptions options) async {
    // 没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      CRMNavigator.goNoNetworkPage();
      return ResultDataModel(
          data: null, msg: '无网络连接，请检查网络', code: ErrorCode.NoNetWork);
    }
    return options;
  }
}
