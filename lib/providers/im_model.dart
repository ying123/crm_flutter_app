import 'package:flutter/material.dart';

class ImModel with ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  /// 小巴未读消息数
  set unreadCount(int newVal) {
    if (_unreadCount != newVal) {
      _unreadCount = newVal;
      notifyListeners();
    }
  }
}
