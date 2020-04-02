import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget tabsWidget(TabController _tabController, List _tabs,
    {bool isScrollable = false,
    Color labelColor,
    Color unselectedLabelColor,
    TextStyle unselectedLabelStyle}) {
  return PreferredSize(
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: TabBar(
            isScrollable: isScrollable,
            labelColor: labelColor ?? CRMColors.primary,
            unselectedLabelStyle: unselectedLabelStyle ?? CRMText.tabText,
            indicatorColor: CRMColors.primary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: CRMColors.primary, width: 2.0),
            ),
            unselectedLabelColor: unselectedLabelColor ?? CRMColors.textLight,
            controller: _tabController,
            tabs: _tabs.map((e) => Tab(text: e)).toList()),
      ),
      preferredSize: Size.fromHeight(40.0));
}
