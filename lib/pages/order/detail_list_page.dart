import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/order/order_detail_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/widgets/ellipsis_title_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class OrderDetailListWidget extends StatefulWidget {
  final String _orderId;
  final Map _baseInfo;
  OrderDetailListWidget(this._orderId, this._baseInfo);
  @override
  _OrderDetailListWidgetState createState() => _OrderDetailListWidgetState();
}

class _OrderDetailListWidgetState extends State<OrderDetailListWidget> {
  List _contentList = new List();
  List _list = new List();
  List allList = new List();

  List<Widget> _widgetList = new List();

  int _page = 0;
  int _pageSize = 10;
  bool _loading = false;
  bool hasMore = true;
  int _itemLen = 0;
  List orderDetailTrackVOS = new List();

  @override
  void initState() {
    super.initState();
    _loadLogisticTrack();
    // this._getData(page: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PullRefreshWidget(_list, (context, index) {
      return this._list.length > 0
          ? Container(
              child: Column(
                children: <Widget>[
                  EllipsisTitleWidget(
                      this._list[index]['carTypeDisplayName'] == ''
                          ? '未知'
                          : this._list[index]['carTypeDisplayName']),
                  ...allList[index],
                  if (index == this._list.length - 1) _getMoreWidget()
                ],
              ),
            )
          : NoDataWidget(
              height: 50,
            );
    }, _getData, _onRefresh);
  }

  // 获取配件的物流轨迹图
  _loadLogisticTrack() async {
    ResultDataModel res = await httpGet(Apis.LogisticTrack,
        queryParameters: {'orderId': widget._orderId}, showLoading: true);
    this._getData(page: 0);
    if (res.success == true && mounted) {
      setState(() {
        this.orderDetailTrackVOS = res.model['order_detail_track_vos'];
      });
    }
  }

  // 判断显示loading图标
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  // 加载数据源
  Future<void> _getData({page}) async {
    if (this.hasMore && !this._loading && mounted) {
      setState(() {
        this._loading = true;
        if (page != null) {
          this._page = page;
          this._list.length = 0;
          this._contentList.length = 0;
          this.allList.length = 0;
        }
      });
      ResultDataModel res = await httpGet(Apis.OrderDetail,
          queryParameters: {
            'orderId': widget._orderId,
            'pageIndex': this._page,
            'pageSize': this._pageSize
          },
          showLoading: true);

      if (res.success) {
        setState(() {
          this._loading = false;
          this._list.addAll(res.model);
          if (res.model != null && res.model.length > 0) {
            res.model.forEach((item) {
              this._contentList.add(item['list']);
            });
          }
          allList.length = 0;
          _itemLen = 0;
          this._contentList.forEach((item) {
            List _all = new List();
            this._widgetList = new List();
            item.forEach((value) {
              var selectPart = {};
              if (this.orderDetailTrackVOS.length > 0) {
                selectPart = this
                    .orderDetailTrackVOS
                    .where((item) =>
                        item['order_detail_id'] == value['order_detail_id'])
                    .toList()
                    .first;
              }
              this._widgetList.add(
                  OrderDetailItemWidget(value, widget._baseInfo, selectPart));
            });
            this._itemLen += this._widgetList.length;
            _all.add(this._widgetList);
            allList.addAll(_all);
          });
          if (_itemLen < _pageSize) {
            setState(() {
              this.hasMore = false;
            });
          }
        });
        this._page++;
      }

      if (!res.success && res.model == null) {
        setState(() {
          this.hasMore = false;
        });
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    setState(() {
      this.hasMore = true;
      this._loading = false;
      _getData(page: 0);
    });
  }
}
