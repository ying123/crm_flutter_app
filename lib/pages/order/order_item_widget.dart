import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';

import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatefulWidget {
  final String type;
  final item;
  OrderItemWidget(this.type, this.item);
  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Utils.trackEvent('order_details');
        CRMNavigator.goOrderDetailPage(widget.item['orderId']);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenFit.height(20.0)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DarkTitleWidget(
              type: Status.LIGHT,
              size: Status.MINI,
              title: '${widget.item['orderNo']}',
              subtitle: widget.type == 'abnormalType'
                  ? '${widget.item['abnormalType'] == 1 ? '取消订单' : widget.item['abnormalType'] == -1 ? '无货' : widget.item['abnormalType'] == 2 ? '延迟发货' : ''}'
                  : '${widget.item['payState'] == 0 ? '未支付' : widget.item['payState'] == 2 ? '已支付' : ''}',
              subtitleColor: CRMColors.warning,
            ),
            DarkTitleWidget(
              title: widget.item['custName'] ?? '',
              size: Status.MINI,
              ellipsis: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '订:',
                          style: CRMText.smallText,
                        ),
                        Text(
                          '￥${widget.item['totalAmount'] ?? ""}',
                          style: CRMText.smallBoldText,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '实:',
                                style: CRMText.smallText,
                              ),
                              Text(
                                '￥${widget.item['actualAmount'] ?? ""}',
                                style: CRMText.smallBoldText,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.item['publishTime'] ?? '',
                    style: CRMText.smallText,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
