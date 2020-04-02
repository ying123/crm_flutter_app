import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class NoNetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(
        title: '无网络',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/no_network.gif',
              width: ScreenFit.width(300),
            ),
            Text(
              '无网络访问',
              style: TextStyle(
                  color: CRMColors.textLight, fontSize: CRMText.normalTextSize),
            )
          ],
        ),
      ),
    );
  }
}
