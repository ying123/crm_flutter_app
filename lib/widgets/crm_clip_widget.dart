import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrmClip extends StatelessWidget {
  final String text;
  final Widget child;
  CrmClip({this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (text == '') return;
        Clipboard.setData(ClipboardData(text: text));
        Utils.showToast('已复制');
      },
      child: child,
    );
  }
}
