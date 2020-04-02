import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_list_view_widget.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/local_util.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/tabs_widget.dart';
import 'package:flutter/material.dart';

class InquiryListPage extends StatefulWidget {
  final orgId;
  InquiryListPage({this.orgId});
  @override
  _InquiryListPageState createState() => _InquiryListPageState();
}

class _InquiryListPageState extends State<InquiryListPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  TabController _tabController;
  List tabs = ["全部", "异常", "待报价", "已报价"];
  ScrollController _scrollController = new ScrollController();
  static StreamController streamController;
  Map<int, String> inquiryStatusesMap = {0: '', 1: '1', 2: '2', 3: '3'};

  @override
  void initState() {
    super.initState();
    //  创建一个 广播 streamController
    streamController = StreamController.broadcast();

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
    _scrollController.addListener(() => {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent)
            {print('滑动到了最底部${_scrollController.position.pixels}')}
        });
  }

  @override
  void dispose() {
    streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '询价单',
          elevation: 2,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CRMIcons.filter,
                size: ScreenFit.width(42),
              ),
              onPressed: () async {
                LocalStorage.save('inquiryCurTabIndex',
                    '$tabIndex'); // 记住当前的tabindex，用于筛选页返回列表页时，listview页面重复刷新的问题
                var result = await CRMNavigator.goInquiryFilterPage();
                print(result);
                streamController.sink.add(result);
              },
            ),
          ],
          bottom: tabsWidget(_tabController, tabs, isScrollable: false),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs
              .asMap()
              .map((index, value) {
                return MapEntry(
                    index,
                    InquiryListViewWidget(
                      streamController: streamController,
                      inquiryStatus: inquiryStatusesMap[index],
                      tabIndex: index,
                      orgId: widget.orgId,
                    ));
              })
              .values
              .toList(),
        ));
  }
}
