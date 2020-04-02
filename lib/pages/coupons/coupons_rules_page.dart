import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/circle_search_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponsRulePage extends StatefulWidget {
  @override
  _CouponsRulePageState createState() => _CouponsRulePageState();
}

class _CouponsRulePageState extends State<CouponsRulePage> {
  TextEditingController _controller = new TextEditingController();
  int selectType;
  String ruleName;
  String value;
  List _couponsList = new List();
  bool hasMore = true;
  bool _isloading = false;
  int _page = 1;
  int _pageSize = 12;

  @override
  void initState() {
    super.initState();
    this.selectType = 1;
    this.ruleName = '';
    _getData(page: 1);
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  // 修改筛选类型
  _changeSelectType(int index) {
    this.setState(() {
      this.selectType = index;
      this.ruleName = '';
      this._controller.text = '';
      this._isloading = false;
      this.hasMore = true;
      _getData(page: 1);
    });
  }

  // 停用优惠券的使用
  _disableCoupons(String ruleId) async {
    ResultDataModel res =
        await httpRequest('PUT', Apis.DisableCoupons, data: {"ruleId": ruleId});

    if (res.code == 0) {
      if (mounted) {
        this._isloading = false;
        this.hasMore = true;
        _getData(page: 1);
      }
    }
  }

  // 启用优惠券的使用
  _enableCoupons(String ruleId) async {
    ResultDataModel res =
        await httpRequest('PUT', Apis.EnableCoupons, data: {"ruleId": ruleId});

    if (res.code == 0) {
      if (mounted) {
        this._isloading = false;
        this.hasMore = true;
        _getData(page: 1);
      }
    }
  }

  // 关键字搜索
  _handleSearch(keyword) {
    setState(() {
      this.ruleName = keyword;
      this._isloading = false;
      this.hasMore = true;
      _getData(page: 1);
    });
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
        }
      });
      ResultDataModel res = await httpGet(Apis.CouponsRuleList,
          queryParameters: {
            "couponType": this.selectType,
            "ruleName": this.ruleName,
            "page": this._page,
            "limit": this._pageSize
          },
          showLoading: true);
      if (res.code == 0 && mounted) {
        if (res.data != null) {
          setState(() {
            if (page != null) {
              this._couponsList = res.data;
            } else {
              this._couponsList.addAll(res.data);
            }
            this._page++;
            this._isloading = false;
            // 判断是否有更多的数据
            if (res.data.length < this._pageSize) {
              setState(() {
                this.hasMore = false;
              });
            }
            print('当前的页码$_page,$hasMore');
          });
        } else {
          setState(() {
            this.hasMore = false;
            if (this._page == 1) {
              this._couponsList = [];
            }
          });
        }
      }
    }
  }

  // 状态栏选项
  Widget _buildFilterItem(String title, int type, {isDropsdownMenu = false}) {
    List<DropdownMenuItem> items = new List();

    DropdownMenuItem dropdownMenuItem1 =
        new DropdownMenuItem(child: Text('开'), value: '1');
    items.add(dropdownMenuItem1);

    DropdownMenuItem dropdownMenuItem2 =
        new DropdownMenuItem(child: Text('关'), value: '2');
    items.add(dropdownMenuItem2);

    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: ScreenFit.onepx(), color: CRMColors.border))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Offstage(
                offstage: !(isDropsdownMenu == false),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CRMText.largeTextSize,
                      fontWeight: FontWeight.w500,
                      color: selectType == type
                          ? CRMColors.primary
                          : CRMColors.textLight),
                ),
              ),
              Offstage(
                offstage: !(isDropsdownMenu == true),
                child: DropdownButton(
                  items: items,
                  hint: Text('状态'),
                  value: value,
                  underline: Container(),
                  isDense: true,
                  onChanged: (T) {
                    if (mounted) {
                      this.setState(() => {value = T});
                    }
                  },
                  style: TextStyle(
                      color: selectType == type
                          ? CRMColors.primary
                          : CRMColors.textLight),
                  iconSize: 20,
                ),
              )
            ],
          ),
        ),
        onTap: () => {_changeSelectType(type)},
      ),
    );
  }

  // 筛选状态栏
  Widget _buildFilterTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // _buildFilterItem('全部', 1),
          _buildFilterItem('满减', 1),
          _buildFilterItem('折扣', 2),
          // _buildFilterItem('状态', 4, isDropsdownMenu: true),
        ],
      ),
    );
  }

  // 规则项
  Widget _buildRuleItem(int id, String title, int isStop) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10, right: 0),
      title: Text(
        title,
        style: TextStyle(
            color: CRMColors.textLight, fontSize: CRMText.normalTextSize),
      ),
      trailing: CupertinoSwitch(
        activeColor: CRMColors.primary,
        value: isStop != 1,
        onChanged: (value) {
          print('value的值是什么,$value, $isStop');
          if (isStop != 1) {
            // 处于启用状态, 停用优惠券
            _disableCoupons(id.toString());
          } else {
            // 处于停用状态， 启用优惠券
            _enableCoupons(id.toString());
          }
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: PullRefreshWidget(_couponsList, (context, index) {
          return this._couponsList.length > 0
              ? Column(
                  children: <Widget>[
                    _buildRuleItem(
                        _couponsList[index]['ruleId'],
                        '${_couponsList[index]['ruleName']}',
                        _couponsList[index]['isStop']),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CRMBorder.dividerDp1,
                    ),
                    if (index == this._couponsList.length - 1) _getMoreWidget()
                  ],
                )
              : NoDataWidget();
        }, _getData, _onRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SearchCardWidget(
            textEditingController: _controller,
            hintText: '搜索优惠券名称或规则进行派券',
            onSubmitted: (text) {
              this._handleSearch(text);
            },
          ),
          _buildFilterTab(),
          CRMBorder.dividerDp1,
          _couponsList.length > 0
              ? Expanded(
                  child: _buildMainContent(),
                )
              : Expanded(
                  child: NoDataWidget(),
                ),
          BottomButtonWidget(
            text: '新增优惠券规则',
            onPressed: CRMNavigator.goCouponsCreatePages,
          )
        ],
      ),
    );
  }
}
