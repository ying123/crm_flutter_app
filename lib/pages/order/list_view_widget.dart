import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/pages/order/order_item_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class OrderListViewWidget extends StatefulWidget {
  final StreamController streamController;
  final int documentaryTabIndex;
  OrderListViewWidget(
      {Key key, this.streamController, this.documentaryTabIndex})
      : super(key: key);

  _OrderListViewWidgetState createState() => _OrderListViewWidgetState();
}

class _OrderListViewWidgetState extends State<OrderListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  Map<String, dynamic> commonParams = {
    'orderNo': '',
    'custName': '',
    'provinceId': '',
    'cityId': '',
    'countyId': '',
    'payStartTime': '',
    'payEndTime': '',
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadErrorOrderList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 加载异常列表
  _loadErrorOrderList() async {
    ResultDataModel res = await httpGet(Apis.ErrorOrderList,
        queryParameters: {...commonParams}, showLoading: true);
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._list = res.data;
        });
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    //如果跟单页的tab不是订单，那么不刷新
    if (widget.documentaryTabIndex != null && widget.documentaryTabIndex != 0) {
      return;
    }
    await _loadErrorOrderList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: CRMColors.primary,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _list.isNotEmpty ? _list.length : 1,
          itemBuilder: (BuildContext context, int index) {
            return _list.isNotEmpty
                ? Column(
                    children: <Widget>[
                      OrderItemWidget('abnormalType', _list[index]),
                      if (index == this._list.length - 1)
                        LoadingCompleteWidget()
                    ],
                  )
                : NoDataWidget();
          },
        ));
  }
}
