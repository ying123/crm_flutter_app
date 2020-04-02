import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/blue_panel_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/crm_clip_widget.dart';
import 'package:crm_flutter_app/widgets/customer_info_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/flex_text_widget.dart';
import 'package:crm_flutter_app/widgets/image_text_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_border_widget.dart';
import 'package:crm_flutter_app/widgets/title_value_rich_widget.dart';
import 'package:crm_flutter_app/widgets/title_value_widget.dart';
import 'package:crm_flutter_app/widgets/white_panel_widget.dart';
import 'package:flutter/material.dart';

class ReturnDetailsPage extends StatefulWidget {
  final int id;
  final bool hasAuthForRate;
  ReturnDetailsPage(this.id, {Key key, this.hasAuthForRate}) : super(key: key);

  _ReturnDetailsPageState createState() => _ReturnDetailsPageState();
}

class _ReturnDetailsPageState extends State<ReturnDetailsPage> {
  TextEditingController _rateController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Map _baseInfo = {};
  Map _firstRp = {};
  Map _firstAudit = {};
  Map _orgReverse = {};
  int _customerId;
  double _damageAmount; // 折损费
  double _damageRate; //折损比率
  double _amountTag; //用于控制处理建议为不通过时，初始化预计退款为0.0

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _rateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get showTextField => _firstAudit['audit_result'] == 16; // 是否可输入
  String get _confirmRules =>
      _firstRp['conform_rules'] != null && _firstRp['conform_rules']
          ? '是'
          : '否';
  String get _dealAdvise => _firstRp['deal_advise'] ?? '';

  double get _amountFront {
    return (_firstAudit['unit_price'] ?? 0.0) +
        (_firstAudit['positive_freight'] ?? 0.0) -
        (_firstAudit['reverse_freight'] ?? 0.0) -
        (_damageAmount ?? 0.0);
  }

  ///预计退款
  String get _refundAmount {
    String compensation = _firstAudit["compensation"] != null
        ? '${_amountTag == null ? _firstAudit["compensation"] : 0.0}(汽配宝)'
        : "";
    return '${_amountTag ?? _amountFront?.toStringAsFixed(2)}元 ${compensation == '' ? '' : '+'} $compensation';
  }

