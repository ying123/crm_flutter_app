import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/blue_panel_widget.dart';
import 'package:crm_flutter_app/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';

class ProgressDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BluePanelWidget(
      Column(
        children: <Widget>[
          titleValueWidget(
            title: '配件名称：',
            value: '前保险杠皮',
            titleColor: CRMColors.textLight,
          ),
          titleValueWidget(
            title: '配件编码：',
            value: '5202560040',
            titleColor: CRMColors.textLight,
          ),
          titleValueWidget(
            title: '品质：',
            value: '国内品牌-HYBBL-无',
            titleColor: CRMColors.textLight,
          ),
          titleValueWidget(
            title: '数量：',
            value: 'x1',
            titleColor: CRMColors.textLight,
          ),
          titleValueWidget(
            title: '单价：',
            value: '￥300',
            titleColor: CRMColors.textLight,
          ),
          titleValueWidget(
            title: '总价：',
            value: '￥300',
            titleColor: CRMColors.textLight,
          ),
        ],
      ),
    );
  }
}
