import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:flutter/material.dart';

class PermissionModel with ChangeNotifier {
  List _permission = [];

  ///获取用户功能权限
  Future<void> getPermission() async {
    ResultDataModel res = await httpGet(Apis.permission, showLoading: true);
    if (res.code == 0) {
      _permission = res.data;
      notifyListeners();
    }
  }

  List get permission => _permission;
}
