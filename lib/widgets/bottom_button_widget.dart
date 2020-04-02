import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class BottomButtonWidget extends StatelessWidget {
  final double height;
  final double minWidth;
  final bool showConfirmButton;

  /// 主按钮文本
  final String text;

  /// 主按钮回调
  final VoidCallback onPressed;
  final String secondaryText;
  final VoidCallback secondaryOnPressed;

  BottomButtonWidget(
      {Key key,
      this.height = 48.0,
      this.minWidth = 60.0,
      @required this.text,
      @required this.onPressed,

      /// 次要的，浅色的文本
      this.secondaryText,
      this.secondaryOnPressed,
      this.showConfirmButton = true})
      : assert(text != null),
        assert(text.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Theme(
        data: Theme.of(context).copyWith(
          buttonTheme: ButtonThemeData(height: height, minWidth: minWidth),
        ),
        child: Row(
          children: <Widget>[
            if (secondaryText != null && secondaryText.isNotEmpty)
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Text(
                    secondaryText,
                    style: CRMText.bottomButtonText(color: CRMColors.textLight),
                  ),
                  onPressed: secondaryOnPressed,
                ),
              ),
            if (showConfirmButton)
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: CRMColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Text(
                    text,
                    style: CRMText.bottomButtonText(),
                  ),
                  onPressed: onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
