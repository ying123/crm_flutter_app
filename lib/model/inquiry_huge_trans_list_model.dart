import 'dart:convert';

import 'package:crm_flutter_app/providers/provider_base_model.dart';
import 'package:dio/dio.dart';

class InuiqryHugeTransListModel extends BaseModel {
  List list = new List();

  Future getData(int _page) async {
    setBusy(true);
    var apiUrl =
        "http://www.phonegap100.com/appapi.php?a=getPortalList&catid=20&page=$_page";
    var response = await Dio().get(apiUrl);
    var res = json.decode(response.data)["result"];
    list.addAll(res);
    setBusy(false);
  }
}
