import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

Widget blueTitleCard(String title,
    {Widget child, bool noSpace = false, bool border = false}) {
  return Container(
    decoration: border
        ? BoxDecoration(
            border: Border.all(
                width: ScreenFit.onepx(), color: CRMColors.borderLight),
            borderRadius: BorderRadius.circular(CRMRadius.radius8))
        : null,
    child: Column(
      children: <Widget>[
        blueTitle(title),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          width: double.infinity,
          padding: noSpace
              ? null
              : EdgeInsets.fromLTRB(0, CRMGaps.gap_dp10, 0, CRMGaps.gap_dp12),
          child: child,
        )
      ],
    ),
  );
}

///蓝色标题
Widget blueTitle(String title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
        horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
    decoration: BoxDecoration(
        color: CRMColors.blueLight,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
    child: Text(title),
  );
}
