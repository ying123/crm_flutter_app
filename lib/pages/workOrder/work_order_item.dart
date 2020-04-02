import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class WorkOrderItemWidget extends StatefulWidget {
  WorkOrderItemWidget({Key key}) : super(key: key);

  _WorkOrderItemWidgetState createState() => _WorkOrderItemWidgetState();
}

class _WorkOrderItemWidgetState extends State<WorkOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '广州市海珠区皮特家汽车美容服务中心',
                      style: CRMText.mainTitleText,
                    ),
                  ),
                  Text(
                    '待CRM审核',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: CRMText.smallTextSize),
                  ),
                ],
              )),
          Divider(),
          Padding(
              padding: EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'RG4271611',
                    style: CRMText.normalText,
                  ),
                  Text(
                    '配件名称：方向机内球头（左）',
                    style: CRMText.normalText,
                  ),
                  Text(
                    '配件数量：1',
                    style: CRMText.normalText,
                    textAlign: TextAlign.left,
                  ),
                ],
              )),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '售后管家：',
                        style: CRMText.normalText,
                      ),
                      Text(
                        '不通过',
                        style: TextStyle(
                            color: CRMColors.danger,
                            fontSize: CRMText.smallTextSize),
                      ),
                    ],
                  ),
                ),
                Text(
                  '2019-07-08 17:10:58',
                  style: CRMText.smallText,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
