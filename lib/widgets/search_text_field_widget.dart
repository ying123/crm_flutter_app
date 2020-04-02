import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget searchTextFieldWidget(controller,
    {hintText = '搜索客户信息', callback}) {
  Timer _debounce;
  return PreferredSize(
    preferredSize: Size.fromHeight(48),
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: CRMGaps.gap_dp30, vertical: CRMGaps.gap_dp8),
      child: Container(
        padding: EdgeInsets.only(left: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CRMColors.commonBg),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          onChanged: (text) {
            if (_debounce?.isActive ?? false) _debounce.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              callback(text);
            });
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.search,
              ),
              hintText: hintText ?? '',
              hintStyle: TextStyle(
                  color: CRMColors.textLighter,
                  fontSize: CRMText.smallTextSize),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4)),
        ),
      ),
    ),
  );
}
