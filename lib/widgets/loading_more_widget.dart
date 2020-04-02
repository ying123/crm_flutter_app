import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class LoadingMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenFit.width(30),
              height: ScreenFit.width(30),
              margin: EdgeInsets.only(right: 10),
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            ),
            Text(
              '加载中...',
              style: CRMText.normalText,
            ),
          ],
        ),
      ),
    );
  }
}
