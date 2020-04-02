import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class IconTitleWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  IconTitleWidget(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: ScreenFit.width(30),
        ),
        SizedBox(
          width: ScreenFit.width(12),
        ),
        Text(
          '$title',
          style: TextStyle(
              color: CRMColors.textLight, fontSize: CRMText.normalTextSize),
        ),
        SizedBox(
          width: ScreenFit.width(32),
        ),
      ],
    );
  }
}
