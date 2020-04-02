// 共用常量
import 'package:crm_flutter_app/config/env.dart';
import 'package:flutter/foundation.dart';

class Constant {
  static const ISDEBUG = !kReleaseMode; //是否为debug模式
  static const String MTAIOSAPPKEY = 'IG7ULMAM646R'; // ios MTA appkey
  static const String MTAANDROIDAPPKEY = 'AF5XQR6A8H4E'; // andriod MTA appkey
  static const String SENTRYDSN =
      // 从页面`http://sentry.qipeipu.net/settings/Trade/crm_flutter_app/keys/`复制后要将`net`改成`com`
      'http://fec5cbb02fc34f09a3dfb499cc394d2f@sentry.qipeipu.com/32'; // andriod MTA appkey
  static bool get isProductEnv {
    return !ISDEBUG && isProduction;
  }
}
