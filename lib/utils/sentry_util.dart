import 'dart:async';

import 'package:crm_flutter_app/config/common.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

class SentryReporter {
  SentryReporter.runApp(Widget app) {
    assert(app != null);
    _overrideFlutterError();
    // Zones 为代码建立执行上下文环境。在这个上下文环境中，所有发生的异常在抛出 onError 时都能够很容易地被捕获到
    runZoned<void>(() {
      runApp(app);
    }, onError: _reportError);
  }

  static final SentryClient _sentry = SentryClient(dsn: Constant.SENTRYDSN);

  /// 是否不上报sentry
  static bool get _isNoReport {
    return !Constant.isProductEnv;
  }

  /// Reports [error] along with its [stackTrace] to Sentry.io.
  static Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');

    // Errors thrown in development mode are unlikely to be interesting. You can
    // check if you are running in dev mode using an assertion and omit sending
    // the report.
    if (_isNoReport) {
      print(stackTrace);
      return;
    }
    SentryResponse response;
    try {
      response = await _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    } catch (error) {
      response = SentryResponse.failure(error);
    }

    if (response.isSuccessful) {
      print('Success to report to Sentry.io: Event ID: ${response.eventId}');
    } else {
      print('Failed to report to Sentry.io: ${response.error}');
    }
  }

  /// 重写 FlutterError.onError 属性。在开发环境下，可以将异常格式化输出到控制台。在生产环境下，可以把异常传递给上个步骤中的 onError 回调
  static void _overrideFlutterError() {
    // This captures errors reported by the Flutter framework.
    FlutterError.onError = (FlutterErrorDetails details) {
      if (_isNoReport) {
        // In development mode simply print to console.
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode report to the application zone to report to
        // Sentry.
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };

    /// 重写Flutter的错误页面
    // ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    //   print(flutterErrorDetails);
    //   return Center(
    //     child: Text("Flutter 走神了"),
    //   );
    // };
  }
}
