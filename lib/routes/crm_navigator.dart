import 'dart:convert';

import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/pages/address/address_page.dart';
import 'package:crm_flutter_app/pages/coupons/coupon_records_page.dart';
import 'package:crm_flutter_app/pages/coupons/coupons_create_page.dart';
import 'package:crm_flutter_app/pages/coupons/factory_search_page.dart';
import 'package:crm_flutter_app/pages/coupons/index.dart';
import 'package:crm_flutter_app/pages/customer/contact_edit_page.dart';
import 'package:crm_flutter_app/pages/returnExchange/rate_details_page.dart';
import 'package:crm_flutter_app/pages/returnExchange/rate_subteam_list_page.dart';
import 'package:crm_flutter_app/pages/xiaoba/webView_page.dart';
import 'package:crm_flutter_app/routes/route_animation.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/pages/announcement/details_page.dart';
import 'package:crm_flutter_app/pages/announcement/list_page.dart';
import 'package:crm_flutter_app/pages/commission/commission_details_page.dart';
import 'package:crm_flutter_app/pages/costEntry/cost_details_page.dart';
import 'package:crm_flutter_app/pages/costEntry/cost_entry_page.dart';
import 'package:crm_flutter_app/pages/customer/contact_create_page.dart';
import 'package:crm_flutter_app/pages/customer/contact_detail_page.dart';
import 'package:crm_flutter_app/pages/customer/contact_list_page.dart';
import 'package:crm_flutter_app/pages/customer/customer_detail_page.dart';
import 'package:crm_flutter_app/pages/customer/customer_info.dart';
import 'package:crm_flutter_app/pages/customer/customer_list_page.dart';
import 'package:crm_flutter_app/pages/documentary/documentary_page.dart';
import 'package:crm_flutter_app/pages/home/index.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_detail_page.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_filter_page.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_huge_trans_list_page.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_list_page.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_num_list_view_widget.dart';
import 'package:crm_flutter_app/pages/invoice/invoice_detail_filter_page.dart';
import 'package:crm_flutter_app/pages/invoice/invoice_detail_page.dart';
import 'package:crm_flutter_app/pages/invoice/invoice_list_filter_page.dart';
import 'package:crm_flutter_app/pages/invoice/invoice_list_page.dart';
import 'package:crm_flutter_app/pages/login/login_page.dart';
import 'package:crm_flutter_app/pages/mine/personal_info_page.dart';
import 'package:crm_flutter_app/pages/order/detail_page.dart';
import 'package:crm_flutter_app/pages/order/list_num_page.dart';
import 'package:crm_flutter_app/pages/order/list_page.dart';
import 'package:crm_flutter_app/pages/order/order_filter_page.dart';
import 'package:crm_flutter_app/pages/other/no_network_page.dart';
import 'package:crm_flutter_app/pages/other/welcome_page.dart';
import 'package:crm_flutter_app/pages/performance/performance_page.dart';
import 'package:crm_flutter_app/pages/privacyPolicy/privacy_policy_page.dart';
import 'package:crm_flutter_app/pages/promotion/promotion_code_page.dart';
import 'package:crm_flutter_app/pages/promotion/promotion_filter_page.dart';
import 'package:crm_flutter_app/pages/promotion/promotion_record_page.dart';
import 'package:crm_flutter_app/pages/returnExchange/exchange_details_page.dart';
import 'package:crm_flutter_app/pages/returnExchange/list_page.dart';
import 'package:crm_flutter_app/pages/returnExchange/return_details_page.dart';
import 'package:crm_flutter_app/pages/workOrder/work_order_add_page.dart';
import 'package:crm_flutter_app/pages/workOrder/work_order_details_page.dart';
import 'package:crm_flutter_app/pages/workOrder/work_order_list_page.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaobaim/xiaobaim.dart';

class CRMNavigator {
  CRMNavigator._();

  static Future<T> _goPage<T extends Object>(Route route,
      {bool replace = false}) {
    return replace
        ? rootNavigatorState.pushReplacement<T, Null>(route)
        : rootNavigatorState.push<T>(route);
  }

  // 用哪个页面切换动画
  static Route<T> _routeBuilder<T>(Widget widget,
      {bool isCupertinoPageRoute = true}) {
    return isCupertinoPageRoute
        ? CupertinoPageRoute<T>(builder: (context) => widget)
        : SizeRoute<T>(widget: widget);
  }

