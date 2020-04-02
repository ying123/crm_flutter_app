import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CouponsCenterPage extends StatefulWidget {
  @override
  _CouponsCenterPageState createState() => _CouponsCenterPageState();
}

class _CouponsCenterPageState extends State<CouponsCenterPage> {
  int selectType; // 选择的优惠券类型 1：满减券 2：折扣券
  int selectId; // 选择的优惠券Id
  int detailId; // 优惠券规则Id
  String orgId; // 汽修厂Id
  String factoryName; // 选择的的汽修厂名称
  List _couponsList = new List();
  bool hasMore = true;
  bool _isloading = false;
  int _page = 1;
  int _pageSize = 10;

  // 跳转到汽修厂搜索页面
  _jumpToSearch() async {
    var res = await CRMNavigator.goFactorySearch();
    if (res != null && mounted) {
      setState(() {
        this.factoryName = res['name'];
        this.orgId = res['id']; // 返回的是mfctyId
      });
    }
  }

  // 回调函数，改变优惠券类型
  _changeSelectType(int type) {
    if (mounted) {
      setState(() {
        this.selectType = type;
        this.selectId = null;
        this._isloading = false;
        this.hasMore = true;
        this._getData(page: 1);
      });
    }
  }

  // 初始化状态值
  @override
  void initState() {
    super.initState();
    this.selectType = 1;
    this.selectId = null;
    this.factoryName = '';

    // 请求列表数据
    this._getData(page: 1);
  }

  // 页面销毁
  @override
  void dispose() {
    super.dispose();
  }

  // 弹出确认弹窗
  Future<void> _showDialog(context) async {
    var confirm = await MessageBox.confirm(context, '请确认是否派发优惠券?');
    if (confirm) {
      this._giveCoupons();
    }
  }

  // 派发优惠券
  _giveCoupons() async {
    Utils.trackEvent('send_coupon');
    ResultDataModel res = await httpPost(Apis.GiveCoupons,
        data: {'orgId': orgId, 'ruleId': selectId, 'ruleDetailId': detailId},
        showLoading: true);

    if (res.code == 0) {
      if (mounted) {
        Utils.showToast('派券成功!');
        setState(() {
          this.selectId = null;
        });
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    this.hasMore = true;
    this._isloading = false;
    await _getData(page: 1);
  }

  // more or complete widget
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  Future<void> _getData({page}) async {
    if (this.hasMore && !this._isloading && mounted) {
      setState(() {
        this._isloading = true;
        if (page != null) {
          this._page = page;
          this._couponsList.length = 0;
        }
      });
      ResultDataModel res = await httpGet(Apis.CouponsRuleList,
          queryParameters: {
            "couponType": this.selectType,
            "page": this._page,
            "limit": this._pageSize
          },
          showLoading: true);
      if (res.code == 0 && mounted) {
        if (res.data != null) {
          setState(() {
            this._couponsList.addAll(res.data);
            this._page++;
            this._isloading = false;
            print('当前的页码$_page');
            // 判断是否有更多的数据
            if (res.data.length < this._pageSize) {
              setState(() {
                this.hasMore = false;
              });
            }
          });
        } else {
          setState(() {
            this.hasMore = false;
            this._isloading = false;
          });
        }
      }
    }
  }

  // 优惠券
  Widget _buildCoupons(
      String title, detailVOs, int id, int usable, int couponType) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              usable == 2
                  ? Image.asset(
                      'assets/images/coupon_bg_new.png',
                      width: ScreenFit.width(692),
                      height: 72,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/coupon_bg_new_off.png',
                      width: ScreenFit.width(692),
                      height: 72,
                      fit: BoxFit.cover,
                    ),
              Positioned(
                top: 22,
                left: 24,
                child: Container(
                    width: ScreenFit.width(400),
                    child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: title,
                          style: TextStyle(
                              color: usable == 2
                                  ? CRMColors.primary
                                  : CRMColors.textNormal,
                              fontSize: 22),
                        ))),
              ),
              Positioned(
                top: 13,
                right: ScreenFit.width(192),
                child: InkWell(
                    onTap: () {
                      CRMNavigator.goCouponsRecords(
                          id, '$title ${couponType == 1 ? '满减券' : '折扣券'}');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '派',
                            style: TextStyle(
                                fontSize: 10,
                                color: CRMColors.warning,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '券',
                            style: TextStyle(
                                fontSize: 10,
                                color: CRMColors.warning,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '记',
                            style: TextStyle(
                                fontSize: 10,
                                color: CRMColors.warning,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '录',
                            style: TextStyle(
                                fontSize: 10,
                                color: CRMColors.warning,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
              ),
              Positioned(
                top: 22,
                right: ScreenFit.height(15),
                child: Column(
                  children: <Widget>[
                    Offstage(
                      offstage: !(selectId == id),
                      child: SizedBox(
                        height: 30,
                        width: ScreenFit.width(150),
                        child: RaisedButton(
                          color: CRMColors.warning,
                          child: Text("已选择",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CRMText.smallTextSize,
                              )),
                          onPressed: () => {},
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !!(selectId == id),
                      child: SizedBox(
                        height: 30,
                        width: ScreenFit.width(150),
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: usable == 2
                                  ? CRMColors.warning
                                  : CRMColors.borderDark),
                          child: Text("选择使用",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: usable == 2
                                      ? CRMColors.warning
                                      : CRMColors.borderDark)),
                          onPressed: () => {
                            if (usable == 2 && mounted)
                              {
                                this.setState(() => {
                                      this.selectId = id,
                                      this.detailId =
                                          detailVOs[0]['ruleDetailId']
                                    })
                              }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: <Widget>[
        Expanded(
            child: PullRefreshWidget(_couponsList, (context, index) {
          return this._couponsList.length > 0
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: CRMGaps.gap_dp10,
                    ),
                    _buildCoupons(
                        '${_couponsList[index]['ruleName']}',
                        _couponsList[index]['detailVos'],
                        _couponsList[index]['ruleId'],
                        _couponsList[index]['isStop'],
                        _couponsList[index]['couponType']),
                    if (index == this._couponsList.length - 1) _getMoreWidget()
                  ],
                )
              : NoDataWidget();
        }, _getData, _onRefresh)),
        SafeArea(
          child: Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: CRMColors.shawdowGrey,
                    blurRadius: 6,
                    spreadRadius: 2)
              ],
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: FlatButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: Text(
                        '新增优惠券规则',
                        style:
                            CRMText.bottomButtonText(color: CRMColors.primary),
                      ),
                      onPressed: CRMNavigator.goCouponsCreatePages,
                    )),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (selectId != null && this.factoryName != '') {
                        this._showDialog(context);
                      }
                    },
                    child: Container(
                      color: (selectId != null && this.factoryName != '')
                          ? CRMColors.primary
                          : CRMColors.borderDark,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text('派券',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(
                  color: CRMColors.borderLight, width: ScreenFit.onepx()))),
      child: Column(
        children: <Widget>[
          formWidget('汽修厂名称：',
              value:
                  '${this.factoryName == '' ? '请输入汽修厂的名称' : this.factoryName}',
              isRequired: true,
              type: 'popMenu',
              callback: _jumpToSearch),
          formWidget('优惠券种类',
              value: this.selectType.toString(),
              isRequired: true,
              type: 'radio',
              childcallback: _changeSelectType),
          _couponsList.length > 0
              ? Expanded(child: _buildMainContent())
              : NoDataWidget()
        ],
      ),
    );
  }
}
