import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class RateItemWidget extends StatelessWidget {
  final Map rateDTO;
  final String date;

  RateItemWidget(this.rateDTO, this.date);

  List get detailsRow {
    List list = [];

    for (int i = 0; i < rateDTO['details'].length; i++) {
      list.add(
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: CRMColors.borderLight, width: ScreenFit.onepx()))),
          child: Flex(direction: Axis.horizontal, children: <Widget>[
            _buildTableCell(rateDTO['details'][i]["type_desc"] ?? "", flex: 2),
            _buildTableCell('${rateDTO['details'][i]["statistics"] ?? ""}'),
            Expanded(
              flex: 1,
              child: _buildButton(rateDTO['details'][i]["type_value"],
                  rateDTO['details'][i]["type_desc"] ?? ''),
            )
          ]),
        ),
      );
    }
    return list;
  }

  ///构建一个表格head的单元格
  Widget _buildHeadTableCell(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
          decoration: BoxDecoration(
              color: CRMColors.blueLight,
              border: Border(
                  right: BorderSide(
                      color: CRMColors.borderLight, width: ScreenFit.onepx()))),
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Text(title, style: CRMText.normalText)),
    );
  }

  ///构建一个普通表格单元格
  Widget _buildTableCell(String title,
      {int flex = 1, bool hasRightBorder = true}) {
    return Expanded(
      flex: flex,
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  right: hasRightBorder
                      ? BorderSide(
                          color: CRMColors.borderLight,
                          width: ScreenFit.onepx())
                      : null)),
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Text(title, style: CRMText.normalText)),
    );
  }

  Widget _buildButton(int typeValue, String typeDesc) {
    return GestureDetector(
      onTap: () {
        CRMNavigator.goRateDetailsPage(
            rateDTO['team_id'], typeValue, typeDesc, date);
      },
      child: Text(
        "明细",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: CRMColors.primary,
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            height: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                _buildHeadTableCell('类型', flex: 2),
                _buildHeadTableCell('实时数据'),
                _buildHeadTableCell('详情'),
              ],
            ),
            ...detailsRow,
            if (rateDTO['commission'] != null)
              Flex(direction: Axis.horizontal, children: <Widget>[
                _buildTableCell('售后服务佣金', flex: 2),
                _buildTableCell('¥${rateDTO["commission"] ?? ""}', flex: 2),
              ])
          ],
        ),
      ),
    );
  }
}
