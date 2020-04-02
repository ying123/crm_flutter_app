import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class TitleValueRich extends StatelessWidget {
  final title;
  final value;
  final Color titleColor;
  final Color valueColor;
  final bool noBottomSpace;
  final bool topSpace;
  final bool showQuestionIcon;
  final Function onQuestionIconTap;
  const TitleValueRich(
      {Key key,
      this.title,
      this.noBottomSpace = false,
      this.onQuestionIconTap,
      this.showQuestionIcon = false,
      this.titleColor,
      this.topSpace = false,
      this.value,
      this.valueColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: noBottomSpace ? 0 : CRMGaps.gap_dp10,
          top: topSpace ? CRMGaps.gap_dp8 : 0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            text: title.toString(),
            style: TextStyle(
                color: titleColor ?? CRMColors.textNormal,
                fontSize: CRMText.normalTextSize),
            children: [
              TextSpan(
                text: value.toString(),
                style: TextStyle(
                    color: valueColor ?? CRMColors.textNormal,
                    fontSize: CRMText.normalTextSize),
              )
            ]),
      ),
    );
  }
}
