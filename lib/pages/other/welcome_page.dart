import 'dart:io';

import 'package:crm_flutter_app/config/common.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';
import 'package:mta/mta.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void initState() {
    super.initState();
    // 防止多次注册mta
    if (hadInit) return;
    hadInit = true;
    String mtaAppkey;
    Duration time = Duration(seconds: 2);
    if (Platform.isAndroid) {
      // android
      mtaAppkey = Constant.MTAANDROIDAPPKEY;
    } else {
      // ios
      mtaAppkey = Constant.MTAIOSAPPKEY;
      time = Duration(milliseconds: 1);
    }
    Mta.register(mtaAppkey);

    Future.delayed(time, () async {
      //如果获取到了cookies，直接跳转首页，否则跳转登录页
      var cookies = await LocalStorage.get(Inputs.COOKIES_KEY);
      var token = await LocalStorage.get(Inputs.TOKEN_KEY);
      if (cookies != null && token != null) {
        CRMNavigator.goHomePage(replace: true);
      } else {
        CRMNavigator.goUserLoginPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenFit.init(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: Image(image: AssetImage('assets/images/welcome.png')),
      ),
    );
  }
}
