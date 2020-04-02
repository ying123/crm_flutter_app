import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:flutter/material.dart';

Widget titleValueWidget(
    {var title,
    var value = '',
    Color titleColor,
    Color valueColor,
    bool noBottomSpace = false,
    bool topSpace = false,
    bool showQuestionIcon = false,
    double textSize = CRMText.normalTextSize,
    Function onQuestionIconTap}) {
  return Padding(
    padding: EdgeInsets.only(
        bottom: noBottomSpace ? 0 : CRMGaps.gap_dp10,
        top: topSpace ? CRMGaps.gap_dp8 : 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toString(),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: titleColor ?? CRMColors.textNormal, fontSize: textSize),
        ),
        Offstage(
            offstage: !showQuestionIcon,
            child: Padding(
              padding: EdgeInsets.only(right: CRMGaps.gap_dp10),
              child: InkWell(
                onTap: onQuestionIconTap,
                child: Icon(
                  CRMIcons.question,
                  color: CRMColors.textLight,
                  size: 16,
                ),
              ),
            )),
        if (value != '' && value != null)
          Expanded(
              child: CrmClip(
            text: value.toString(),
            child: Text(
              value.toString(),
              style: TextStyle(
                  color: valueColor ?? CRMColors.textNormal,
                  fontSize: textSize),
            ),
          ))
      ],
    ),
  );
}
