import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:crm_flutter_app/widgets/icon_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInfoWidget extends StatefulWidget {
  final dynamic orgName; // 汽修厂名称
  final dynamic phone; // 电话
  final dynamic contact; // 联系人
  final String customerId;
  final orgId;
  final bool isInsurance; //是否是保险客户
  final bool isGroup; // 是否是集团客户
  final Widget rightWidget;
  CustomerInfoWidget(
      {this.contact,
      this.orgName,
      this.phone,
      this.customerId,
      this.orgId,
      this.isGroup = false,
      this.rightWidget,
      this.isInsurance = false});

  @override
  _CustomerInfoWidgetState createState() => _CustomerInfoWidgetState();
}

class _CustomerInfoWidgetState extends State<CustomerInfoWidget> {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('拨打电话失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CRMNavigator.goCustomerInfoPage(widget.customerId,
            widget.orgId is int ? widget.orgId : int.parse(widget.orgId));
      },
      child: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
            ScreenFit.width(32), ScreenFit.width(20), 0, ScreenFit.width(20)),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        if (widget.isInsurance)
                          Padding(
                            padding: EdgeInsets.only(right: CRMGaps.gap_dp8),
                            child: Image.asset(
                              'assets/images/insurance.png',
                              width: ScreenFit.width(35),
                            ),
                          ),
                        if (widget.isGroup)
                          Padding(
                            padding: EdgeInsets.only(right: CRMGaps.gap_dp8),
                            child: Image.asset(
                              'assets/images/group.png',
                              width: ScreenFit.width(50),
                            ),
                          ),
                        Expanded(
                          child: CrmClip(
                            text: widget.orgName ?? '',
                            child: Text(
                              widget.orgName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: CRMText.mainTitleText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      if (widget.contact != null)
                        IconTitleWidget(CRMIcons.user, widget.contact ?? ''),
                    ],
                  )
                ],
              ),
            ),
            if (widget.rightWidget != null) widget.rightWidget,
            IconButton(
              icon: Icon(CRMIcons.phone),
              iconSize: ScreenFit.width(40),
              color: CRMColors.textNormal,
              onPressed: () => _makePhoneCall('tel:${widget.phone}'),
            ),
          ],
        ),
      ),
    );
  }
}
