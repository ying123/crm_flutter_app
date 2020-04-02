import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponsCreatePages extends StatefulWidget {
  @override
  _CouponsCreatePagesState createState() => _CouponsCreatePagesState();
}

class _CouponsCreatePagesState extends State<CouponsCreatePages> {
  int selectType;
  TextEditingController _quotaController = new TextEditingController(); // 消费的金额
  TextEditingController _moneyController = new TextEditingController(); // 优惠的金额
  TextEditingController _discountController = new TextEditingController(); // 折扣

  FocusNode _moneyFocus = FocusNode();
  FocusNode _quotaFocus = FocusNode();
  FocusNode _discountFocus = FocusNode();

  bool _loading = false;

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _moneyController.dispose();
    _quotaController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  // 蓝色标题
  Widget _buildBlueTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: CRMGaps.gap_dp20, vertical: CRMGaps.gap_dp12),
      decoration: BoxDecoration(
          color: CRMColors.blueLight,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Text(title),
    );
  }

  // 优惠券类型
  Widget _couponsContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          left: CRMGaps.gap_dp16,
          right: CRMGaps.gap_dp16,
          top: CRMGaps.gap_dp16,
          bottom: CRMGaps.gap_dp10),
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: !(this.selectType == 1), // 满减券
            child: Row(
              children: <Widget>[
                Text('满'),
                SizedBox(width: CRMGaps.gap_dp10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: CRMColors.borderDark,
                            width: ScreenFit.onepx()),
                      ),
                    ),
                    child: TextField(
                      keyboardAppearance: Brightness.light,
                      focusNode: _quotaFocus,
                      controller: _quotaController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4)),
                    ),
                  ),
                ),
                SizedBox(width: CRMGaps.gap_dp10),
                Text('减'),
                SizedBox(width: CRMGaps.gap_dp10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: CRMColors.borderDark,
                            width: ScreenFit.onepx()),
                      ),
                    ),
                    child: TextField(
                      keyboardAppearance: Brightness.light,
                      focusNode: _moneyFocus,
                      controller: _moneyController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Offstage(
            offstage: !(this.selectType == 2), // 折扣券
            child: Row(
              children: <Widget>[
                Text('优惠折扣(%)：'),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: CRMColors.borderDark,
                            width: ScreenFit.onepx()),
                      ),
                    ),
                    child: TextField(
                      focusNode: _discountFocus,
                      keyboardAppearance: Brightness.light,
                      controller: _discountController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 优惠券填写框
  Widget _buildCoupons() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border:
              Border.all(color: CRMColors.borderDark, width: ScreenFit.onepx()),
        ),
        child: Column(
          children: <Widget>[
            _buildBlueTitle('优惠券内容:'),
            _couponsContent(),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    this.selectType = 1;
  }

  // 验证是否可以创建优惠前
  _validateCanCreateCoupons() {
    RegExp reg = RegExp(r"^\d*$");
    if (this.selectType == 1) {
      if (_moneyController.text != '' && _quotaController.text != '') {
        bool moneyMatch = reg.hasMatch(_moneyController.text); // 优惠金额
        bool quotaMatch = reg.hasMatch(_quotaController.text); // 消费金额
        if (!moneyMatch || !quotaMatch) {
          Utils.showToast('请输入正确的数值');
          return false;
        }

        if (int.parse(_moneyController.text) >=
            int.parse(_quotaController.text)) {
          Utils.showToast('优惠金额不能高于消费金额');
          return false;
        }

        return moneyMatch &&
            quotaMatch &&
            int.parse(_moneyController.text) < int.parse(_quotaController.text);
      } else {
        Utils.showToast('消费金额和优惠金额不能为空');
        return false;
      }
    } else {
      if (_discountController.text != '' &&
          reg.hasMatch(_discountController.text)) {
        int _discount = int.parse(_discountController.text ?? '');
        if (_discount <= 0 || _discount > 100) {
          Utils.showToast('折扣必须小于100%哦!');
          return false;
        }
        return _discountController.text != '' &&
            _discount != null &&
            _discount > 0 &&
            _discount <= 100;
      } else {
        if (_discountController.text == '') {
          Utils.showToast('折扣不能为空');
        } else {
          Utils.showToast('请输入正确的数值');
        }
        return false;
      }
    }
  }

  // 创建优惠券
  _buidCoupons() async {
    if (_loading) return;
    if (_validateCanCreateCoupons() && mounted) {
      setState(() {
        this._loading = true;
      });
      Utils.trackEvent('create_coupon');
      ResultDataModel res = await httpPost(Apis.CreateCouponsRule, data: {
        "couponType": this.selectType,
        "quota": selectType == 2 ? 0 : _quotaController.text,
        "money": selectType == 2 ? 0 : _moneyController.text,
        "discount": selectType == 1 ? 0 : _discountController.text
      });
      setState(() {
        this._loading = false;
      });

      if (res.code == 0) {
        Utils.showToast(res.data);
        // CRMNavigator.goCouponsIndexPage(2, replace: true);
        var params = {'tabIndex': 2};
        rootNavigatorState.pop(params);
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 选择优惠券类型
    _changeSelectType(int type) {
      setState(() {
        this.selectType = type;
        if (this.selectType == 2) {
          _moneyController.text = '';
          _quotaController.text = '';
          FocusScope.of(context).requestFocus(_discountFocus);
        } else if (this.selectType == 1) {
          _discountController.text = '';
          FocusScope.of(context).requestFocus(_quotaFocus);
          _moneyFocus.unfocus();
          _discountFocus.unfocus();
        }
      });
    }

    return Scaffold(
      appBar: AppbarWidget(title: '新增优惠券规则'),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(CRMGaps.gap_dp10),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                formWidget('优惠券规则',
                    isRequired: true,
                    type: 'radio',
                    value: this.selectType.toString(),
                    childcallback: _changeSelectType),
                // CRMBorder.dividerDp1,
                SizedBox(height: 20),
                _buildCoupons(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: CRMColors.borderDark,
                                        width: ScreenFit.onepx()))),
                            child: Text(
                              '取消',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onTap: rootNavigatorState.pop,
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                color: CRMColors.primary,
                                border: Border(
                                    top: BorderSide(
                                        color: CRMColors.primary,
                                        width: ScreenFit.onepx()))),
                            child: Text(
                              '确定',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          onTap: _buidCoupons,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
