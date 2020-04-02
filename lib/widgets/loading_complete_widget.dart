import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class LoadingCompleteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 18),
        child: Text("我是有底线的", style: CRMText.normalText),
      ),
    );
  }
}
