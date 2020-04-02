import 'package:crm_flutter_app/config/env.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/crm_webview.dart';
import 'package:flutter/material.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final Map<String, dynamic> queryParameters;

  AnnouncementDetailsPage(this.queryParameters, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var qs = queryParameters.isEmpty
        ? ''
        : Uri(queryParameters: queryParameters).toString();
    return Scaffold(
      appBar: AppbarWidget(
        title: '公告详情',
      ),
      body: CRMWebView.fromFullPath(currentEnv.anounceDetailsAddr + qs),
      // CRMWebView(
      //   isHttp: true,
      //   host: '192.168.16.213',
      //   port: 8008,
      //   path: '/anounceDetails',
      //   queryParameters: queryParameters,
      // )
    );
  }
}
