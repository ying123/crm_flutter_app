import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

///下拉上拉刷新组件
///
///[_list]数据列表，
///[itemBuilder]构成列表的widget，
///[onLoadMore] 加载更多回调,
///[onRefresh]下拉刷新回调

class PullRefreshWidget extends StatefulWidget {
  // 列表
  final List _list;

  //item渲染
  final IndexedWidgetBuilder itemBuilder;
  // 加载更多回调
  final RefreshCallback onLoadMore;
  // 下拉回调
  final RefreshCallback onRefresh;

  PullRefreshWidget(
      this._list, this.itemBuilder, this.onLoadMore, this.onRefresh);
  @override
  _PullRefreshWidgetState createState() => _PullRefreshWidgetState();
}

class _PullRefreshWidgetState extends State<PullRefreshWidget> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification p) {
          if (p.metrics.pixels > p.metrics.maxScrollExtent) {
            if (widget._list.isNotEmpty) {
              //列表为空时不允许下拉
              widget.onLoadMore();
            }
          }
          return true; // 阻止冒泡
        },
        child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            color: Colors.white,
            backgroundColor: CRMColors.primary,
            child: ListView.builder(
              itemCount: widget._list.isNotEmpty ? widget._list.length : 1, //20
              itemBuilder: widget.itemBuilder,
            )));
  }
}
