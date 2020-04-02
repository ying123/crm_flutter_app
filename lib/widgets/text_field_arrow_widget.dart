import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

Widget textFieldArrowWidget(
    {String title = '',
    String value = '',
    String hintText = '',
    GestureTapCallback onTap}) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp12),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                width: ScreenFit.onepx(), color: CRMColors.borderLight))),
    child: Row(
      children: <Widget>[
        Text(title, style: CRMText.mainTitleText),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                value == null
                    ? Text(
                        hintText,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: CRMText.normalTextSize,
                            color: CRMColors.textLighter),
                      )
                    : Text(
                        value,
                        textAlign: TextAlign.right,
                        style: CRMText.normalText,
                      ),
                SizedBox(
                  width: CRMGaps.gap_dp8,
                ),
                Icon(
                  CRMIcons.right_arrow,
                  size: 12,
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
