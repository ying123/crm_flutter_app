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

class ExchangeDetailsPage extends StatefulWidget {
  final int id;
  final bool hasAuthForRate;
  ExchangeDetailsPage(this.id, {Key key, this.hasAuthForRate})
      : super(key: key);

  _ExchangeDetailsPageState createState() => _ExchangeDetailsPageState();
}

class _ExchangeDetailsPageState extends State<ExchangeDetailsPage> {
  TextEditingController _contentController = TextEditingController();

  Map _baseInfo = {};
  Map _firstRp = {};
  Map _firstAudit = {};
  Map _orgReverse = {};
  int _customerId;
  int _haveGoodsValue;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _contentController.dispose();
    super.dispose();
  }

  bool get showTextField => _firstAudit['audit_result'] == 8;
  String get _confirmRules => _firstRp['conform_rules'] != null
      ? (_firstRp['conform_rules'] ? '是' : '否')
      : '';
  String get _dealAdvise => _firstRp['deal_advise'] ?? '';
  String get _outPackage => _firstRp['out_package'] ?? '';
  String get _innerPackage => _firstRp['inner_package'] ?? '';
  String get _label => _firstRp['label'] ?? '';
  String get _realThing => _firstRp['real_thing'] ?? '';

  Future _getData() async {
    ResultDataModel res = await httpGet(Apis.exchangeDetails,
        queryParameters: {"returnId": widget.id}, showLoading: true);
    if (mounted) {
      if (res.success) {
        setState(() {
          _baseInfo = res.model['after_sale_check_detail_dto'];
          _firstRp = res.model['ex_change_first_responsibility_dto'];
          _firstAudit = res.model['ex_change_audit_dto'];
          _orgReverse = res.model['org_reverse_statistics_dto'];
        });
        _getCustomerInfoByOrgId(); // 通过orgId获取客户信息
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
    ResultDataModel res = await httpPost(Apis.submitExAudit,
        data: {
          "return_id": _baseInfo['return_id'],
          "return_detail_id": _baseInfo['return_detail_id'],
          "remark": showTextField
              ? (_contentController.text ?? '')
              : (_firstAudit['remark'] ?? ''),
          "audit_result": auditResult ?? '',
          "have_goods": _haveGoodsValue ?? ''
        },
        showLoading: true);
    if (res.success == true) {
      _getData();
    }
    Utils.showToast(res.msg);
  }

  ///审核通过
  Future<void> _passAudit() async {
    if (_baseInfo['warehouse_type'] == 4 && _haveGoodsValue == null) {
      Utils.showToast('请选择前置仓库存');
      return;
    }
    bool res = await MessageBox.showCupertinoDialog(context, title: '操作确认',
        builder: (context) {
      return ListView(
        children: <Widget>[
          TitleValueRich(title: '是否符合平台规则：', value: _confirmRules),
          TitleValueRich(
              title: '处理建议：', value: _dealAdvise, valueColor: Colors.red),
          TitleValueRich(title: '外包装：', value: _outPackage),
          TitleValueRich(title: '内包装：', value: _innerPackage),
          TitleValueRich(title: '标签：', value: _label),
          TitleValueRich(title: '实物：', value: _realThing),
          TitleValueRich(
              title: '品质是否更新：',
              value: _firstRp['changed_factory_type'] != null
                  ? (_firstRp['changed_factory_type'] ? '是' : '否')
                  : ''),
          TitleValueRich(
              title: '配件编码是否更新：',
              value: _firstRp['changed_parts_code'] != null
                  ? (_firstRp['changed_parts_code'] ? '是' : '否')
                  : ''),
          TitleValueRich(
              title: '是否有库存：',
              value: _firstRp['have_goods'] == true ? '是' : '否'),
          TitleValueRich(
              title: '订货天数：', value: _firstRp['book_goods_days'] ?? ''),
          TitleValueRich(
              title: '是否高于原销售价：',
              value: _baseInfo['has_over_origin_purchase_price'] != null
                  ? (_baseInfo['has_over_origin_purchase_price'] > 0
                      ? '是'
                      : '否')
                  : ''),
        ],
      );
    });
    if (res) {
      submitAudit(2);
    }
  }

  Future<void> _noPassAudit() async {
    bool res = await MessageBox.showCupertinoDialog(context, title: '操作确认',
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
                    CrmClip(
                      text: _baseInfo["order_no"] ?? '',
                      child: Text('订单号：${_baseInfo["order_no"] ?? ''}'),
                    ),
                    if (_baseInfo['book_info'] != null &&
                        _baseInfo['book_info'])
                      Padding(
                        padding: EdgeInsets.only(left: CRMGaps.gap_dp10),
                        child: Text(
                          '订货',
                          style: TextStyle(
                              color: CRMColors.danger,
                              fontSize: CRMText.smallTextSize),
                        ),
                      ),
                  ],
                ),
              ),
              TitleValueRich(
                  title: '支付时间：', value: _baseInfo["pay_time"] ?? ''),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: TitleValueRich(
                        title: '销售价：', value: _baseInfo["sale_price"] ?? ''),
                  ),
                  Expanded(
                      child: TitleValueRich(
                          title: '实付：',
                          value: _baseInfo["channel_pay_amount"] ?? '')),
                ],
              ),
              TitleValueRich(
                  title: '销售单价：',
                  value: _baseInfo["unit_price"] ?? '',
                  noBottomSpace: true),
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
            rightTitle: "换货单号：",
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
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            child: TitleValueRich(
                          title: '是否符合平台规则：',
                          value: _firstRp['conform_rules'] != null
                              ? (_firstRp['conform_rules'] ? '是' : '否')
                              : '',
                          titleColor: CRMColors.textLight,
                        )),
                        Expanded(
                            child: TitleValueRich(
                          title: '处理建议：',
                          value: _firstRp['deal_advise'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            child: TitleValueRich(
                          title: '外包装：',
                          value: _firstRp['out_package'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                        Expanded(
                            child: TitleValueRich(
                          title: '内包装：',
                          value: _firstRp['inner_package'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            child: TitleValueRich(
                          title: '标签：',
                          value: _firstRp['label'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                        Expanded(
                            child: TitleValueRich(
                          title: '实物：',
                          value: _firstRp['real_thing'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            child: TitleValueRich(
                          title: '品质是否更新：',
                          value: _firstRp['changed_factory_type'] != null
                              ? (_firstRp['changed_factory_type'] ? '是' : '否')
                              : '',
                          titleColor: CRMColors.textLight,
                        )),
                        Expanded(
                            child: TitleValueRich(
                          title: '配件编码是否更新：',
                          value: _firstRp['changed_parts_code'] != null
                              ? (_firstRp['changed_parts_code'] ? '是' : '否')
                              : '',
                          titleColor: CRMColors.textLight,
                        )),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            child: TitleValueRich(
                          title: '是否有库存：',
                          value: _firstRp['have_goods'] != null
                              ? (_firstRp['have_goods'] ? '是' : '否')
                              : '',
                          titleColor: CRMColors.textLight,
                        )),
                        Expanded(
                            child: TitleValueRich(
                          title: '订货天数：',
                          value: _firstRp['book_goods_days'] ?? '',
                          titleColor: CRMColors.textLight,
                        )),
                      ],
                    ),
                    TitleValueRich(
                      title: '是否高于原销售价：',
                      value: _baseInfo['has_over_origin_purchase_price'] != null
                          ? (_baseInfo['has_over_origin_purchase_price'] == 1
                              ? '是'
                              : '否')
                          : '',
                      titleColor: CRMColors.textLight,
                    ),
                    TitleValueRich(
                      title: '对合伙人备注：',
                      value: _firstRp['remark_to_partner'] ?? '',
                      titleColor: CRMColors.textLight,
                      noBottomSpace: true,
                    ),
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
        children: <Widget>[
          DarkTitleWidget(
            title: '一审审核',
            size: Status.MINI,
          ),
          whitePanelWidget(
              noTopMargin: true,
              child: Column(
                children: <Widget>[
                  BluePanelWidget(
                      Column(
                        children: <Widget>[
                          showTextField
                              ? borderTextFieldWidget(_contentController,
                                  maxLines: 10, minLines: 5, hintText: '请输入备注')
                              : TitleValueRich(
                                  title: '备注：',
                                  value: _firstAudit['remark'] ?? '',
                                  titleColor: CRMColors.textLight,
                                ),
                          SizedBox(height: CRMGaps.gap_dp16)
                        ],
                      ), onXiaobaTap: () {
                    XiaobaQueryModel xiaoba = XiaobaQueryModel(
                        orderDetailId: _baseInfo['order_detail_id'],
                        supplierId: _baseInfo['supplier_id'],
                        exchangeGoodsId: _baseInfo['return_id'],
                        exchangeGoodsDetailId: _baseInfo['return_detail_id'],
                        orderType: 1,
                        targetType: 1,
                        distributeTo: 'service');
                    CRMNavigator.goXiaobaPage(xiaoba);
                  }),
                  if (showTextField && _baseInfo['warehouse_type'] == 4)
                    Row(
                      children: <Widget>[
                        Text(
                          '*',
                          style: TextStyle(color: CRMColors.danger),
                        ),
                        Text('前置仓有无货物：'),
                        Radio(
                          value: 1,
                          groupValue: _haveGoodsValue,
                          activeColor: CRMColors.primary,
                          onChanged: (val) {
                            setState(() {
                              _haveGoodsValue = val;
                            });
                          },
                        ),
                        Text('有货'),
                        Radio(
                          value: 0,
                          groupValue: _haveGoodsValue,
                          activeColor: CRMColors.primary,
                          onChanged: (val) {
                            setState(() {
                              _haveGoodsValue = val;
                            });
                          },
                        ),
                        Text('无货'),
                      ],
                    ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        top: CRMGaps.gap_dp20, bottom: CRMGaps.gap_dp26),
                    child: Text(
                      '注：通过会增大退换货率，拒绝请及时安抚客户。若新采购单价高于原采购价，不可换货',
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
    return Scaffold(
      appBar: AppbarWidget(
        title: '换货详情',
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
        onRefresh: _getData,
        color: Colors.white,
        backgroundColor: CRMColors.primary,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                CustomerInfoWidget(
                  contact: _baseInfo['contact_person'],
                  customerId: _customerId.toString(),
                  orgId: _baseInfo['org_id'],
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
              showConfirmButton:
                  _baseInfo['has_over_origin_purchase_price'] != 1,
              text: '审核通过',
              onPressed: _passAudit,
              secondaryText: '审核不通过',
              secondaryOnPressed: _noPassAudit,
            )
          : null,
    );
  }
}
