import 'package:crm_flutter_app/config/permission.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/providers/notices_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/notice_icon.dart';
import 'package:flutter/material.dart';

import 'package:crm_flutter_app/config/crm_style.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var _tradeAmount; // 当月交易额
  int _orderFollowCount; // 待跟进订单数
  int _orderFinishCount; // 已完成的订单数

  int _todaySuccess; // 当天转化的客户数量
  int _thisMonthSuccess; // 当月的转化数量
  // List _todaySuccessOrgIds; // 当天成功推广的客户orgIds
  List _thisMonthSuccessOrgIds; // 当月成功推广的客户orgIds
  String _mfctyIds = ''; // 当月成功推广的客户orgIds字符串格式

  int _followInquiryCount; // 待跟进询价单数量
  // int _finishInquiryCount; // 已完成询价单数量
  int _followInquiry3000Count; // 待跟进的大单数量
  // int _finishInquiry3000Count; // 已完成的大单数量
  List _permission = []; //权限列表

  @override
  void initState() {
    super.initState();
    _refresh();
    _getPermissionList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _getPermissionList() async {
    String resourceStr = await LocalStorage.get(Permission.PERMISSION_KEY);
    setState(() {
      _permission = resourceStr.split(',');
    });
  }

  Future<void> _refresh() async {
    List<Future> tickets = <Future>[
      _getData(), // 获取交易额
      _getOrderTask(), // 获取订单统计数量
      _inquryTaskCount(), // 获取询价单的统计数量
      _statisticsCount(), // 获取开拓的客户信息
      _getNoticeList() // 查询公告列表
    ];
    await Future.wait(tickets);
  }

  Future _getNoticeList() async {
    final res = await httpGet(Apis.NoticeList, showLoading: false);
    final noticesModel = Provider.of<NoticesModel>(context);
    if (res.code == 0 && mounted) {
      noticesModel.notices = res.data;
      var notices = noticesModel.notices;
      for (var i = 0; i < notices.length; i++) {
        final notice = notices[i];
        if (notice['pop'] == 1 && notice['read'] == 0) {
          final success = await MessageBox.notice(
              context, notice['popPic'], 0, notice['noticeId']);
          if (success == true) {
            noticesModel.setNoticeRead(i);
          }
          return;
        }
      }
    }
  }

  //获取交易额
  Future _getData() async {
    ResultDataModel res = await httpGet(Apis.tradeAmount);
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          _tradeAmount = res.data;
        });
      }
    }
  }

  // 获取订单统计数量
  Future _getOrderTask() async {
    ResultDataModel res = await httpGet(Apis.orderTaskCount);

    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._orderFollowCount = res.data['followCount'];
          this._orderFinishCount = res.data['finishCount'];
        });
      }
    }
  }

  // 获取询价单的统计数量
  Future _inquryTaskCount() async {
    ResultDataModel res = await httpGet(Apis.inquryTaskCount);
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._followInquiryCount = res.data['thisMonthCount'];
          // this._finishInquiryCount = res.model['finishInquiryCount'];
          this._followInquiry3000Count = res.data['thisMonth3000Count'];
          // this._finishInquiry3000Count = res.model['finishInquiry3000Count'];
        });
      }
    }
  }

  // 获取开拓的客户数量
  Future _statisticsCount() async {
    ResultDataModel res = await httpGet(Apis.statisticsCount);

    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this._todaySuccess = res.data['todaySuccess'];
          this._thisMonthSuccess = res.data['thisMonthSuccess'];
          // this._todaySuccessOrgIds = res.data['todaySuccessOrgIds'];
          this._thisMonthSuccessOrgIds = res.data['thisMonthSuccessOrgIds'];
          if (this._thisMonthSuccessOrgIds != null) {
            this._mfctyIds = this._thisMonthSuccessOrgIds.join(',');
            print('当月成功推广的用户orgIds,${this._mfctyIds}');
          }
        });
      }
    }
  }

  ///顶部交易额卡片
  Widget _buildHomeCard() {
    return Positioned(
      bottom: -ScreenFit.height(50),
      left: ScreenFit.width(15),
      child: Container(
        width: ScreenFit.width(720),
        height: 140,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/banner.png"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '已完成月交易额',
              style: CRMText.normalText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _tradeAmount != null ? '$_tradeAmount' : '--',
                  style: TextStyle(color: CRMColors.textDark, fontSize: 32),
                ),
                Text(
                  '元',
                  style: CRMText.normalText,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///入口item
  Widget _buildGridItem(
      {String imageSrc = '', String title = '', GestureTapCallback onTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Image.asset(
            imageSrc,
            width: ScreenFit.width(96),
          ),
          Text(
            title,
            style: TextStyle(
                color: CRMColors.textDark, fontSize: CRMText.smallTextSize),
          )
        ],
      ),
    ));
  }

  ///进度条
  Widget _buildProgressIndicator(showProgressIndicator, active, progress) {
    return Container(
        width: ScreenFit.width(260),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CRMRadius.radius10),
          border: showProgressIndicator
              ? Border.all(
                  color: active ? CRMColors.primary : CRMColors.commonBg)
              : Border.all(color: Colors.white),
        ),
        child: showProgressIndicator
            ? SizedBox(
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CRMRadius.radius10),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        active ? CRMColors.primary : CRMColors.commonBg),
                    value: progress, //精确模式，进度20%
                  ),
                ),
              )
            : SizedBox(
                height: 6,
              ));
  }

  ///卡片右上角状态标识
  Widget _buildCardStatus(newCustomerCard, active) {
    return Positioned(
      right: 0,
      top: 0,
      child: newCustomerCard
          ? const SizedBox.shrink()
          : active
              ? Container(
                  width: 36,
                  height: 36,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CRMColors.danger,
                      ),
                    ),
                  ),
                )
              : Image.asset(
                  'assets/images/complete.png',
                  width: ScreenFit.width(126),
                ),
    );
  }

  ///单个卡片
  Widget _buildCardItem(
      {bool active = true,
      @required String title,
      @required int total,
      @required int complete,
      @required String mark,
      bool showProgressIndicator = true,
      bool newCustomerCard = false,
      GestureTapCallback onTap}) {
    final Color textColor =
        active ? CRMColors.textLight : CRMColors.textLighter;
    return InkWell(
      onTap: onTap,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: ScreenFit.width(326),
            height: 166,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(CRMRadius.radius8)),
              boxShadow: [
                BoxShadow(
                    color: CRMColors.shawdowGrey,
                    blurRadius: 6,
                    spreadRadius: 2)
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenFit.height(16),
                  horizontal: ScreenFit.width(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  Text(
                    '$total ${newCustomerCard ? '个' : '单'}',
                    style: TextStyle(
                        fontSize: 32,
                        color: active
                            ? CRMColors.textDark
                            : CRMColors.textLighter),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '已完成 $complete ${newCustomerCard ? '个' : '单'}',
                      style: TextStyle(
                          fontSize: CRMText.smallTextSize, color: textColor),
                    ),
                  ),
                  _buildProgressIndicator(
                      showProgressIndicator,
                      active,
                      complete / (total + complete) >= 0
                          ? complete / (total + complete)
                          : 0.0),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenFit.height(8)),
                    child: Text(
                      mark,
                      style: TextStyle(
                          fontSize: CRMText.smallTextSize,
                          color: active
                              ? CRMColors.primary
                              : CRMColors.textLighter),
                    ),
                  )
                ],
              ),
            ),
          ),
          _buildCardStatus(newCustomerCard, active),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: AppbarWidget(
            brightness: Brightness.dark,
            backgroundColor: CRMColors.primary,
            color: Colors.white,
            leading: _permission.contains(Permission.INVITECODE)
                ? IconButton(
                    onPressed: () {
                      Utils.trackEvent('promo_code');
                      CRMNavigator.goPromotionCodePage();
                    },
                    icon: Icon(
                      CRMIcons.qrcode,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : Container(),
            actions: <Widget>[
              Consumer<NoticesModel>(
                builder: (context, noticesModel, child) {
                  return NoticeIcon(
                    count: noticesModel.unReadNoticeCount,
                    child: child,
                  );
                },
                child: IconButton(
                  onPressed: () {
                    Utils.trackEvent('notice');
                    CRMNavigator.goAnnouncementListPage();
                  },
                  icon: Icon(
                    CRMIcons.speaker,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          preferredSize: Size.fromHeight(44),
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CRMColors.primary,
          onRefresh: _refresh,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          height: 110,
                          width: double.infinity,
                          color: CRMColors.primary,
                        ),
                        _buildHomeCard(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenFit.height(50),
                          bottom: ScreenFit.height(25)),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          _buildGridItem(
                              imageSrc: 'assets/images/work_order.png',
                              title: '工单',
                              onTap: () {
                                Utils.trackEvent('work_order');
                                CRMNavigator.goWorkOrderListPage();
                              }),
                          if (_permission.contains(Permission.COUPON))
                            _buildGridItem(
                                imageSrc: 'assets/images/coupon.png',
                                title: '派券',
                                onTap: () {
                                  Utils.trackEvent('coupon_center');
                                  CRMNavigator.goCouponsIndexPage(0);
                                }),
                          _buildGridItem(
                              imageSrc: 'assets/images/customer.png',
                              title: '客户',
                              onTap: () {
                                Utils.trackEvent('customer_information');
                                CRMNavigator.goCustomerListPage('all', '');
                              }),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenFit.height(20)),
                      child: Wrap(
                        spacing: ScreenFit.width(32),
                        runSpacing: ScreenFit.height(20),
                        children: <Widget>[
                          _buildCardItem(
                              active: this._followInquiry3000Count != null &&
                                  this._followInquiry3000Count > 0,
                              title: '待跟进大单',
                              total: this._followInquiry3000Count ?? 0,
                              showProgressIndicator: false,
                              complete: 0,
                              mark: this._followInquiry3000Count != null &&
                                      this._followInquiry3000Count > 0
                                  ? '有${this._followInquiry3000Count}个可跟进的询价单'
                                  : '暂无可跟进的询价单',
                              onTap: () {
                                Utils.trackEvent('follow_important_order');
                                CRMNavigator.goInquiryHugeTransListPage();
                              }),
                          _buildCardItem(
                              active: this._orderFollowCount != null &&
                                  this._orderFollowCount > 0,
                              title: '待跟进订单',
                              total: this._orderFollowCount ?? 0,
                              complete: this._orderFinishCount ?? 0,
                              mark: this._orderFollowCount != null &&
                                      this._orderFollowCount > 0
                                  ? '有${this._orderFollowCount}个订单未付款可跟进'
                                  : '暂无未付款订单可跟进',
                              onTap: () {
                                Utils.trackEvent('follow_order');
                                CRMNavigator.goOrderListPage(3);
                              }),
                          _buildCardItem(
                              active: this._followInquiryCount != null &&
                                  this._followInquiryCount > 0,
                              title: '待跟进询价单',
                              total: this._followInquiryCount ?? 0,
                              complete: 0,
                              showProgressIndicator: false,
                              mark: this._followInquiryCount != null &&
                                      this._followInquiryCount > 0
                                  ? '有${this._followInquiryCount}个新询价单需跟进'
                                  : '暂无新的询价单可跟进',
                              onTap: () {
                                Utils.trackEvent('follow_inquiry');
                                CRMNavigator.goInquiryNumTransListViewPage();
                              }),
                          _buildCardItem(
                              title: '累计开拓新客数',
                              total: this._todaySuccess ?? 0,
                              complete: this._todaySuccess ?? 0,
                              showProgressIndicator: false,
                              newCustomerCard: true,
                              mark: '本月已转化新客总数${this._thisMonthSuccess ?? 0}',
                              onTap: () {
                                Utils.trackEvent('new_customer');
                                CRMNavigator.goCustomerListPage(
                                    'new', this._mfctyIds);
                              }),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
