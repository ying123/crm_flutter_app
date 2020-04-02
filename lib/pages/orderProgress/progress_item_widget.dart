import 'package:crm_flutter_app/config/crm_style.dart';

import 'package:crm_flutter_app/pages/orderProgress/progress_detail_widget.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/widgets/ellipsis_title_widget.dart';
import 'package:flutter/material.dart';

class ProgressItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CRMNavigator.goOrderDetailPage('12');
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('肇庆市端州区创城汽车修配厂', style: CRMText.mainTitleText),
              ),
            ),
            Divider(),
            EllipsisTitleWidget(
              '奔驰-R-Class（R级）',
              value: '2019-07-02 16:49:00',
            ),
            ProgressDetailWidget(),
          ],
        ),
      ),
    );
  }
}
