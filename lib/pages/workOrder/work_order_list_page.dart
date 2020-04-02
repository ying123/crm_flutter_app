import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';

import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:crm_flutter_app/widgets/tabs_widget.dart';
import 'package:flutter/material.dart';

class WorkOrderListPage extends StatefulWidget {
  @override
  _WorkOrderListPageState createState() => _WorkOrderListPageState();
}

class _WorkOrderListPageState extends State<WorkOrderListPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<String> tabs = const ["全部", "待受理", "受理中", "已解决", "已关闭"];
  List _list = [];
  int _page = 0;
  int _pageSize = 10;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;
  int _status;
  Map<int, Color> _colorMap = const {
    2: CRMColors.warning,
    3: CRMColors.primary,
    4: CRMColors.success,
    5: CRMColors.danger
  };

  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5);
    this._getData();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _status = null;
              break;
            case 1:
              _status = 2;
              break;
            case 2:
              _status = 3;
              break;
            case 3:
              _status = 4;
              break;
            case 4:
              _status = 5;
              break;
            default:
          }
        });
        this._getData(page: 0);
      }
    });
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
      ResultDataModel resultDataModel = await httpGet(Apis.workOrderList,
          queryParameters: {
            "page": this._page,
            "pageSize": 10,
            if (_status != null) "status": _status
          },
          showLoading: true);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (resultDataModel.code == 0) {
        res = resultDataModel.data['orderList'];

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

  Widget _workOrderItem(item, index) {
    return Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : CRMGaps.gap_dp10),
        color: Colors.white,
        child: InkWell(
          onTap: () async {
            await CRMNavigator.goWorkOrderDetailsPage(
                '${item["orderNo"] ?? ""}');
            _getData(page: 0);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DarkTitleWidget(
                title: '工单号：${item["orderNo"] ?? ""}',
                size: Status.MINI,
                subtitle: tabs[item['status'] - 1],
                subtitleColor: _colorMap[item['status']],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CRMGaps.gap_dp10, horizontal: CRMGaps.gap_dp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                      child: Text(
                        "主题：${item["subject"] ?? ""}",
                        style: TextStyle(color: CRMColors.textLight),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                      child: Text(
                        "内容：${item["description"] ?? ""}",
                        style: TextStyle(color: CRMColors.textLight),
                      ),
                    ),
                  ],
                ),
              ),
              CRMBorder.dividerDp1,
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CRMGaps.gap_dp12, horizontal: CRMGaps.gap_dp16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: '受理客服：',
                              style: CRMText.smallText,
                              children: [
                                TextSpan(
                                  text: item["workgroupName"] ?? "",
                                  style: TextStyle(
                                      fontSize: CRMText.smallTextSize),
                                )
                              ]),
                        )),
                    SizedBox(
                      width: CRMGaps.gap_dp10,
                    ),
                    Text(
                      item["updateTime"] ?? "",
                      style: CRMText.smallText,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppbarWidget(
        title: '工单列表',
        elevation: 2,
        bottom: tabsWidget(_tabController, tabs, isScrollable: true),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((page) {
          return PullRefreshWidget(_list, (context, index) {
            return _list.isNotEmpty
                ? Column(
                    children: <Widget>[
                      _workOrderItem(_list[index], index),
                      if (index == this._list.length - 1) _getMoreWidget()
                    ],
                  )
                : _loading ? Container() : NoDataWidget();
          }, _getData, _onRefresh);
        }).toList(),
      ),
    );
  }
}
