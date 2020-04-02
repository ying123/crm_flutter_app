import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenFit {
  static void init(context) {
    // 初始化，width与height为设计稿的实际宽高
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }

  static double height(double value) {
    return ScreenUtil.getInstance().setHeight(value);
  }

  static double width(double value) {
    return ScreenUtil.getInstance().setWidth(value);
  }

  static double onepx() {
    return 1 / ScreenUtil.pixelRatio;
  }
}
