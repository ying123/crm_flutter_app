import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

Widget statusItemWidget({String title, int status}) {
  return Container(
    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
    decoration: BoxDecoration(
      color: status == 2
          ? CRMColors.success
          : CRMColors.danger,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Text(
      '$title',
      style: TextStyle(color: Colors.white, fontSize: CRMText.smallTextSize),
    ),
  );
}
