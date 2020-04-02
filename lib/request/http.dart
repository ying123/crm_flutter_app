import 'package:bot_toast/bot_toast.dart';
import 'package:crm_flutter_app/config/common.dart';
import 'package:crm_flutter_app/config/env.dart';
import 'package:crm_flutter_app/config/error_code.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/interceptors/index.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';

/// http请求工具类封装
import 'package:dio/dio.dart';
import 'interceptors/cookies_interceptor.dart';

class Method {
  static final String get = 'GET';
  static final String post = 'POST';
  static final String put = 'PUT';
  static final String head = 'HEAD';
  static final String delete = 'DELETE';
  static final String patch = 'PATCH';
}

class Http {
  Dio _dio = Dio();

  factory Http() => _httpUtils();

  // 静态私有成员，没有初始化
  static Http _instance;
  static String _apiAddr = currentEnv.apiAddr;
  static void setApiAddr(Env newEnv) {
    _apiAddr = newEnv.apiAddr;
  }

  // 私有构造函数
  Http._() {
    _dio.interceptors.add(HeaderInterceptors());
    _dio.interceptors.add(ErrorInterceptors());
    if (Constant.ISDEBUG) {
      _dio.interceptors.add(LogsInterceptors());
    }
    _dio.interceptors.add(CookieInterceptor());
    _dio.interceptors.add(ResponseInterceptors());
  }

  ///判断是否已经实例化
  static Http _httpUtils() {
    if (_instance == null) {
      _instance = Http._();
    }
    return _instance;
  }

  /// options
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    options.headers = {"Accept": "application/json"};
    return options;
  }

  /// 对传入的[queryParameters]对象进行序列化
  String getPath(String path, {Object query}) {
    StringBuffer sb;
    if (path.startsWith('http')) {
      sb = StringBuffer(path);
    } else {
      sb = StringBuffer(_apiAddr + path);
    }

    if (query != null) {
      if (query is Map) {
        var str = '?';
        query.forEach((key, value) {
          str += '$key=$value&';
        });
        str = str.substring(0, str.length - 1);
        sb.write(str);
      }
    }
    return sb.toString();
  }
}

Future<ResultDataModel> httpGet(String path,
    {Map<String, dynamic> queryParameters, bool showLoading = false}) {
  return httpRequest(Method.get, path,
      queryParameters: queryParameters, showLoading: showLoading);
}

Future<ResultDataModel> httpPut(String path,
    {Map<String, dynamic> queryParameters,
    Map<String, dynamic> data,
    bool showLoading = false}) {
  return httpRequest(Method.put, path,
      queryParameters: queryParameters, data: data, showLoading: showLoading);
}

Future<ResultDataModel> httpDelete(String path,
    {Map<String, dynamic> queryParameters,
    Map<String, dynamic> data,
    bool showLoading = false}) {
  return httpRequest(Method.delete, path,
      queryParameters: queryParameters, data: data, showLoading: showLoading);
}

Future<ResultDataModel> httpPost(String path,
    {Map data,
    Map<String, dynamic> queryParameters,
    bool showLoading = false}) {
  return httpRequest(Method.post, path,
      data: data, queryParameters: queryParameters, showLoading: showLoading);
}

/// 请求函数
///
/// [method]请求方法
/// [path]请求路径
/// [data]请求体数据
/// [queryParamters]查询参数
/// [options]请求其他配置
/// [cancelToken]
Future<ResultDataModel> httpRequest(String method, String path,
    {Map data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    bool showLoading = false}) async {
  CancelFunc cancelFunc;
  Http httpUtils = new Http();
  String url = httpUtils.getPath(path, query: queryParameters);
  Response response;
  ResultDataModel errorResult;
  // // 设置代理抓包
  // (httpUtils._dio.httpClientAdapter as DefaultHttpClientAdapter)
  //     .onHttpClientCreate = (client) {
  //   client.findProxy = (uri) {
  //     // return 'PROXY 192.168.16.245:8888';
  //     return 'PROXY 192.168.16.94:8888'; //宇冬
  //     // return 'PROXY 192.168.16.139:8888'; //婉倩
  //     // return 'PROXY 192.168.16.193:8888'; // 文静
  //     // return 'PROXY 192.168.16.88:8888'; //郭燕
  //     // return 'PROXY 192.168.16.41:8888'; //梅丹
  //     // return 'PROXY 192.168.16.18:8888'; // 秀慧
  //   };
  //   //抓Https包设置
  //   client.badCertificateCallback = (cert, String host, int port) => true;
  // };
  if (showLoading == true) {
    cancelFunc = MessageBox.loading();
  }
  try {
    response = await httpUtils._dio.request(url,
        data: data,
        options: httpUtils._checkOptions(method, options),
        cancelToken: cancelToken);
  } on DioError catch (e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResult =
          ResultDataModel(data: null, msg: '请求超时了，请稍后重试', code: ErrorCode.FAIL);
    }
    errorResult =
        ResultDataModel(data: null, msg: '请求出错了，请稍后重试', code: ErrorCode.FAIL);
  } catch (e) {
    errorResult =
        ResultDataModel(data: null, msg: '未知错误：$e', code: ErrorCode.FAIL);
  }
  if (showLoading == true && cancelFunc != null) {
    // 关闭loading
    cancelFunc();
  }
  if (errorResult != null) {
    return errorResult;
  }
  return response.data;
}
