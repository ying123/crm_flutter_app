import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class EllipsisTitleWidget extends StatelessWidget {
  final String _title;
  final String value;
  final bool isDark;
  EllipsisTitleWidget(this._title, {Key key, this.value, this.isDark = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: ScreenFit.width(32)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: CRMColors.borderLight, width: ScreenFit.onepx()))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _title,
              style: isDark ? CRMText.mainTitleText : CRMText.normalText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(value ?? ''),
        ],
      ),
    );
  }
}
