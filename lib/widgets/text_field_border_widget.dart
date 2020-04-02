import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

Widget borderTextFieldWidget(TextEditingController controller,
    {int minLines = 1,
    int maxLines = 1,
    int color,
    String hintText,
    TextInputType keyboardType,
    ValueChanged<String> onChanged}) {
  return Container(
    decoration: BoxDecoration(
      color: color != null ? Color(color) : Colors.white,
      borderRadius: BorderRadius.circular(CRMRadius.radius4),
      border: Border.all(color: CRMColors.commonBg),
    ),
    child: TextField(
        controller: controller,
        style: CRMText.normalText,
        onChanged: onChanged,
        keyboardType: keyboardType ?? null,
        keyboardAppearance: Brightness.light,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? '',
            hintStyle: TextStyle(
                color: CRMColors.textLighter, fontSize: CRMText.smallTextSize),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
        minLines: minLines,
        maxLines: maxLines),
  );
}
