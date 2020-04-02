import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/providers/im_model.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notice_icon.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final Color backgroundColor;
  final PreferredSizeWidget bottom;
  final Widget leading;
  final List<Widget> actions;
  final XiaobaQueryModel xiaobaQuery;
  final Color color;
  final Brightness brightness;
  final double elevation;
  const AppbarWidget(
      {this.title,
      this.backgroundColor = Colors.white,
      this.color = CRMColors.textNormal,
      this.bottom,
      this.leading,
      this.actions,
      this.xiaobaQuery,
      this.elevation = 0,
      this.automaticallyImplyLeading = true,
      this.brightness});
  void _goXiaobaPage() {
    Utils.trackEvent('customer_service_history');
    XiaobaQueryModel xiaoba = XiaobaQueryModel(toPage: 'session');
    CRMNavigator.goXiaobaPage(xiaobaQuery ?? xiaoba);
  }

  List<Widget> get actionsList => [
        Consumer<ImModel>(
          builder: (context, imModel, child) {
            return NoticeIcon(
              count: imModel.unreadCount,
              child: IconButton(
                onPressed: () {
                  _goXiaobaPage();
                },
                icon: Icon(
                  CRMIcons.message,
                  size: ScreenFit.width(48),
                ),
              ),
            );
          },
        ),
        if (actions != null) ...actions,
      ];

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(
              color: color == Colors.white ? color : CRMColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        centerTitle: false,
        elevation: elevation != null ? elevation : 0,
        shape: bottom != null
            ? Border(
                bottom: BorderSide(
                    color: CRMColors.borderLight, width: ScreenFit.onepx()))
            : null,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
        brightness: brightness ?? Brightness.light,
        iconTheme: IconThemeData(
          color: color, //change your color here
        ),
        bottom: bottom,
        leading: leading,
        actions: actionsList);
  }

  @override
  Size get preferredSize {
    double height = bottom == null ? 48.0 : 48.0 + 40.0;
    return new Size.fromHeight(height);
  }
}
