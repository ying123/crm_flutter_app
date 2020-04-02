import 'package:flutter/material.dart';

Widget whitePanelWidget({Widget child, noTopMargin = false}) {
  return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(top: noTopMargin ? 0 : 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: child);
}
