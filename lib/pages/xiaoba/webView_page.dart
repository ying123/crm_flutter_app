import 'package:crm_flutter_app/widgets/crm_webview.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  final String fullPath;

  WebViewPage(this.fullPath, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CRMWebView.fromFullPath(fullPath),
      ),
    );
  }
}
