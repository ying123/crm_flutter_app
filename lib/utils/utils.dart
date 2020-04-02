import 'package:crm_flutter_app/config/common.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mta/mta.dart';

class Utils {
  static String getImgPath(String name, {String format: '.png'}) {
    return 'assets/images/$name$format';
  }

  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("$msg")),
    );
  }

  static Future<bool> showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: CRMText.normalTextSize,
        gravity: ToastGravity.CENTER);
  }

  static void trackEvent(String eventName) {
    if (Constant.isProductEnv) {
      Mta.trackEvent(eventName);
    }
  }
}
