import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/pages/coupons/coupons_center_page.dart';
import 'package:crm_flutter_app/pages/coupons/coupons_rules_page.dart';
import 'package:crm_flutter_app/pages/coupons/coupons_table_page.dart';

import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class CouponsIndexPage extends StatefulWidget {
  final int activeTabIndex;
  CouponsIndexPage(this.activeTabIndex);

  @override
  _CouponsIndexPageState createState() => _CouponsIndexPageState();
}

class _CouponsIndexPageState extends State<CouponsIndexPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> tabs = [
    '派券报表',
    '派券中心',
    '优惠券规则',
  ];

  List<Widget> currentView = [
    CouponsTablePage(),
    CouponsCenterPage(),
    CouponsRulePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.index = widget.activeTabIndex;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '派券',
        elevation: 2,
        bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelStyle: CRMText.tabText,
            indicatorColor: primaryColor,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            unselectedLabelColor: CRMColors.textLight,
            controller: _tabController,
            tabs: tabs.map((title) => Tab(text: title)).toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: currentView,
      ),
    );
  }
}