  Future<void> _getData() async {
    ResultDataModel res = await httpGet(Apis.returnDetails,
        queryParameters: {"returnId": widget.id}, showLoading: true);
    if (mounted) {
      if (res.success) {
        setState(() {
          _baseInfo = res.model['after_sale_check_detail_dto'];
          _firstRp = res.model['first_responsibility_dto'];
          _firstAudit = res.model['return_goods_audit_money_dto'];
          _orgReverse = res.model['org_reverse_statistics_dto'];

          _damageAmount = _firstAudit['damage_amount'] != null
              ? double.parse('${_firstAudit['damage_amount']}')
              : 0.0;
          _damageRate = _firstAudit['damage_rate'] != null
              ? double.parse('${_firstAudit['damage_rate']}')
              : 0.0;
          if ((_firstRp['advise'] == null || !_firstRp['advise']) &&
              showTextField) {
            _amountTag = 0;
          }
          _getCustomerInfoByOrgId();
        });
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  Future _getCustomerInfoByOrgId() async {
    ResultDataModel res = await httpGet(
        '${Apis.CustomerInfoByOrgId}/${_baseInfo['org_id']}',
        showLoading: true);
    if (mounted) {
      if (res.code == 0) {
        setState(() {
          _customerId = int.parse(res.data['customerId']);
        });
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  void submitAudit(int auditResult) async {
    ResultDataModel res = await httpPost(Apis.submitAudit,
        data: {
          "return_id": _baseInfo['return_id'],
          "damage_rate": _rateController.text,
          "damage_amount": _damageAmount,
          "remark": _contentController.text,
          "audit_result": auditResult
        },
        showLoading: true);
    if (res.success == true) {
      Utils.showToast('操作成功！');
      _getData();
    } else {
      Utils.showToast(res.msg);
    }
  }

  //审核通过操作
  Future<void> _passAudit() async {
    if (_amountFront <= 0) {
      Utils.showToast('预计退款需要大于0');
      return false;
    }
    if (_rateController.text == null || _rateController.text == '') {
      Utils.showToast('请填写收取折损比率');
      return false;
    }
    bool res = await MessageBox.showCupertinoDialog(context, title: '操作确认',
        builder: (context) {
      return ListView(
        children: <Widget>[
          TitleValueRich(title: '是否符合平台规则：', value: _confirmRules),
          TitleValueRich(
              title: '处理建议：', value: _dealAdvise, valueColor: Colors.red),
          TitleValueRich(title: '收取折损比率：', value: '${_damageRate ?? ''}%'),
          TitleValueRich(
              title: '收取折损费：', value: _damageAmount?.toStringAsFixed(2)),
          TitleValueRich(
              title: '实付单价：', value: _firstAudit['unit_price'] ?? ''),
          TitleValueRich(
              title: '退正向运费：', value: _firstAudit['positive_freight'] ?? ''),
          TitleValueRich(
              title: '扣逆向运费：', value: _firstAudit['reverse_freight'] ?? ''),
          TitleValueRich(
              title: '对客赔付（汽配宝）：', value: _firstAudit['compensation'] ?? '0.0'),
          TitleValueRich(
              title: '预计退款：', value: _refundAmount, valueColor: Colors.red),
        ],
      );
    });
    if (res) {
      // 点击确认
      submitAudit(2);
    }
  }

//审核不通过
  Future<void> _noPassAudit() async {
    if (_rateController.text == null || _rateController.text == '') {
      Utils.showToast('请填写收取折损比率');
      return false;
    }
    bool res = await MessageBox.showCupertinoDialog(context, title: '二次确认',
        builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleValueRich(title: '是否符合平台规则：', value: _confirmRules),
          TitleValueRich(
              title: '处理建议：', value: _dealAdvise, valueColor: CRMColors.danger),
          TitleValueRich(
              title: '合伙人处理：', value: '不通过', valueColor: CRMColors.danger),
          TitleValueRich(title: '', value: '若关闭申请，请与客户进行沟通，避免投诉')
        ],
      );
    });
    if (res) {
      submitAudit(3);
    }
  }

  // 修改折损比率
  void _damageRateChange(value) {
    if (value != '') {
      double damageRate = double.parse(value);
      if (double.parse(value) > 100) {
        Utils.showToast('折损率不能超过100');
        _rateController.text = '100';
      } else {
        setState(() {
          _amountTag = null;
          _damageAmount = (_firstAudit['unit_price'] * damageRate) / 100;
          _damageRate = double.parse(_rateController.text);
        });
      }
    } else {
      setState(() {
        _amountTag = 0;
        _damageAmount = _firstAudit['damage_amount'] != null
            ? (_firstAudit['damage_amount'] as num).toDouble()
            : 0.0;
        _damageRate = _firstAudit['damage_rate'] != null
            ? (_firstAudit['damage_rate'] as num).toDouble()
            : 0.0;
      });
    }
  }

  //退换货率
  Widget _buildRateWidget() {
    return whitePanelWidget(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Text(
                  '一审退换货率（当月）：${_orgReverse != null ? _orgReverse["org_plan"] ?? '' : ''}'),
            ),
            widget.hasAuthForRate
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                        CRMGaps.gap_dp10, 0, 0, CRMGaps.gap_dp10),
                    child: InkWell(
                        onTap: () {
                          CRMNavigator.goReturnExchangeListPage(curTopTab: 0);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: CRMColors.warning,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            '数据解释',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: CRMText.smallTextSize),
                          ),
                        )),
                  )
                : Container()
          ],
        ),
        TitleValueRich(
            title: '不含三个原因退换货率（当月）：',
            value: _orgReverse != null
                ? _orgReverse["org_exclude_reason"] ?? ''
                : '',
            noBottomSpace: true),
      ],
    ));
  }

  ///订单信息
  Widget _buildOrderInfoWiget() {
    return Stack(
      children: <Widget>[
        whitePanelWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CrmClip(
                        text: '${_baseInfo["order_no"] ?? ''}',
                        child: Text('订单号：${_baseInfo["order_no"] ?? ''}'),
                      ),
                    ),
                    if (_baseInfo['book_info'] != null &&
                        _baseInfo['book_info'])
                      Text(
                        '订货',
                        style: TextStyle(color: CRMColors.danger),
                      ),
                  ],
                ),
              ),
              TitleValueRich(
                  title: '支付时间：', value: _baseInfo["pay_time"] ?? ''),
              FlexTextWidget(
                leftTitle: "销售价：",
                leftValue: _baseInfo["sale_price"] ?? '',
                rightTitle: "实付：",
                rightValue: _baseInfo["channel_pay_amount"] ?? '',
                noBottomSpace: true,
              ),
              if (_baseInfo["front_warehouse"] != null)
                TitleValueRich(
                  title: '供应商：',
                  value: _baseInfo["front_warehouse"] ?? '',
                  noBottomSpace: true,
                )
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 10,
          child: _baseInfo['is_front_warehouse'] != null &&
                  _baseInfo['is_front_warehouse']
              ? Image.asset(
                  'assets/images/front_ware_rect.png',
                  width: ScreenFit.width(128),
                )
              : Container(),
        )
      ],
    );
  }

  ///配件信息
  Widget _buildPartsInfoWidget() {
    return whitePanelWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleValueRich(
              title: '车型：',
              value:
                  '${_baseInfo["car_brand_name"] ?? "未知"} ${_baseInfo["car_system"] ?? ""}${_baseInfo['car_system'] != null && _baseInfo["car_type"] != null ? '/' : ''}${_baseInfo["car_type"] ?? ""}'),
          titleValueWidget(
              title: '配件编码：', value: _baseInfo["parts_code"] ?? ''),
          titleValueWidget(
              title: '配件名称：', value: _baseInfo["parts_name"] ?? ''),
          TitleValueRich(
              title: '品质：',
              value: _baseInfo["brand_name"] ?? '',
              noBottomSpace: true),
        ],
      ),
    );
  }

  ///退货信息
  Widget _buildReturnInfoWidget() {
    return whitePanelWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlexTextWidget(
            leftTitle: "单号类型：${_baseInfo["return_type"] ?? ''}",
            rightTitle: "退货单号：",
            rightValue: '${_baseInfo["return_code"] ?? ''}',
            rightClipable: true,
          ),
          TitleValueRich(title: '申请数量：', value: _baseInfo["num"] ?? ''),
          TitleValueRich(title: '申请时间：', value: _baseInfo["create_time"] ?? ''),
          TitleValueRich(
            title: '保质期：${_baseInfo["guarantee_period"] ?? ''}',
            value: _baseInfo["overGuarantee_period"] != null
                ? (_baseInfo["overGuarantee_period"]
                    ? "个月（已过质保期）"
                    : "个月（未过质保期）")
                : '',
            noBottomSpace: true,
          ),
        ],
      ),
    );
  }

  ///申请描述
  Widget _buildReasonWidget() {
    return whitePanelWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleValueRich(
              title: '申请原因：', value: _baseInfo["apply_reason"] ?? ''),
          TitleValueRich(title: '申请描述：', value: _baseInfo["remark"] ?? ''),
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: ScreenFit.width(90),
              runSpacing: 10,
              children: <Widget>[
                if (_baseInfo["problem_area_pic"] != null)
                  imageTextWidget(
                      src: '${_baseInfo["problem_area_pic"]}',
                      text: _baseInfo["is_packed"] ? '货物已安装' : '货物无安装',
                      tag: '1',
                      context: context),
                if (_baseInfo["outer_packing_pic"] != null)
                  imageTextWidget(
                      src: '${_baseInfo["outer_packing_pic"]}',
                      text:
                          _baseInfo["is_outer_pack_well"] ? '货物包装完好' : '货物包装破损',
                      tag: '2',
                      context: context),
                if (_baseInfo["product_identify_pic"] != null)
                  imageTextWidget(
                      src: '${_baseInfo["product_identify_pic"]}',
                      text: _baseInfo["is_product_identify_well"]
                          ? '产品标志完好'
                          : '产品标志破损',
                      tag: '3',
                      context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///一审定责
  Widget _buildAccountWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: CRMGaps.gap_dp10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DarkTitleWidget(
            title: '一审定责',
            size: Status.MINI,
          ),
          whitePanelWidget(
              noTopMargin: true,
              child: BluePanelWidget(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlexTextWidget(
                      leftTitle: '是否符合平台规则：',
                      leftValue: _confirmRules,
                      rightTitle: '处理建议：',
                      rightValue: _dealAdvise,
                      titleColor: CRMColors.textLight,
                    ),
                    FlexTextWidget(
                      leftTitle: "外包装：",
                      leftValue: _firstRp['out_package'] ?? '',
                      rightTitle: "内包装：",
                      rightValue: _firstRp['inner_package'] ?? '',
                      titleColor: CRMColors.textLight,
                    ),
                    FlexTextWidget(
                      leftTitle: "标签：",
                      leftValue: _firstRp['label'] ?? '',
                      rightTitle: "实物：",
                      rightValue: _firstRp['real_thing'] ?? '',
                      titleColor: CRMColors.textLight,
                    ),
                    TitleValueRich(
                        title: '对合伙人备注：',
                        value: _firstRp['remark_to_partner'] ?? '',
                        titleColor: CRMColors.textLight,
                        valueColor: CRMColors.textLight)
                  ],
                ),
              ))
        ],
      ),
    );
  }

  ///一审审核
  Widget _buildReviewWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: CRMGaps.gap_dp10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DarkTitleWidget(
            title: '一审审核',
            size: Status.MINI,
          ),
          whitePanelWidget(
              noTopMargin: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BluePanelWidget(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '收取折损比率：',
                                  style: TextStyle(color: CRMColors.textLight),
                                ),
                                if (showTextField)
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: ScreenFit.width(160),
                                        height: 32,
                                        child: borderTextFieldWidget(
                                            _rateController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            onChanged: _damageRateChange),
                                      ),
                                    ],
                                  ),
                                if (!showTextField)
                                  Text('${_firstAudit["damage_rate"] ?? ''}'),
                                Text('%'),
                                SizedBox(
                                  width: 10,
                                ),
                                Offstage(
                                  offstage: !(showTextField),
                                  child: GestureDetector(
                                    onTap: () {
                                      _rateController.text = '';
                                      _damageRateChange('');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: CRMColors.warning,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        '归零',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: CRMText.normalTextSize),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TitleValueRich(
                            title: '收取折损费：￥',
                            value: _damageAmount?.toStringAsFixed(2),
                            titleColor: CRMColors.textLight,
                          ),
                          TitleValueRich(
                            title: '实付单价：￥',
                            value: _firstAudit["unit_price"] ?? '',
                            titleColor: CRMColors.textLight,
                          ),
                          TitleValueRich(
                            title: '退正向运费：￥',
                            value: _firstAudit["positive_freight"] ?? '',
                            titleColor: CRMColors.textLight,
                          ),
                          TitleValueRich(
                            title: '扣逆向运费：￥',
                            value: _firstAudit["reverse_freight"] ?? '',
                            titleColor: CRMColors.textLight,
                          ),
                          if (_firstAudit["compensation"] != null)
                            TitleValueRich(
                              title: '对客赔付（汽配宝）：￥',
                              value: _firstAudit["compensation"] ?? '0.0',
                              titleColor: CRMColors.textLight,
                            ),
                          TitleValueRich(
                            title: '预计退款：',
                            value: _refundAmount,
                            titleColor: CRMColors.textLight,
                            valueColor: CRMColors.danger,
                          ),
                          if (showTextField)
                            borderTextFieldWidget(_contentController,
                                maxLines: 10, minLines: 5, hintText: '请输入内容'),
                          SizedBox(
                            height: CRMGaps.gap_dp10,
                          )
                        ],
                      ), onXiaobaTap: () {
                    XiaobaQueryModel xiaoba = XiaobaQueryModel(
                        orderDetailId: _baseInfo['order_detail_id'],
                        supplierId: _baseInfo['supplier_id'],
                        returnGoodsId: _baseInfo['return_id'],
                        returnGoodsDetailId: _baseInfo['return_detail_id'],
                        orderType: 1,
                        targetType: 1,
                        distributeTo: 'service');
                    CRMNavigator.goXiaobaPage(xiaoba);
                  }),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        top: CRMGaps.gap_dp20, bottom: CRMGaps.gap_dp26),
                    child: Text(
                      '注：通过会增大退换货率，拒绝请及时安抚客户',
                      style: CRMText.smallText,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppbarWidget(
            title: '退货详情',
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  CRMNavigator.goWorkOrderAddPage(
                      orderNo: _baseInfo['return_code'] ?? '');
                },
                icon: Icon(
                  CRMIcons.workOrderAdd,
                  size: ScreenFit.width(41),
                ),
              )
            ],
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: CRMColors.primary,
            onRefresh: _getData,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    CustomerInfoWidget(
                      contact: _baseInfo['contact_person'],
                      orgId: _baseInfo['org_id'],
                      customerId: _customerId.toString(),
                      orgName: _baseInfo['org_name'],
                      phone: _baseInfo['contact_mobile'],
                    ),
                    _buildRateWidget(),
                    _buildOrderInfoWiget(),
                    _buildPartsInfoWidget(),
                    _buildReturnInfoWidget(),
                    _buildReasonWidget(),
                    _buildAccountWidget(),
                    _buildReviewWidget()
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: showTextField
              ? BottomButtonWidget(
                  text: '审核通过',
                  onPressed: _passAudit,
                  secondaryText: '审核不通过',
                  secondaryOnPressed: _noPassAudit,
                )
              : null,
        ));
  }
}
