import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class CouponsTablePage extends StatefulWidget {
  @override
  _CouponsTablePageState createState() => _CouponsTablePageState();
}

class _CouponsTablePageState extends State<CouponsTablePage> {
  var userStatistics; // 用户报表
  var teamStatistics; // 团队报表
  bool _isloading = true;

  //构建主标题
  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.only(top: CRMGaps.gap_dp10, bottom: CRMGaps.gap_dp8),
      child: Row(
        children: <Widget>[
          Container(
            height: 20,
            width: ScreenFit.width(8),
            decoration: BoxDecoration(
                color: CRMColors.primary,
                borderRadius:
                    BorderRadius.all(Radius.circular(CRMRadius.radius4))),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: CRMText.hugeTextSize,
                color: CRMColors.textDark,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  ///蓝色标题
  Widget _buildBlueTitle(String title, String date) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
      decoration: BoxDecoration(
          color: CRMColors.blueLight,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Row(
        children: <Widget>[
          Text(title),
          Expanded(
            child: Text(
              date,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  ///单元格
  Widget _buildGridItem(String title, value,
      {bool noRightBorder = false,
      Color valueColor = CRMColors.textNormal,
      String type = 'money'}) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: CRMColors.borderLight,
                    width: noRightBorder ? 0 : ScreenFit.onepx()))),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: CRMColors.textLight, fontSize: CRMText.normalTextSize),
            ),
            SizedBox(
              height: CRMGaps.gap_dp8,
            ),
            Text(
              type == 'money' ? '¥$value' : type == 'percent' ? '$value%' : '',
              // '$value',
              style: TextStyle(
                  color: valueColor, fontSize: CRMText.normalTextSize),
            )
          ],
        ),
      ),
    ));
  }

  // 绘制表格内容
  Widget _buildContent(tradePrice, nicePrice, percent) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        _buildGridItem('交易额', tradePrice),
        _buildGridItem('优惠金额', nicePrice),
        _buildGridItem('费比', percent, noRightBorder: true, type: 'percent'),
      ],
    );
  }

  // 绘制详情表格
  Widget _buildTable(
      String title, String date, tradePrice, nicePrice, percent) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border:
            Border.all(color: CRMColors.borderLight, width: ScreenFit.onepx()),
      ),
      child: Column(
        children: <Widget>[
          _buildBlueTitle(title, date),
          _buildContent(tradePrice, nicePrice, percent),
        ],
      ),
    );
  }

  // 页面主体内容
  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.all(CRMGaps.gap_dp16),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: !(teamStatistics != null),
            child: Column(
              children: <Widget>[
                _buildTitle('团队总览'),
                _buildTable(
                    (teamStatistics != null &&
                            teamStatistics['bizName'] != null)
                        ? teamStatistics['bizName']
                        : '未知',
                    '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}',
                    (teamStatistics != null &&
                            teamStatistics['tradeAmount'] != null)
                        ? teamStatistics['tradeAmount']
                        : 0,
                    (teamStatistics != null &&
                            teamStatistics['couponAmount'] != null)
                        ? teamStatistics['couponAmount']
                        : 0,
                    (teamStatistics != null &&
                            teamStatistics['feeRate'] != null)
                        ? teamStatistics['feeRate']
                        : 0),
              ],
            ),
          ),
          _buildTitle('团队明细'),
          Expanded(
            child: Offstage(
              offstage: !(userStatistics.length > 0),
              child: ListView.builder(
                itemCount: userStatistics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: CRMGaps.gap_dp16),
                    child: _buildTable(
                        userStatistics[index]['bizName'],
                        '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}',
                        userStatistics[index]['tradeAmount'],
                        userStatistics[index]['couponAmount'],
                        userStatistics[index]['feeRate']),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 加载数据
    this._loadCouponsTable();
  }

  // 加载派券报表数据
  _loadCouponsTable() async {
    ResultDataModel res = await httpGet(Apis.CouponsTable, showLoading: true);

    if (res.code == 0) {
      if (mounted) {
        setState(() {
          this.userStatistics = res.data['userStatistics'];
          this.teamStatistics = res.data['teamStatistics'];
          this._isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? NoDataWidget(
            height: 0,
          )
        : _buildMainContent();
  }
}
