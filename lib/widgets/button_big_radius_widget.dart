import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class ButtonBigRadiusWidget extends StatelessWidget {
  final String title;
  final Color color;
  final double width;
  final VoidCallback onPressed;
  ButtonBigRadiusWidget(
      {@required this.title, this.color, @required this.onPressed, this.width})
      : assert(title != null),
        assert(onPressed != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenFit.width(width ?? 120),
      height: 26,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          color: color ?? CRMColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CRMRadius.radius16),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: CRMText.smallTextSize,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          onPressed: onPressed),
    );
  }
}
