import 'package:flutter/material.dart';

class NoticesModel with ChangeNotifier {
  List _notices = [];

  List get notices => _notices;
  set notices(newVal) {
    if (_notices != newVal) {
      _notices = newVal;
      notifyListeners();
    }
  }

  /// 未读数
  int get unReadNoticeCount {
    return notices.where((notice) => notice['read'] == 0).toList().length;
  }

  /// 设置某通知已读
  void setNoticeRead(int index) {
    if (_notices.length > index) {
      _notices[index]['read'] = 1;
      notifyListeners();
    }
  }
}
