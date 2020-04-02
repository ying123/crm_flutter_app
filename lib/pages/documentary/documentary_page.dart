import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_list_view_widget.dart';
import 'package:crm_flutter_app/pages/order/list_view_widget.dart';
import 'package:crm_flutter_app/pages/returnExchange/exchange_list_view_widget.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/tabs_widget.dart';
import 'package:flutter/material.dart';

// Each TabBarView contains a _Page and for each _Page there is a list
// of _CardData objects. Each _CardData object is displayed by a _CardItem.
class DocumentaryPage extends StatefulWidget {
  @override
  _DocumentaryPageState createState() => _DocumentaryPageState();
}

class _DocumentaryPageState extends State<DocumentaryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const tabs = ["异常订单", "待转化询价单", "异常退换货"];
  int tabIndex = 0;
  TabController _tabController;
  ScrollController _scrollController = new ScrollController();

  @override
  bool get wantKeepAlive => true;

  List<Widget> get currentView => [
        OrderListViewWidget(
          documentaryTabIndex: tabIndex,
        ),
        InquiryListViewWidget(
          inquiryStatus: '',
          documentaryTabIndex: tabIndex,
        ),
        ExchangeListViewWidget(
          status: 0,
          documentaryTabIndex: tabIndex,
        ),
      ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 顶部入口栏
  Widget _buildGridNavWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _buildNavItemWidget(
                  title: '询价单',
                  iconAsset: 'assets/images/inquiry.png',
                  onTap: () {
                    Utils.trackEvent('inquiry_list');
                    CRMNavigator.goInquiryListPage();
                  }),
              _buildNavItemWidget(
                  title: '订单',
                  iconAsset: 'assets/images/order.png',
                  onTap: () {
                    Utils.trackEvent('order_list');
                    CRMNavigator.goOrderListPage(1);
                  }),
              _buildNavItemWidget(
                  title: '退换货',
                  iconAsset: 'assets/images/return_exchange.png',
                  onTap: () {
                    Utils.trackEvent('exchange_return_list');
                    CRMNavigator.goReturnExchangeListPage();
                  }),
            ],
          ),
          Container(
            color: CRMColors.commonBg,
            height: 10,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
          )
        ],
      ),
    );
  }

  Widget _buildNavItemWidget(
      {String title, String iconAsset, GestureTapCallback onTap}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Image.asset(
              iconAsset,
              width: ScreenFit.width(120),
              height: ScreenFit.width(120),
            ),
            Text(
              title,
              style: CRMText.normalText,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    child: SliverAppBar(
                      pinned: true,
                      // 这个高度必须比flexibleSpace高度大
                      expandedHeight: 198,
                      automaticallyImplyLeading: false,
                      leading: null,
                      forceElevated: innerBoxIsScrolled,
                      shape: Border(
                          bottom: BorderSide(
                              color: CRMColors.borderLight,
                              width: ScreenFit.onepx())),
                      bottom: tabsWidget(
                        _tabController,
                        tabs,
                      ),
                      flexibleSpace: Column(
                        children: <Widget>[
                          AppbarWidget(
                            title: '跟单',
                            automaticallyImplyLeading: false,
                            xiaobaQuery: XiaobaQueryModel(toPage: 'session'),
                          ),
                          Expanded(child: _buildGridNavWidget())
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                padding: EdgeInsets.only(top: 92),
                child: TabBarView(
                  controller: _tabController,
                  children: currentView,
                ),
              ))),
    );
  }
}
