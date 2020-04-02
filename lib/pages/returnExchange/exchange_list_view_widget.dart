import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/returnExchange/return_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class ExchangeListViewWidget extends StatefulWidget {
  final int status;
  final orgId;
  final int curTopTab;
  final int curBottomTab;
  final int documentaryTabIndex;
  final bool hasAuthForRate;
  ExchangeListViewWidget(
      {Key key,
      this.status,
      this.orgId,
      this.curTopTab,
      this.curBottomTab,
      this.documentaryTabIndex,
      this.hasAuthForRate})
      : super(key: key);

  _ExchangeListViewWidgetState createState() => _ExchangeListViewWidgetState();
}

class _ExchangeListViewWidgetState extends State<ExchangeListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  int _page = 0;
  int _pageSize = 10;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;
  int _status = 8; // 换货 8： 待处理  -1：全部
  bool _hasAuthForRate = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //判断是否是从客户信息页面进来的，客户信息页进来的需选中“全部”
    if (widget.curBottomTab == 1) {
      setState(() {
        _status = -1;
      });
    } else {
      setState(() {
        _status = 8;
      });
    }

    if (widget.hasAuthForRate == null) {
      _isAuthForRate();
    } else {
      _hasAuthForRate = widget.hasAuthForRate;
    }
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _isAuthForRate() async {
    ResultDataModel res = await httpGet(Apis.hasAuthorization);
    if (res.success == true) {
      _hasAuthForRate = res?.model;
    }
  }

  Future<void> _getData({page}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      setState(() {
        _page = page;
        _list = [];
        _hasMore = true;
        _loading = false;
      });
    }
    if (this._hasMore) {
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      var res;
      ResultDataModel resultDataModel = await httpGet(Apis.exchangeList,
          queryParameters: {
            "status": widget.status ?? (_status == -1 ? '' : _status),
            "pageIndex": this._page,
            "pageSize": 10,
            "orgId": widget.orgId ?? ''
          },
          showLoading: true);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (resultDataModel.code == 0) {
        res = resultDataModel.model;

        if (this.mounted) {
          setState(() {
            this._list.addAll(res); //拼接
            this._page++;
          });
          //判断是否是最后一页
          if (res.length < this._pageSize && mounted) {
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
    if (widget.documentaryTabIndex != null && widget.documentaryTabIndex != 2) {
      return;
    }
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
    return Column(
      children: <Widget>[
        Expanded(
            child: PullRefreshWidget(_list, (context, index) {
          return _list.isNotEmpty
              ? Column(
                  children: <Widget>[
                    ReturnItemWidget(
                      _list[index],
                      index,
                      isExchange: true,
                      hasAuthForRate: _hasAuthForRate,
                    ),
                    if (index == this._list.length - 1) _getMoreWidget()
                  ],
                )
              : NoDataWidget();
        }, _getData, _onRefresh)),
        if (widget.status == null)
          SafeArea(
            child: Container(
              color: Colors.white,
              height: 48,
              // padding: EdgeInsets.symmetric(vertical: CRMGaps.gap_dp8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    height: 48,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _status = 8;
                        });
                        _getData(page: 0);
                      },
                      child: Text(
                        '待处理',
                        style: _status == 8
                            ? CRMText.tabActiveText
                            : CRMText.tabText,
                      ),
                    ),
                  )),
                  Expanded(
                      child: SizedBox(
                    height: 48,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _status = -1;
                        });
                        _getData(page: 0);
                      },
                      child: Text('全部',
                          style: _status == -1
                              ? CRMText.tabActiveText
                              : CRMText.tabText),
                    ),
                  ))
                ],
              ),
            ),
          )
      ],
    );
  }
}
