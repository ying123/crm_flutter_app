import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///页面入口item
Widget linkCellWidget(
    {IconData leading,
    @required String title,
    String subTitle,
    GestureTapCallback tapCallback,
    String size = Status.NORMAL,
    bool showRightArrow = true}) {
  return Column(
    children: <Widget>[
      Container(
          color: Colors.white,
          height: size == Status.MINI ? 40 : 48,
          child: InkWell(
            onTap: tapCallback,
            child: Flex(
              direction: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: CRMGaps.gap_dp16,
                ),
                Offstage(
                  offstage: leading == null,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      leading,
                      size: 16,
                      color: CRMColors.textNormal,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: CrmClip(
                      text: title ?? '',
                      child: Text(
                        title ?? '',
                        style: CRMText.normalText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                Offstage(
                  offstage: subTitle == null,
                  child: Padding(
                    padding: EdgeInsets.only(right: CRMGaps.gap_dp10),
                    child: Text(
                      subTitle ?? '',
                      style: CRMText.normalText,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Offstage(
                  offstage: !showRightArrow,
                  child: Padding(
                      padding: EdgeInsets.only(right: CRMGaps.gap_dp16),
                      child: Icon(
                        CupertinoIcons.right_chevron,
                        color: CRMColors.textLight,
                      )),
                ),
              ],
            ),
          )),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: CRMBorder.dividerDp1,
      ),
    ],
  );
}
