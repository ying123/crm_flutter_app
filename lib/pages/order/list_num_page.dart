import 'dart:async';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

import 'package:crm_flutter_app/model/order_list_model.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';

class OrderNumListViewWidget extends StatefulWidget {
  final StreamController streamController;
  OrderNumListViewWidget({Key key, this.streamController}) : super(key: key);

  _OrderNumListViewWidgetState createState() => _OrderNumListViewWidgetState();
}

class _OrderNumListViewWidgetState extends State<OrderNumListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  int _page = 0;
  int _pageSize = 10;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // this._getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getData({page}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      _page = page;
      _list = [];
      _hasMore = true;
    }
    if (this._hasMore) {
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      var res;
      ResultDataModel resultDataModel =
          await httpGet(Apis.OrderList, queryParameters: {
        "pageIndex": this._page,
        "pageSize": 10,
      });
      setState(() {
        _loading = false;
      });
      if (resultDataModel.code == 0) {
        res = resultDataModel.data.map((item) => OrderListModel.fromJson(item));

        if (this.mounted) {
          setState(() {
            this._list.addAll(res); //拼接
            this._page++;
          });
          //判断是否是最后一页
          if (res.length < this._pageSize) {
            setState(() {
              this._hasMore = false;
            });
          }
        }
      } else {
        Utils.showToast(resultDataModel.msg);
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    await _getData(page: 0);
  }

  // more or complete widget
  Widget _getMoreWidget() {
    if (_hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppbarWidget(
        title: '未支付订单',
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                child: IconButton(
                  icon: Icon(
                    CRMIcons.filter,
                    size: ScreenFit.width(42),
                  ),
                  onPressed: CRMNavigator.goOrderFilterPage,
                ),
              )
            ],
          ),
        ],
      ),
      body: this._list.isNotEmpty
          ? PullRefreshWidget(_list, (context, index) {
              if (index == this._list.length - 1) {
                //列表渲染到最后一条的时候加一个圈圈
                //拉到底
                return Column(
                  children: <Widget>[
                    // OrderItemWidget(_list[index]),
                    _getMoreWidget()
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    // OrderItemWidget(_list[index]),
                  ],
                );
              }
            }, _getData, _onRefresh)
          : _getMoreWidget(),
    );
  }
}
