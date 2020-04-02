import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_flutter_app/config/common.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:flutter/material.dart';
import 'package:save_image/save_image.dart';
import 'package:webview/webview_flutter.dart';

class CRMWebView extends StatefulWidget {
  /// 拼接后的url
  final String url;

  /// 是否添加`token`和`cookies`到`WebView`, 默认是, html文档字符串构造函数默认`false`
  final bool addTokenAndCookies;

  static String getUrl(bool isHttp, String host, int port, String path,
      Map<String, dynamic> queryParameters) {
    var scheme = isHttp ? 'http://' : 'https://';
    port = port ?? (isHttp ? 80 : 443);
    if (queryParameters.isNotEmpty) {
      var queryString = Uri(queryParameters: queryParameters).toString();
      return '$scheme$host:${port.toString()}/#$path$queryString';
    }
    return '$scheme$host:${port.toString()}/#$path';
  }

  /// 默认构造vue形式的哈希路由地址
  CRMWebView(
      {Key key,
      bool isHttp = false,
      String host = 'm.crm.qipeipu.com',
      int port,
      @required String path,
      @required Map<String, dynamic> queryParameters,
      bool addTokenAndCookies = true})
      : url = getUrl(isHttp, host, port, path, queryParameters),
        addTokenAndCookies = addTokenAndCookies,
        super(key: key);

  /// html文档字符串构造函数
  ///
  /// [htmlDocString] 格式如下
  /// ```dart
  /// <!DOCTYPE html><html>
  /// <head><title>Navigation Delegate Example</title></head>
  /// <body>
  /// <p>
  /// The navigation delegate is set to block navigation to the youtube website.
  /// </p>
  /// <ul>
  /// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
  /// <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
  /// </ul>
  /// </body>
  /// </html>
  /// ```
  CRMWebView.fromHtmlDocString(String htmlDocString,
      {Key key, bool addTokenAndCookies = false})
      : url = htmlDocString,
        addTokenAndCookies = addTokenAndCookies,
        super(key: key);

  /// 全路径构造函数
  ///
  /// [fullpath] 全路径，协议开头
  CRMWebView.fromFullPath(String fullpath,
      {Key key, bool addTokenAndCookies = true})
      : assert(fullpath.startsWith('http')),
        url = fullpath,
        addTokenAndCookies = addTokenAndCookies,
        super(key: key);

  _CRMWebViewState createState() => _CRMWebViewState();
}

class _CRMWebViewState extends State<CRMWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  static final fnMap = <String, Function>{
    'close': (Map<String, dynamic> args) {
      String action = args['action'];
      String currentUrl = args['currentUrl'];
      if (action == 'back') {
        rootNavigatorState.pop();
      } else if (action == 'login') {
        CRMNavigator.goUserLoginPage(onLoginSucces: () {
          CRMNavigator.goWebViewPage(currentUrl);
        });
      }
    },
    'downloadImage': (Map<String, dynamic> args) {
      String imageUrl = args['imageUrl'];
      SaveImage.saveImage(imageUrl);
    }
  };
  String _token = '';
  String _cookies = '';

  String get initialUrl {
    if (widget.url.startsWith('http')) {
      // 添加`token`和`cookies`queryString
      if (widget.addTokenAndCookies &&
          !widget.url.contains(RegExp(r'token=.*&cookies=.*'))) {
        var queryParameters = <String, dynamic>{
          'token': _token,
          'cookies': _cookies,
          'platform': Platform.isIOS ? 'ios' : 'android',
        };
        var qs = Uri(queryParameters: queryParameters).toString();
        if (widget.url.contains(RegExp(r'^http.+\?\w+=\w*'))) {
          return '${widget.url}${qs.replaceFirst('?', '&')}';
        }
        return '${widget.url}$qs';
      } else {
        return widget.url;
      }
    } else {
      return Uri.dataFromString(widget.url,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString();
    }
  }

  void initWebView() async {
    if (widget.addTokenAndCookies) {
      var results = await Future.wait([
        LocalStorage.get<String>(Inputs.TOKEN_KEY),
        LocalStorage.get<String>(Inputs.COOKIES_KEY)
      ]);
      setState(() {
        _token = results[0];
        _cookies = results[1];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.addTokenAndCookies && (_token.isEmpty || _cookies.isEmpty)) {
      return Container(
        color: Colors.white,
        child: LoadingMoreWidget(),
      );
    }

    return WebView(
      debuggingEnabled: Constant.ISDEBUG,
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'CRMJSBridge',
            onMessageReceived: (JavascriptMessage javascriptMessage) {
              var msg = javascriptMessage.message;
              print('================');
              print('msg >> $msg');
              print('================');
              try {
                Map<String, dynamic> protocolObject = json.decode(msg);
                var fn = fnMap[protocolObject['fnName']];
                fn(protocolObject['args']);
              } catch (e) {
                print(e);
              }
            })
      ]),
      onWebViewCreated: (WebViewController webViewController) {
        // setWebViewCache(webViewController);
        _controller.complete(webViewController);
      },
      onPageFinished: (url) {
        // 这个会执行两遍，估计是bug
        print('$url');
      },
    );
  }

  /// 有问题，有时不能正常写入，有试能写入但在页面初始化后才写入，导致一开始的请求失败
  /// https://github.com/flutter/plugins/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aopen+cookie
  void setWebViewCache(controller) {
    print('$_cookies>>>$_token');

    controller.evaluateJavascript('document.cookie="$_cookies"');
    controller.evaluateJavascript('localStorage.setItem("token","$_token")');
  }
}
