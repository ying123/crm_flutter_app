import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';

import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:flutter/material.dart';

class ReturnItemWidget extends StatefulWidget {
  final Map returnInfo;
  final int index;
  final bool isExchange;
  final bool hasAuthForRate;
  ReturnItemWidget(this.returnInfo, this.index,
      {Key key, this.isExchange = false, this.hasAuthForRate = false})
      : super(key: key);

  _ReturnItemWidgetState createState() => _ReturnItemWidgetState();
}

class _ReturnItemWidgetState extends State<ReturnItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isExchange) {
          Utils.trackEvent('exchange_details');
          CRMNavigator.goExchangeDetailsPage(widget.returnInfo["return_id"],
              hasAuthForRate: widget.hasAuthForRate);
        } else {
          Utils.trackEvent('return_details');
          CRMNavigator.goReturnDetailsPage(widget.returnInfo["return_id"],
              hasAuthForRate: widget.hasAuthForRate);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: widget.index == 0 ? 0 : CRMGaps.gap_dp10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DarkTitleWidget(
              size: Status.MINI,
              title: '${widget.returnInfo['return_code'] ?? ''}',
              titleStyle: CRMText.normalText,
              subtitle: '${widget.returnInfo['partner_status'] ?? ''}',
              subtitleColor: CRMColors.primary,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CRMGaps.gap_dp12, horizontal: CRMGaps.gap_dp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                        child: CrmClip(
                          text: '${widget.returnInfo['org_name'] ?? ''}',
                          child: Text(
                            '${widget.returnInfo['org_name'] ?? ''}',
                            style: TextStyle(
                                color: CRMColors.textDark,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                      child: Text(
                        '${widget.returnInfo['car_brand_name']} ${widget.returnInfo['car_type'] ?? ''} ${widget.returnInfo['car_type'] != null && widget.returnInfo['car_system'] != null ? '/' : ''} ${widget.returnInfo['car_system'] ?? ''}',
                        style: TextStyle(
                            fontSize: CRMText.normalTextSize,
                            color: CRMColors.textLight),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                        child: CrmClip(
                          text: widget.returnInfo['parts_name'] ?? '',
                          child: Text(
                            "配件名称：${widget.returnInfo['parts_name'] ?? ''}",
                            style: CRMText.normalText,
                          ),
                        )),
                    Text(
                      '配件数量：${widget.returnInfo['parts_num']}',
                      style: CRMText.normalText,
                    ),
                  ],
                )),
            CRMBorder.dividerDp1,
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: CRMGaps.gap_dp12, horizontal: CRMGaps.gap_dp16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '售后管家：',
                          style: CRMText.smallText,
                        ),
                        Text(
                          widget.returnInfo['advise_status'] ?? '',
                          style: TextStyle(
                              color: widget.returnInfo['advise_status'] == '通过'
                                  ? CRMColors.success
                                  : CRMColors.danger,
                              fontSize: CRMText.smallTextSize),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.returnInfo['create_time'] ?? '',
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
