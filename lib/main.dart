import 'dart:io';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/pages/other/welcome_page.dart';
import 'package:crm_flutter_app/providers/im_model.dart';
import 'package:crm_flutter_app/providers/notices_model.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/sentry_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  final noticesModel = NoticesModel();
  final imModel = ImModel();

  SentryReporter.runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NoticesModel>.value(value: noticesModel),
      ChangeNotifierProvider<ImModel>.value(value: imModel),
    ],
    child: const MyApp(),
  ));

  if (Platform.isAndroid) {
    const style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '汽配铺CRM',
      theme: ThemeData(
          accentColor: CRMColors.primary,
          platform: TargetPlatform.iOS,
          unselectedWidgetColor: CRMColors.textLight,
          primaryColor: CRMColors.primary,
          textTheme: TextTheme(body1: CRMText.normalText),
          cursorColor: CRMColors.primary,
          dividerColor: CRMColors.borderLight,
          scaffoldBackgroundColor: CRMColors.commonBg,
          buttonTheme: ButtonThemeData(
              buttonColor: CRMColors.primary, focusColor: CRMColors.primary)),
      home: BotToastInit(
        child: WelcomePage(),
      ),
      navigatorKey: rootNavigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: Locale('zh', 'CH'),
    );
  }
}
