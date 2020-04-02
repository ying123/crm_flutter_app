import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkTitleWidget extends StatelessWidget {
  //主标题（左侧文字）
  final String title;
  //标题类型： dark, normal
  final String type;
  final String size;
  final TextStyle titleStyle;
  //副标题（右侧文字）
  final String subtitle;
  //副标题颜色
  final Color subtitleColor;
  final double subtitleFontSize;
  final Widget trailing;
  final GestureTapCallback onTitleTap;
  final bool ellipsis;

  DarkTitleWidget(
      {Key key,
      this.title,
      this.type,
      this.size = Status.NORMAL,
      this.titleStyle,
      this.subtitle,
      this.subtitleColor,
      this.subtitleFontSize,
      this.trailing,
      this.ellipsis = false,
      this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size == Status.MINI ? 40 : 48,
      padding: EdgeInsets.symmetric(horizontal: ScreenFit.width(32)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: CRMColors.borderLight, width: ScreenFit.onepx()))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: onTitleTap ?? null,
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: title));
                Utils.showToast('已复制');
              },
              child: Text(
                title,
                overflow: ellipsis ? TextOverflow.ellipsis : null,
                style: titleStyle != null
                    ? titleStyle
                    : (type == Status.LIGHT
                        ? CRMText.smallText
                        : CRMText.mainTitleText),
              ),
            ),
          ),
          Offstage(
            offstage: subtitle == null,
            child: Text(
              '$subtitle',
              style: TextStyle(
                  color: subtitleColor != null
                      ? subtitleColor
                      : CRMColors.textNormal,
                  fontSize: subtitleFontSize ?? CRMText.smallTextSize),
            ),
          ),
          Offstage(
            offstage: trailing == null,
            child: trailing,
          ),
        ],
      ),
    );
  }
}
