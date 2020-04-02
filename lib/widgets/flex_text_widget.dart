import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:flutter/material.dart';

class FlexTextWidget extends StatelessWidget {
  final String leftTitle;
  final leftValue;
  final String rightTitle;
  final rightValue;
  final Color titleColor;
  final Color valueColor;
  final bool noBottomSpace;
  final bool rightClipable;
  FlexTextWidget(
      {Key key,
      @required this.leftTitle,
      this.leftValue = '',
      this.rightTitle,
      this.rightValue = '',
      this.titleColor,
      this.valueColor,
      this.noBottomSpace = false,
      this.rightClipable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: noBottomSpace ? 0 : CRMGaps.gap_dp10,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  leftTitle.toString(),
                  maxLines: 1,
                  style: TextStyle(
                      color: titleColor ?? CRMColors.textNormal,
                      fontSize: CRMText.normalTextSize),
                ),
                Text(
                  leftValue.toString(),
                  maxLines: 1,
                  style: TextStyle(
                      color: valueColor ?? CRMColors.textNormal,
                      fontSize: CRMText.normalTextSize),
                )
              ],
            ),
          ),
          Expanded(
              child: Row(
            children: <Widget>[
              Text(
                rightTitle.toString(),
                style: TextStyle(
                    color: titleColor ?? CRMColors.textNormal,
                    fontSize: CRMText.normalTextSize),
              ),
              CrmClip(
                text: rightClipable ? rightValue.toString() : '',
                child: Text(
                  rightValue.toString(),
                  style: TextStyle(
                      color: valueColor ?? CRMColors.textNormal,
                      fontSize: CRMText.normalTextSize),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
