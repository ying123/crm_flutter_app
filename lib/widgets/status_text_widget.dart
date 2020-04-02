import 'package:flutter/material.dart';

Widget statusTextWidget(String _title, Color _status) {
  return Text(
    _title,
    style: TextStyle(color: _status),
  );
}
