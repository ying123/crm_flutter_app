import 'dart:convert';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/pages/orderProgress/progress_item_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrderProgressListViewWidget extends StatefulWidget {
  OrderProgressListViewWidget({Key key}) : super(key: key);

  _OrderProgressListViewWidgetState createState() =>
      _OrderProgressListViewWidgetState();
}

class _OrderProgressListViewWidgetState
    extends State<OrderProgressListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  int _page = 1;
  bool hasMore = true; //判断有没有数据
  // ScrollController _scrollController = new ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollController.dispose();
  }

  Future<void> _getData({page}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      _page = page;
      _list = [];
    }
    if (this.hasMore) {
      var apiUrl =
          "http://www.phonegap100.com/appapi.php?a=getPortalList&catid=20&page=$_page";

      var response = await Dio().get(apiUrl);
      var res = json.decode(response.data)["result"];

      if (this.mounted) {
        setState(() {
          this._list.addAll(res); //拼接
          this._page++;
        });
        //判断是否是最后一页
        if (res.length < 20) {
          setState(() {
            this.hasMore = false;
          });
        }
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    await _getData(page: 0);
  }

  // more or complete widget
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return this._list.length > 0
        ? PullRefreshWidget(_list, (context, index) {
            //19
            if (index == this._list.length - 1) {
              //列表渲染到最后一条的时候加一个圈圈
              //拉到底
              return Column(
                children: <Widget>[ProgressItemWidget(), _getMoreWidget()],
              );
            } else {
              return Column(
                children: <Widget>[
                  ProgressItemWidget(),
                ],
              );
            }
          }, _getData, _onRefresh)
        : _getMoreWidget();
  }
}
