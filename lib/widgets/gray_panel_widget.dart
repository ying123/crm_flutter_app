import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

///询价单详情灰色详情
class GrayPanelWidget extends StatelessWidget {
  final Widget content; // 主要内容显示
  final GestureTapCallback onXiaobaTap; // 点击联系客服回调，有传入则显示联系客服按钮，不传入则不显示
  GrayPanelWidget(this.content, {Key key, this.onXiaobaTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: CRMColors.commonBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: CRMGaps.gap_dp16,
                  left: CRMGaps.gap_dp16,
                  right: CRMGaps.gap_dp16,
                  bottom: onXiaobaTap != null ? 0 : CRMGaps.gap_dp16),
              child: Row(
                children: <Widget>[
                  Expanded(child: content),
                ],
              ),
            ),
            if (onXiaobaTap != null)
              Column(
                children: <Widget>[
                  CRMBorder.dividerDp1Dark,
                  InkWell(
                    onTap: onXiaobaTap,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CRMIcons.xiaoba,
                            size: ScreenFit.width(40),
                            color: CRMColors.textNormal,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            '联系客服',
                            style: TextStyle(
                                fontSize: CRMText.normalTextSize,
                                color: CRMColors.textNormal),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
          ],
        ));
  }
}
