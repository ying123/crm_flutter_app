import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/crm_webview.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '隐私政策',
        ),
        body: CRMWebView.fromFullPath(
          'https://static.qipeipu.com/baturuCRMPrivacyPolicy.htm',
          addTokenAndCookies: false,
        ));
  }
}
