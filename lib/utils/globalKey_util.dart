import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

NavigatorState get rootNavigatorState {
  return rootNavigatorKey.currentState;
}
