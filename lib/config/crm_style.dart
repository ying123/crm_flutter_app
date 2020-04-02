import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class CRMColors {
  CRMColors._();

  static const Color primary = Color(0xFF3D7EFF); // 主题颜色
  static const Color primaryApla10 = Color(0x193D7EFF); // 主题颜色

  static const Color textDark = Color(0xFF222222); //突出内容
  static const Color textDarkLight = Color(0xFF333333); //突出内容
  static const Color textNormal = Color(0xFF555555); //正文内容
  static const Color textLight = Color(0xFF888888); //辅助内容
  static const Color textLighter = Color(0xFF9B9B9B);

  static const Color blueDark = Color(0xFF2E82FF);
  static const Color blueNormal = Color(0xFF3AAEFF);
  static const Color blueLight = Color(0xFFEBF2FF);

  static const Color danger = Color(0xFFF22222); // 红（严重警告，状态）
  static const Color warning = Color(0xFFFEA622); // 橙（一般警告，状态）
  static const Color warningLight = Color(0xFFFEE4BC); //辅助底色（警告底）
  static const Color warningLightApla = Color(0x99FEE4BC); //20%透明度辅助底色（警告底）
  static const Color success = Color(0xFF33CC55); // 辅助绿（通过/正向状态）
  static const Color purple = Color(0xff8280FF); // 紫色

  static const Color border = Color(0xFFDDDDDD);
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFFCCCCCC);

  static const Color commonBg = Color(0xFFF5F5F5);
  static const Color gradientDarkBlue = Color(0xFF3D7EFF);
  static const Color gradientLightBlue = Color(0xFF5F98FA);
  static const Color cardBgDarkBlue = Color(0x1890FF00);
  static const Color shawdowGrey = Color(0xFFE7E7E7);
  static const Color gradientLightYellow = Color(0xFFFFF4E5);
}

class CRMText {
  CRMText._();
  static const hugeTextSize = 18.0;
  static const largeTextSize = 15.0;
  static const normalTextSize = 14.0;
  static const smallTextSize = 12.0;

  // tab字体
  static const tabText = const TextStyle(
    color: CRMColors.textLight,
    fontSize: largeTextSize,
    fontWeight: FontWeight.normal,
  );
  //tab选中字体
  static const tabActiveText = const TextStyle(
    color: CRMColors.primary,
    fontSize: largeTextSize,
    fontWeight: FontWeight.normal,
  );

