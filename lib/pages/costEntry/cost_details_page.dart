import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:flutter/material.dart';

class CostDetailsPage extends StatelessWidget {
  final Map costDto;
  CostDetailsPage(this.costDto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '成本明细',
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CRMIcons.edit,
                size: ScreenFit.width(48),
              ),
              onPressed: () {
                CRMNavigator.goCostEntryPage(costDto: costDto);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            DarkTitleWidget(
              title: '配送员工资：',
              subtitle: '${costDto["1"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '业务员工资：',
              subtitle: '${costDto["2"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '仓库月租金：',
              subtitle: '${costDto["3"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '每月油耗费：',
              subtitle: '${costDto["4"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '车辆折旧费：',
              subtitle: '${costDto["5"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '月管理费用：',
              subtitle: '${costDto["6"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
            DarkTitleWidget(
              title: '其他费用：',
              subtitle: '${costDto["7"]}',
              subtitleFontSize: CRMText.normalTextSize,
            ),
          ],
        ));
  }
}
