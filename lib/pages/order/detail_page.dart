import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/pages/order/detail_list_page.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  final String _orderId;
  OrderDetailPage(this._orderId);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  GlobalKey _keyFilter = GlobalKey();
  Size _fixSize;
  // String carTypeDisplayName;
  Map<String, dynamic> baseInfo = {
    "org_name": null,
    "mobile": null,
    "pay_time": null,
    "contact_person": null,
    "address": null,
    'status_name': null,
  };

  final ScrollController _scrollViewController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();

    _loadOrderInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
  }

  // 加载订单基本信息
  _loadOrderInfo() async {
    ResultDataModel res = await httpGet(Apis.OrderInfo,
        queryParameters: {'orderId': widget._orderId}, showLoading: true);

    if (res.success == true) {
      setState(() {
        this.baseInfo = res.model;

        /// 获取元素的位置与尺寸
        WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
      });
    }
  }

  // 页面layout之后获取widget的位置和尺寸
  _afterLayout(_) {
    _getPositions('_keyFilter', _keyFilter);
    _getSizes('_keyFilter', _keyFilter);
  }

  _getPositions(log, GlobalKey globalKey) {
    RenderBox renderBoxFix = globalKey.currentContext?.findRenderObject();
    var positionFix = renderBoxFix.localToGlobal(Offset.zero);
    print('position of $log: $positionFix');
  }

  _getSizes(log, GlobalKey globalKey) {
    RenderBox renderBoxFix = globalKey.currentContext?.findRenderObject();
    _fixSize = renderBoxFix.size;
    setState(() {});
    print('SIZE of $log: $_fixSize');
  }

  @override
  Widget build(BuildContext context) {
    var body = NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: false, // true 固定在上方
              floating: true, // 是否将标题固定在上方
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    children: <Widget>[
                      _buildFactoryInfo(
                          context,
                          baseInfo['cust_id']?.toString() ?? '',
                          baseInfo['org_name'] ?? '未知',
                          baseInfo['mobile'] ?? '',
                          baseInfo['is_insurance_order'] ?? false),
                      Container(
                        height: 10,
                        color: CRMColors.commonBg,
                      ),
                      _buildOrderInfo(),
                      Container(
                        height: 10,
                        color: CRMColors.commonBg,
                      ),
                    ],
                  ),
                ),
              ),
              expandedHeight: (_fixSize == null
                  ? ScreenUtil.screenHeight
                  : _fixSize.height),
            ),
          ];
        },
        body: OrderDetailListWidget(widget._orderId, baseInfo));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '订单详情',
        actions: <Widget>[
          IconButton(
            onPressed: () {
              CRMNavigator.goWorkOrderAddPage(
                  orderNo: baseInfo['order_no'] ?? '');
            },
            icon: Icon(
              CRMIcons.workOrderAdd,
              size: ScreenFit.width(41),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Offstage(
                offstage: true,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      _buildFactoryInfo(
                          context,
                          baseInfo['cust_id']?.toString() ?? '',
                          baseInfo['org_name'] ?? '未知',
                          baseInfo['mobile'] ?? '',
                          baseInfo['is_insurance_order'] ?? false),
                      Container(
                        height: 10,
                        color: CRMColors.commonBg,
                      ),
                      _buildOrderInfo(),
                      Container(
                        height: 10,
                        color: CRMColors.commonBg,
                      ),
                    ],
                  ),
                  key: _keyFilter,
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  // 弹出确认弹窗
  Future<void> _showDialog(context, phone) async {
    var confirm = await MessageBox.confirm(context, phone, title: '确认拨打电话');
    if (confirm) {
      this._makePhoneCall('tel:$phone');
    }
  }

  // 打电话
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('拨打电话失败');
    }
  }

  // 汽修厂信息
  Widget _buildFactoryInfo(
      context, String id, String name, String phone, bool isInsurance) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp16),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () {
              CRMNavigator.goCustomerInfoPage(id, baseInfo['org_id']);
            },
            child: Row(
              children: <Widget>[
                Expanded(
                    child: CrmClip(
                  text: '$name',
                  child: Text(
                    '$name',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CRMColors.textNormal),
                  ),
                )),
                SizedBox(
                  width: 8,
                ),
                Offstage(
                  offstage: !isInsurance,
                  child: Image.asset(
                    'assets/images/insurance.png',
                    width: 20,
                    height: 20,
                  ),
                )
              ],
            ),
          )),
          InkWell(
            child: Icon(CRMIcons.phone),
            onTap: () {
              _showDialog(context, phone);
            },
          )
        ],
      ),
    );
  }

  // 信息显示条
  Widget _buildInfoItem(String title,
      {String value, Color color = CRMColors.textNormal, bool space = true}) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          child: Text('$title：$value',
              style: TextStyle(fontSize: CRMText.normalTextSize)),
        ),
        if (space) SizedBox(height: 8.0),
      ],
    );
  }

  // 订单信息
  Widget _buildOrderInfo() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: CRMGaps.gap_dp10, horizontal: CRMGaps.gap_dp16),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    CrmClip(
                      text: baseInfo['order_no'] ?? '',
                      child: _buildInfoItem('订单号', value: baseInfo['order_no']),
                    ),
                    _buildInfoItem('支付时间',
                        value: baseInfo['pay_time'] ?? '未知',
                        space: baseInfo['is_insurance_order'] != null &&
                                baseInfo['is_insurance_order']
                            ? true
                            : false),
                    baseInfo['is_insurance_order'] ?? false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildInfoItem('汽修厂名称',
                                  value: baseInfo['org_name'] ?? ''),
                              _buildInfoItem('联系人',
                                  value: baseInfo['contact_person'] ?? ''),
                              _buildInfoItem('联系方式',
                                  value: baseInfo['mobile'] ?? ''),
                              _buildInfoItem('地址',
                                  value: baseInfo['address'] ?? '未知'),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
              Text(
                baseInfo['status_name'] ?? '',
                style: TextStyle(
                    fontSize: CRMText.normalTextSize, color: CRMColors.warning),
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            onPressed: () {
              XiaobaQueryModel xiaoba = XiaobaQueryModel(
                  orderId: baseInfo['order_id'],
                  orderType: 1,
                  targetType: 1,
                  distributeTo: 'service');
              CRMNavigator.goXiaobaPage(xiaoba);
            },
            icon: Icon(
              CRMIcons.xiaoba,
              size: ScreenFit.width(40),
              color: CRMColors.textNormal,
            ),
          ),
        )
      ],
    );
  }
}
