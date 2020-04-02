import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:flutter/material.dart';

class CommissionDetailsPage extends StatelessWidget {
  final Map commissionDto;
  CommissionDetailsPage(this.commissionDto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '预测佣金明细',
        ),
        body: Column(
          children: <Widget>[
            DarkTitleWidget(
              title: '预测交易佣金：',
              subtitle: '${commissionDto["tradeCommission"] ?? ''}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '预测服务佣金：',
              subtitle: '${commissionDto["serviceCommission"] ?? ''}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
          ],
        ));
  }
}