  // 加粗字体
  static const mainTitleText = const TextStyle(
    color: CRMColors.textNormal,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  /// 橙色常规字体
  static const normalOrangeText = const TextStyle(
      color: CRMColors.warning,
      fontSize: normalTextSize,
      fontWeight: FontWeight.normal,
      height: 1.2);

  ///常规字体
  static const normalText = const TextStyle(
      color: CRMColors.textNormal,
      fontSize: normalTextSize,
      fontWeight: FontWeight.normal,
      height: 1.2);

  ///常规浅色字体
  static const normalLighterText = const TextStyle(
      color: CRMColors.textLighter, fontWeight: FontWeight.normal, height: 1.2);

  /// 浅色小字体
  static const smallText = const TextStyle(
    color: CRMColors.textLight,
    fontSize: smallTextSize,
    fontWeight: FontWeight.normal,
  );

  /// 浅色加粗小字体
  static const smallBoldText = const TextStyle(
    color: CRMColors.textLight,
    fontSize: smallTextSize,
    fontWeight: FontWeight.bold,
  );

  /// 加粗黑色字体
  static const boldTitleText = const TextStyle(
    color: CRMColors.textDark,
    fontSize: hugeTextSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bottomButtonText({Color color = Colors.white}) => TextStyle(
      color: color, fontSize: hugeTextSize, fontWeight: FontWeight.normal);
}

///间距
class CRMGaps {
  CRMGaps._();
  static const double gap_dp30 = 30.0;
  static const double gap_dp26 = 26.0;
  static const double gap_dp20 = 20.0;
  static const double gap_dp10 = 10.0;
  static const double gap_dp16 = 16.0;
  static const double gap_dp14 = 14.0;
  static const double gap_dp12 = 12.0;
  static const double gap_dp8 = 8.0;
  static const double gap_dp4 = 4.0;
}

///圆角
class CRMRadius {
  CRMRadius._();
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius10 = 10.0;
  static const double radius16 = 16.0;
}

class CRMBorder {
  CRMBorder._();
  static Widget dividerDp1 = Divider(
    height: ScreenFit.onepx(),
    color: CRMColors.borderLight,
  );

  static Widget dividerDp1Dark = Divider(
    height: ScreenFit.onepx(),
    color: CRMColors.borderDark,
  );
}

class CRMIcons {
  CRMIcons._();
  static const String fontFamily = 'CRMIcons';

  static const IconData home = const IconData(0xe650, fontFamily: fontFamily);
  static const IconData home_active =
      const IconData(0xe652, fontFamily: fontFamily);

  static const IconData order = const IconData(0xe649, fontFamily: fontFamily);
  static const IconData order_active =
      const IconData(0xe667, fontFamily: fontFamily);

  static const IconData result = const IconData(0xe65d, fontFamily: fontFamily);
  static const IconData result_active =
      const IconData(0xe65f, fontFamily: fontFamily);

  static const IconData mine = const IconData(0xe655, fontFamily: fontFamily);
  static const IconData mine_active =
      const IconData(0xe656, fontFamily: fontFamily);

  static const IconData select = const IconData(0xe65b, fontFamily: fontFamily);

  static const IconData right = const IconData(0xe65e, fontFamily: fontFamily);

  static const IconData back = const IconData(0xe663, fontFamily: fontFamily);

  static const IconData expand = const IconData(0xe662, fontFamily: fontFamily);
  static const IconData pickup = const IconData(0xe6bc, fontFamily: fontFamily);
  static const IconData qrcode = const IconData(0xe647, fontFamily: fontFamily);
  static const IconData speaker =
      const IconData(0xe644, fontFamily: fontFamily);
  static const IconData message =
      const IconData(0xe659, fontFamily: fontFamily);
  static const IconData filter = const IconData(0xe64c, fontFamily: fontFamily);
  static const IconData question =
      const IconData(0xe658, fontFamily: fontFamily);

  static const IconData unchecked =
      const IconData(0xe669, fontFamily: fontFamily);
  static const IconData checked =
      const IconData(0xe660, fontFamily: fontFamily);
  static const IconData privacy =
      const IconData(0xe661, fontFamily: fontFamily);
  static const IconData about = const IconData(0xe646, fontFamily: fontFamily);
  static const IconData feedbackout =
      const IconData(0xe642, fontFamily: fontFamily);
  static const IconData cost = const IconData(0xe668, fontFamily: fontFamily);

  static const IconData add = const IconData(0xe65c, fontFamily: fontFamily);
  static const IconData edit = const IconData(0xe643, fontFamily: fontFamily);
  static const IconData down_arrow =
      const IconData(0xe662, fontFamily: fontFamily);
  static const IconData right_arrow =
      const IconData(0xe65b, fontFamily: fontFamily);

  static const IconData delete = const IconData(0xe67d, fontFamily: fontFamily);
  static const IconData tips = const IconData(0xe653, fontFamily: fontFamily);

  static const IconData user = const IconData(0xe671, fontFamily: fontFamily);
  static const IconData phone = const IconData(0xe675, fontFamily: fontFamily);
  static const IconData xiaoba = const IconData(0Xe63b, fontFamily: fontFamily);

  static const IconData inqury = const IconData(0xe674, fontFamily: fontFamily);
  static const IconData credit = const IconData(0xe673, fontFamily: fontFamily);
  static const IconData address =
      const IconData(0Xe672, fontFamily: fontFamily);
  static const IconData share = const IconData(0xe677, fontFamily: fontFamily);
  static const IconData link = const IconData(0xe676, fontFamily: fontFamily);
  static const IconData close = const IconData(0xe648, fontFamily: fontFamily);
  static const IconData logout = const IconData(0xe68f, fontFamily: fontFamily);
  static const IconData search = const IconData(0xe68e, fontFamily: fontFamily);
  static const IconData workOrderAdd =
      const IconData(0xe665, fontFamily: fontFamily);
  static const IconData workOrderHome =
      const IconData(0xe691, fontFamily: fontFamily);
  static const IconData performance =
      const IconData(0xe664, fontFamily: fontFamily);

  static const IconData inquiryIcon =
      const IconData(0xe6b7, fontFamily: fontFamily);
  static const IconData baoIcon =
      const IconData(0xe6b8, fontFamily: fontFamily);
  static const IconData price4s =
      const IconData(0xe6b9, fontFamily: fontFamily);
  static const IconData export = const IconData(0xe635, fontFamily: fontFamily);
  static const IconData transport =
      const IconData(0xe634, fontFamily: fontFamily);
  static const IconData tuidan = const IconData(0xe633, fontFamily: fontFamily);
  static const IconData import = const IconData(0xe631, fontFamily: fontFamily);
  static const IconData check = const IconData(0xe632, fontFamily: fontFamily);
}
