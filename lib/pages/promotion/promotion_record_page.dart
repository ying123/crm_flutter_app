import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class PromotionRecordPage extends StatefulWidget {
  final Map query;
  PromotionRecordPage({this.query});
  @override
  _PromotionRecordPageState createState() => _PromotionRecordPageState();
}

class _PromotionRecordPageState extends State<PromotionRecordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _list = [];
  int _page = 1;
  int _pageSize = 10;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;
  int _todaySuccess = 0;
  int _thisMonthSuccess = 0;

  @override
  initState() {
    super.initState();
    _getData();
    _getStatistics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///获取邀请码的使用情况
  _getStatistics() async {
    ResultDataModel res =
        await httpGet(Apis.TeamReferralLogStatistics, queryParameters: {});
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          _todaySuccess = res.data['todaySuccess'];
          _thisMonthSuccess = res.data['thisMonthSuccess'];
        });
      }
    } else {
      Utils.showToast(res.msg);
    }
  }

  void resetState() {
    setState(() {
      _list = [];
      _page = 1;
      _hasMore = true;
      _loading = false;
    });
  }

  Future<void> _getData({page, Map params}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      _page = page;
      _list = [];
      _hasMore = true;
    }
    if (this._hasMore) {
      var data;
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> query = params != null
          ? {"page": this._page, "limit": this._pageSize, ...params}
          : {
              "page": this._page,
              "limit": this._pageSize,
            };

      ResultDataModel resultDataModel =
          await httpGet(Apis.TeamReferralLogPage, queryParameters: query);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (resultDataModel.code == 0) {
        data = resultDataModel.data;
        if (this.mounted) {
          setState(() {
            this._list.addAll(data['list']); //拼接
            this._page++;
          });
          //判断是否是最后一页
          if (data['total'] < (this._page * this._pageSize)) {
            setState(() {
              this._hasMore = false;
            });
          }
        }
      } else {
        Utils.showToast(resultDataModel.msg);
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    await _getData(page: 1);
  }

  // more or complete widget
  Widget _getMoreWidget() {
    return _hasMore ? LoadingMoreWidget() : LoadingCompleteWidget();
  }

  ///统计数据卡片
  Widget _buildStatisticsCard({
    String desc,
    int count,
    String image,
    Color countColor,
    Color descColor,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$count' ?? 0,
                  style: TextStyle(color: countColor, fontSize: 30),
                ),
                SizedBox(
                  width: CRMGaps.gap_dp8,
                ),
                Text(
                  '家',
                  style: TextStyle(
                    color: descColor,
                  ),
                ),
              ],
            ),
            Text(
              desc ?? '',
              style: TextStyle(
                color: descColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 推广状态（0:审核中,1:推广成功(客户注册审核通过),2:推广失败(客户注册审核不通过)）
  String getStatusName(int status) {
    String statusName = '';
    switch (status) {
      case 0:
        statusName = '审核中';
        break;
      case 1:
        statusName = '推广成功';
        break;
      case 2:
        statusName = '推广失败';
        break;
    }
    return statusName;
  }

  Color getStatusColor(int status) {
    Color statusColor = CRMColors.textLight;
    switch (status) {
      case 0:
        statusColor = CRMColors.warning;
        break;
      case 1:
        statusColor = CRMColors.success;
        break;
      case 2:
        statusColor = CRMColors.danger;
        break;
    }
    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CRMColors.commonBg,
        key: _scaffoldKey,
        appBar: AppbarWidget(title: '推广记录', actions: <Widget>[
          IconButton(
            icon: Icon(
              CRMIcons.filter,
              color: CRMColors.textNormal,
              size: ScreenFit.width(42),
            ),
            onPressed: () async {
              var result = await CRMNavigator.goPromotionFilterPage();

              ///筛选页点击确定后，重新刷新列表数据
              if (result != null) {
                resetState();
                await _getData(params: result);
              }
            },
          ),
        ]),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                height: 108,
                padding: EdgeInsets.fromLTRB(
                    ScreenFit.width(26), 20, ScreenFit.width(26), 20),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _buildStatisticsCard(
                        image: 'assets/images/record_date.png',
                        count: _todaySuccess,
                        desc: '今日合计推广码注册数',
                        countColor: CRMColors.primary,
                        descColor: CRMColors.textLight),
                    SizedBox(
                      width: ScreenFit.width(34),
                    ),
                    _buildStatisticsCard(
                        image: 'assets/images/record_month.png',
                        count: _thisMonthSuccess,
                        desc: '本月合计推广码注册数',
                        countColor: Colors.white,
                        descColor: Colors.white),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            _buildTableRow(
              color: Theme.of(context).primaryColor,
              children: <Widget>[
                //在一行中初始化一个单元格
                _buildTableCell('注册时间', fontColor: Colors.white, fontSize: 15),
                _buildTableCell('注册汽修厂', fontColor: Colors.white, fontSize: 15),
                _buildTableCell('账号状态', fontColor: Colors.white, fontSize: 15),
              ],
            ),
            Expanded(
                child: PullRefreshWidget(_list, (context, index) {
              return _list.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        _buildTableRow(
                          color: index % 2 == 0
                              ? Colors.white
                              : CRMColors.blueLight,
                          children: <Widget>[
                            //在一行中初始化一个单元格
                            _buildTableCell(
                                this._list[index]['createDate'].split(' ')[0],
                                fontColor: CRMColors.textLight,
                                fontSize: 14),
                            _buildTableCell(this._list[index]['orgName'],
                                fontColor: CRMColors.textLight, fontSize: 14),
                            _buildTableCell(
                                this.getStatusName(this._list[index]['status']),
                                fontColor: this.getStatusColor(
                                    this._list[index]['status']),
                                fontSize: 14)
                          ],
                        ),
                        if (index == this._list.length - 1) _getMoreWidget()
                      ],
                    )
                  : (_loading ? LoadingMoreWidget() : NoDataWidget());
            }, _getData, _onRefresh))
          ],
        ));
  }

  ///构建一个单元格
  Widget _buildTableCell(String label,
      {Color fontColor = CRMColors.textLight,
      double fontSize = CRMText.normalTextSize}) {
    return Expanded(
      child: Container(
        //单元格内对齐方式
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
              color: CRMColors.borderLight, width: ScreenFit.onepx()),
        )),
        //文本
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
          ),
        ),
        height: 40,
      ),
    );
  }

  Widget _buildTableRow({
    Color color = Colors.white,
    List<Widget> children,
  }) {
    return Container(
      color: color,
      child: Row(
        children: children,
      ),
    );
  }
}
