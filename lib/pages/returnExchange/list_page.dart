import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/returnExchange/exchange_list_view_widget.dart';
import 'package:crm_flutter_app/pages/returnExchange/rate_list_view_widget.dart';
import 'package:crm_flutter_app/pages/returnExchange/return_list_view_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/tabs_widget.dart';
import 'package:flutter/material.dart';

class ReturnExchangeListPage extends StatefulWidget {
  final int curTopTab;
  final int curBottomTab;
  final orgId;
  final bool isSelectCustomer;
  ReturnExchangeListPage(
      {this.curTopTab, this.curBottomTab, this.orgId, this.isSelectCustomer});
  @override
  _ReturnExchangeListPageState createState() => _ReturnExchangeListPageState();
}

class _ReturnExchangeListPageState extends State<ReturnExchangeListPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> tabs = [];
  List<Widget> views = [];
  int _curTopTab = 0;
  bool _authForRate = false;
  bool _loading = true;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hasAuthForRate();
  }

  Future<void> _hasAuthForRate() async {
    ResultDataModel res =
        await httpGet(Apis.hasAuthorization, showLoading: true);

    if (res.success == true) {
      if (mounted && res.model) {
        setState(() {
          _authForRate = res.model;
        });
      }
      if (_authForRate) {
        setState(() {
          tabs = ["退换货率报表", "退货", "换货"];
          views = [
            RateListViewWidget(),
            ReturnListViewWidget(
                orgId: widget.orgId,
                curTopTab: widget.curTopTab,
                curBottomTab: widget.curBottomTab,
                hasAuthForRate: true),
            ExchangeListViewWidget(
                orgId: widget.orgId,
                curTopTab: widget.curTopTab,
                curBottomTab: widget.curBottomTab,
                hasAuthForRate: true)
          ];
        });
      } else {
        setState(() {
          tabs = ["退货", "换货"];
          views = [
            ReturnListViewWidget(
                orgId: widget.orgId,
                curTopTab: widget.curTopTab,
                curBottomTab: widget.curBottomTab,
                hasAuthForRate: false),
            ExchangeListViewWidget(
                orgId: widget.orgId,
                curTopTab: widget.curTopTab,
                curBottomTab: widget.curBottomTab,
                hasAuthForRate: false)
          ];
        });
      }
      // 设置loading状态
      setState(() {
        _loading = false;
        _curTopTab = widget.curTopTab;
        if (widget.isSelectCustomer && !_authForRate) {
          _curTopTab = widget.curTopTab - 1;
        }
      });

      _tabController = TabController(
          vsync: this, length: tabs.length, initialIndex: _curTopTab)
        ..addListener(() {
          setState(() {
            _curTopTab = _tabController.index;
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            appBar: AppbarWidget(title: '退换货列表'),
            body: Container(
              height: 400,
              child: NoDataWidget(
                height: 20,
              ),
            ),
          )
        : DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppbarWidget(
                title: '退换货列表',
                elevation: 2,
                bottom: tabsWidget(_tabController, tabs,
                    isScrollable: _authForRate ? true : false),
              ),
              body: TabBarView(
                controller: _tabController,
                children: views,
              ),
            ),
          );
  }
}
