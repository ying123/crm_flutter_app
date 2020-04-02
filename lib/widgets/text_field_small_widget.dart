import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget smallTextFieldWidget(TextEditingController controller,
    {String hintText = '',
    bool enabled = true,
    bool autofocus = false,
    double width,
    TextInputType keyboardType}) {
  return Container(
    height: 20,
    width: width ?? ScreenFit.width(224),
    child: Center(
      child: TextField(
          keyboardAppearance: Brightness.light,
          keyboardType: keyboardType ?? null,
          enabled: enabled,
          autofocus: autofocus,
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: -4),
              border: InputBorder.none,
              hintText: '$hintText',
              hintStyle: TextStyle(
                  fontSize: CRMText.normalTextSize,
                  color: CRMColors.textLighter)),
          style: CRMText.normalText),
    ),
  );
}
