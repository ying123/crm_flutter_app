import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

/// 安卓拦截返回事件，不退出App回到桌面
class BackHomeWidget extends StatelessWidget {
  final Widget child;

  BackHomeWidget({Key key, @required this.child}) : super();
  @override
  Widget build(BuildContext context) {
    /// 返回false表示不出栈
    Future<bool> _backHome() async {
      if (Platform.isAndroid) {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: "android.intent.category.HOME",
        );
        await intent.launch();
      }
      return false;
    }

    return WillPopScope(
      onWillPop: _backHome,
      child: child,
    );
  }
}
