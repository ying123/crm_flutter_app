import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  AlertDialogWidget({Key key, this.title, this.onCancel, this.onConfirm})
      : super(key: key);

  final String title; // 弹窗内容
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          '温馨提示',
          style: TextStyle(
            fontSize: CRMText.hugeTextSize,
            color: CRMColors.textNormal,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    color: CRMColors.textLight,
                    fontSize: CRMText.largeTextSize),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text(
            '取消',
            style: TextStyle(color: CRMColors.textLight),
          ),
          onPressed: () {
            onCancel();
            rootNavigatorState.pop();
          },
        ),
        FlatButton(
          child: Text(
            '确定',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            onConfirm();
            rootNavigatorState.pop();
          },
        ),
      ],
    );
  }
}
