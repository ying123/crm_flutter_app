import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/order/order_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  final int activeIndex;
  final int orgId;
  OrderListPage({Key key, this.activeIndex, this.orgId}) : super(key: key);

  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  int activeTab; // 1 正常订单 2 异常订单 3 待跟进订单
  bool hasMore = true;
  bool _loading = true;
  List _list = new List();
  int _page = 1;
  int _pageSize = 10;
  int _totalPage = 0;
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
  void initState() {
    super.initState();
    this.activeTab = widget.activeIndex;
    _loadListData();
  }

  // 清空过滤数据
  void _clearFilterData() {
    this.commonParams = {
      'orderNo': '',
      'custName': '',
      'provinceId': '',
      'cityId': '',
      'countyId': '',
      'payStartTime': '',
      'payEndTime': '',
    };
  }

  // 正常订单、待跟进订单
  _loadListData() async {
    if (mounted) {
      setState(() {
        this._loading = true;
        this._list.length = 0;
        this._page = 1;
      });
    }

    Map<String, dynamic> params = {
      ...commonParams,
      'orgId': widget.orgId ?? '',
      'page': this._page,
      'limit': this._pageSize,
    }; // 全部订单
    if (this.activeTab == 3) {
      params['payState'] = 0; // 待跟进订单
    }

    ResultDataModel res = await httpGet(Apis.OrderList,
        queryParameters: params, showLoading: true);

    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._loading = false;
          this._totalPage = (res.data['total'] / this._pageSize).ceil();
          this._list = res.data['list'];
        });
        this._page++;
        print('当前的页码， 总的页码数据, ${this._page}, ${this._totalPage}');
        if (this._page > this._totalPage) {
          setState(() {
            this.hasMore = false;
          });
        }
      }
    }
  }

  // 加载异常订单列表
  _loadErrorList() async {
    if (mounted) {
      setState(() {
        this._loading = true;
        this._list.length = 0;
        this._page = 1;
      });
    }
    ResultDataModel res = await httpGet(Apis.ErrorOrderList,
        queryParameters: {...commonParams, 'orgId': widget.orgId ?? ''},
        showLoading: true);

    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._loading = false;
          this.hasMore = false;
          this._list = res.data;
        });
      }
    }
  }

  // tab item
  Widget _buildTabItemWidget(String title, int index) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          this.setState(() => {
                this.activeTab = index,
                this.hasMore = true,
                this._loading = false,
                // 清空过滤条件
                this._clearFilterData(),
                if (this.activeTab == 2)
                  {
                    // 异常订单
                    this._loadErrorList()
                  }
                else // 正常订单和待跟进订单
                  {this._loadListData()}
              });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(title,
              style: TextStyle(
                  color: activeTab == index
                      ? CRMColors.primary
                      : CRMColors.textNormal)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: activeTab == index
                          ? CRMColors.primary
                          : CRMColors.borderLight,
                      width: activeTab == index ? 2 : 1))),
        ),
      ),
    );
  }

  // 设置tab区域
  Widget _buildTabWiget() {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _buildTabItemWidget('全部', 1),
              _buildTabItemWidget('异常订单', 2),
              _buildTabItemWidget('待跟进订单', 3),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _getData() async {
    // 异常订单列表不会加载更多
    if (this.hasMore && !this._loading && this.activeTab != 2) {
      this._loading = true;

      Map<String, dynamic> params = {
        ...commonParams,
        'orgId': widget.orgId ?? '',
        'page': this._page,
        'limit': this._pageSize,
      };
      if (this.activeTab == 3) {
        params['payState'] = 0;
      }
      ResultDataModel res =
          await httpGet(Apis.OrderList, queryParameters: params);

      if (res.code == 0) {
        if (mounted) {
          setState(() {
            this._loading = false;
            this._totalPage = (res.data['total'] / this._pageSize).ceil();
            this._list.addAll(res.data['list']);
          });
          this._page++;
          print('当前的页码， 总的页码数据, ${this._page}, ${this._totalPage}');
          if (this._page > this._totalPage) {
            setState(() {
              this.hasMore = false;
            });
          }
        }
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    if (this.activeTab == 2) {
      await _loadErrorList();
    } else {
      await _getData();
    }
  }

  // more or complete widget
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  // 主体区域
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppbarWidget(
          title: '订单',
          elevation: 2,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: _buildTabWiget(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CRMIcons.filter,
                size: ScreenFit.width(42),
              ),
              onPressed: () async {
                var result = await CRMNavigator.goOrderFilterPage();
                if (result != null) {
                  this.commonParams = result;
                  this.hasMore = true;
                  this._loading = false;
                  if (this.activeTab == 2) {
                    this._loadErrorList();
                  } else {
                    this._loadListData();
                  }
                }
              },
            ),
          ],
        ),
        body: PullRefreshWidget(_list, (context, index) {
          return this._list.length > 0
              ? Column(
                  children: <Widget>[
                    OrderItemWidget(
                        activeTab == 2 ? 'abnormalType' : 'normalType',
                        _list[index]),
                    if (index == this._list.length - 1) _getMoreWidget()
                  ],
                )
              : NoDataWidget();
        }, _getData, _onRefresh));
  }
}