  ///没有网络
  static Future<T> goNoNetworkPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(NoNetworkPage()), replace: replace);
  }

  ///启动页（用不上）
  static Future<T> goWelcomePage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(WelcomePage()), replace: replace);
  }

  ///登录
  static Future<T> goUserLoginPage<T>({VoidCallback onLoginSucces}) {
    return rootNavigatorState.pushAndRemoveUntil(
        _routeBuilder(
            UserLoginPage(
              onLoginSucces: onLoginSucces,
            ),
            isCupertinoPageRoute: false),
        (route) => false);
  }

  ///首页
  static Future<T> goHomePage<T>(
      {bool replace = false, VoidCallback onLoginSucces}) {
    return _goPage<T>(
        _routeBuilder(BottomNavigatorWidget(onLoginSucces: onLoginSucces)),
        replace: replace);
  }

  ///跟单
  static Future<T> goDocumentaryPage<T>({bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(DocumentaryPage(), isCupertinoPageRoute: false),
        replace: replace);
  }

  ///业绩
  static Future<T> goPerformancePage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PerformancePage()), replace: replace);
  }

  ///询价单列表
  static Future<T> goInquiryListPage<T>({bool replace = false, var orgId}) {
    return _goPage<T>(_routeBuilder(InquiryListPage(orgId: orgId)),
        replace: replace);
  }

  ///大单转化列表
  static Future<T> goInquiryHugeTransListPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(InquiryHugeTransListPage()),
        replace: replace);
  }

  ///新询价单
  static Future<T> goInquiryNumTransListViewPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(InquiryNumTransListViewWidget()),
        replace: replace);
  }

  ///询价单详情
  static Future<T> goInquryDetailPage<T>(String inquiryId,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(InquryDetailPage(inquiryId)),
        replace: replace);
  }

  ///询价单筛选
  static Future<T> goInquiryFilterPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(InquiryFilterPage()), replace: replace);
  }

  ///订单列表
  static Future<T> goOrderListPage<T>(int index,
      {bool replace = false, int orgId}) {
    return _goPage<T>(
        _routeBuilder(OrderListPage(activeIndex: index, orgId: orgId)),
        replace: replace);
  }

  ///交易订单数
  static Future<T> goOrderNumListViewPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(OrderNumListViewWidget()),
        replace: replace);
  }

  ///订单详情
  static Future<T> goOrderDetailPage<T>(String orderId,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(OrderDetailPage(orderId)),
        replace: replace);
  }

  ///订单筛选
  static Future<T> goOrderFilterPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(OrderFilterPage()), replace: replace);
  }

  ///退换货列表
  static Future<T> goReturnExchangeListPage<T>(
      {bool replace = false,
      int curTopTab = 0,
      int curBottomTab = 0,
      bool isSelectCustomer = false,
      var orgId}) {
    return _goPage<T>(
        _routeBuilder(ReturnExchangeListPage(
            curTopTab: curTopTab,
            orgId: orgId,
            curBottomTab: curBottomTab,
            isSelectCustomer: isSelectCustomer)),
        replace: replace);
  }

  ///退货详情
  static Future<T> goReturnDetailsPage<T>(int id,
      {bool replace = false, bool hasAuthForRate = false}) {
    return _goPage<T>(
        _routeBuilder(ReturnDetailsPage(
          id,
          hasAuthForRate: hasAuthForRate,
        )),
        replace: replace);
  }

  ///换货详情
  static Future<T> goExchangeDetailsPage<T>(int id,
      {bool replace = false, bool hasAuthForRate = false}) {
    return _goPage<T>(
        _routeBuilder(ExchangeDetailsPage(id, hasAuthForRate: hasAuthForRate)),
        replace: replace);
  }

  ///个人信息
  static Future<T> goPersonalInfoPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PersonalInfoPage()), replace: replace);
  }

  ///隐私政策
  static Future<T> goPrivacyPolicyPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PrivacyPolicyPage()), replace: replace);
  }

  ///我的工单
  static Future<T> goWorkOrderListPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(WorkOrderListPage()), replace: replace);
  }

  ///添加工单
  static Future<T> goWorkOrderAddPage<T>(
      {@required String orderNo,
      int workOrderNo,
      Map<String, dynamic> details,
      bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(WorkOrderAddPage(
            orderNo: orderNo, workOrderNo: workOrderNo, details: details)),
        replace: replace);
  }

  ///工单详情
  static Future<T> goWorkOrderDetailsPage<T>(String orderNo,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(WorkOrderDetailsPage(orderNo)),
        replace: replace);
  }

  ///小巴
  static Future<void> goXiaobaPage(XiaobaQueryModel queryParameters,
      {bool replace = false}) async {
    final imInfo = await LocalStorage.get<String>(Inputs.IMINFO);
    if (imInfo == null || imInfo.isEmpty) {
      Utils.showToast('当前账户无小巴客服帐号');
    } else {
      if (queryParameters.toPage == 'session') {
        Xiaobaim.pushToSession();
      } else {
        Xiaobaim.distributeToQueryList(jsonEncode(queryParameters));
      }
    }
  }

  ///打开webView
  static Future<T> goWebViewPage<T>(String fullPath, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(WebViewPage(fullPath)), replace: replace);
  }

  ///公告列表
  static Future<T> goAnnouncementListPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(AnnouncementListPage()), replace: replace);
  }

  ///公告详情
  static Future<T> goAnnouncementDetailsPage<T>(int read, String noticeId,
      {bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(AnnouncementDetailsPage(
            <String, dynamic>{'read': read.toString(), 'id': noticeId})),
        replace: replace);
  }

  ///客户信息详情
  static Future<T> goCustomerInfoPage<T>(String customerId, int orgId,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(CustomerInfoPage(customerId, orgId)),
        replace: replace);
  }

  ///客户列表
  static Future<T> goCustomerListPage<T>(String type, String mfctyIds,
      {bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(CustomerListPage(type: type, mfctyIds: mfctyIds)),
        replace: replace);
  }

  ///客户详情
  static Future<T> goCustomerDetailPage<T>(String id, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(CustomerDetailPage(id)), replace: replace);
  }

  ///联系人
  static Future<T> goContactListPage<T>(String id, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(ContactListPage(id)), replace: replace);
  }

  ///联系人详情
  static Future<T> goContactDetailPage<T>(int id, int custId,
      {bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(ContactDetailPage(
          id: id,
          custId: custId,
        )),
        replace: replace);
  }

  ///添加联系人
  static Future<T> goContactCreatePage<T>(int id, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(ContactCreatePage(id: id)),
        replace: replace);
  }

  ///编辑联系人
  static Future<T> goContactEditPage<T>(
      int orgId, int id, Map<String, dynamic> info,
      {bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(ContactEditPage(orgId: orgId, id: id, info: info)),
        replace: replace);
  }

  ///派券
  static Future<T> goCouponsIndexPage<T>(int tabIndex, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(CouponsIndexPage(tabIndex)),
        replace: replace);
  }

  ///创建优惠券
  static Future<T> goCouponsCreatePages<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(CouponsCreatePages()), replace: replace);
  }

  /// 选择汽修厂
  static Future<T> goFactorySearch<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(FactorySearchPage()), replace: replace);
  }

  ///发票列表
  static Future<T> goInvoiceListPage<T>(var orgId,
      {bool replace = false, activeTab = 0}) {
    return _goPage<T>(
        _routeBuilder(InvoiceListPage(
          orgId,
          activeTab: activeTab,
        )),
        replace: replace);
  }

  ///发票列表筛选
  static Future<T> goInvoiceListFilterPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(InvoiceListFilterPage()), replace: replace);
  }

  ///发票详情
  static Future<T> goInvoiceDetailPage<T>(int id, Map<String, dynamic> info,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(InvoiceDetailPage(id, info)),
        replace: replace);
  }

  ///发票详情筛选
  static Future<T> goInvoiceDetailFilterPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(InvoiceDetailFilterPage()),
        replace: replace);
  }

  ///推广码
  static Future<T> goPromotionCodePage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PromotionCodePage()), replace: replace);
  }

  ///推广记录
  static Future<T> goPromotionRecordPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PromotionRecordPage()), replace: replace);
  }

  ///推广记录筛选
  static Future<T> goPromotionFilterPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder(PromotionFilterPage()), replace: replace);
  }

  ///成本录入
  static Future<T> goCostEntryPage<T>({Map costDto, bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(CostEntryPage(
          costDto: costDto,
        )),
        replace: replace);
  }

  ///成本明细
  static Future<T> goCostDetailsPage<T>(Map costDto, {bool replace = false}) {
    return _goPage<T>(_routeBuilder(CostDetailsPage(costDto)),
        replace: replace);
  }

  ///佣金
  static Future<T> goCommissionDetailsPage<T>(Map commissionDto,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder(CommissionDetailsPage(commissionDto)),
        replace: replace);
  }

  ///退换货率报表明细
  static Future<T> goRateDetailsPage<T>(
      int subTeamId, type, typeDesc, String date,
      {bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(RateDetailsPage(
          subTeamId: subTeamId,
          type: type,
          typeDesc: typeDesc,
          date: date,
        )),
        replace: replace);
  }

  ///退换货子团队报表列表
  static Future<T> goRateSubteamListPage<T>(
      {String date = '', bool replace = false}) {
    return _goPage<T>(
        _routeBuilder(RateSubteamListPage(
          date: date,
        )),
        replace: replace);
  }

  ///地址选择页面
  static Future<T> goAddressPage<T>({bool replace = false}) {
    return _goPage<T>(_routeBuilder<T>(AddressPage()), replace: replace);
  }

  ///派券记录
  static Future<T> goCouponsRecords<T>(int id, String name,
      {bool replace = false}) {
    return _goPage<T>(_routeBuilder<T>(CouponRecords(id, name)),
        replace: replace);
  }
}
