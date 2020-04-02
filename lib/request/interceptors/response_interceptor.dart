import 'package:crm_flutter_app/config/error_code.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/config/permission.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:dio/dio.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) {
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data is Map) {
      var result = ResultDataModel.fromJson(response.data);
      if (result.code == 101 ||
          result.code == 401 ||
          result.state == 'USER_OFFLINE') {
        //后端接口超时，删除本地缓存
        LocalStorage.remove(Permission.PERMISSION_KEY); //删除功能模块的权限
        LocalStorage.remove(Inputs.COOKIES_KEY); // 删除cookies
        LocalStorage.remove(Inputs.TOKEN_KEY); // 删除tooken
        CRMNavigator.goUserLoginPage(); // cookie超时，跳转登录页
        return ResultDataModel(
            data: null,
            msg: '登录超时，请重新登录',
            code: ErrorCode.unlogin,
            success: false);
      }
      return result;
    } else {
      return ResultDataModel(
          data: null, msg: '请求出错了，请稍后重试', code: ErrorCode.FAIL, success: false);
    }
  }
}
