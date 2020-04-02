import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/performance/gauge_chart.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/animate_container_widget.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/dash_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PerformancePage extends StatefulWidget {
  PerformancePage({Key key}) : super(key: key);

  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Map<String, dynamic> _achievementData = {};
  var _achievementDetailMap = {};
  var _partnerMonthTotalAmount;
  List _subTeamList = [];
  String _teamId;
  String _teamName;
  String _myTeamName = ''; // 我的团队名称
  bool _bottomTeam = false;
  Map<String, dynamic> _afterSaleCommissionVo = {};

  List<String> _colorList = [
    '#3D7EFF',
    '#FEA622',
    '#FFD83D',
    '#97FF3D',
    '#3DC3FF',
    '#FE6622',
    '#FF3D3D',
    '#FF3D86',
    '#DA3DFF',
    '#8122FE',
    '#3D4AFF',
    '#3DFFDE',
    '#02D52D',
  ];
  List<Color> _colorList2 = [
    Color(0xFF3D7EFF),
    Color(0xFFFEA622),
    Color(0xFFFFD83D),
    Color(0xFF97FF3D),
    Color(0xFF3DC3FF),
    Color(0xFFFE6622),
    Color(0xFFFF3D3D),
    Color(0xFFFF3D86),
    Color(0xFFDA3DFF),
    Color(0xFF8122FE),
    Color(0xFF3D4AFF),
    Color(0xFF3DFFDE),
    Color(0xFF02D52D),
  ];

  Duration duration = Duration(milliseconds: 200);
  GlobalKey _afterSaleKey = GlobalKey();
  GlobalKey _intenalLadderKey = GlobalKey();
  GlobalKey _foreignKey = GlobalKey();
  GlobalKey _tradeSaleKey = GlobalKey();
  GlobalKey _serviceSaleKey = GlobalKey();

  double _afterSaleBluePanelHeight = 0;
  double _intenalLadderBluePanelHeight = 0;
  double _foreignBluePanelHeight = 0;
  double _tradeBluePanelHeight = 0;
  double _serviceBluePanelHeight = 0;

  List<charts.Series<GaugeSegment, String>> _chartData = [];
  Widget _chartImg;

  //获取当前时间
  DateTime _dateTime = DateTime.now();
  int _year;
  int _month;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._year = _dateTime.year;
    this._month = _dateTime.month;

    if (_month - 1 == 0) {
      this._year = this._year - 1;
      this._month = 12;
    } else {
      this._month = this._month - 1;
    }

    _refresh();
  }

  void _getWidgetHeight(_) {
    //获取收缩面板蓝色区域高度
    const bluePanelPadding = 20;
    setState(() {
      _afterSaleBluePanelHeight = _afterSaleKey.currentContext
              .findRenderObject()
              .semanticBounds
              .size
              .height +
          bluePanelPadding;
      _intenalLadderBluePanelHeight = _intenalLadderKey.currentContext
              .findRenderObject()
              .semanticBounds
              .size
              .height +
          bluePanelPadding;
      _foreignBluePanelHeight = _foreignKey.currentContext
              .findRenderObject()
              .semanticBounds
              .size
              .height +
          bluePanelPadding;
      _tradeBluePanelHeight = _tradeSaleKey.currentContext
              .findRenderObject()
              .semanticBounds
              .size
              .height +
          bluePanelPadding;
      _serviceBluePanelHeight = _serviceSaleKey.currentContext
              .findRenderObject()
              .semanticBounds
              .size
              .height +
          bluePanelPadding;
    });
  }

  Future<void> _getAchievementData() async {
    ResultDataModel res = await httpGet(Apis.achievement,
        queryParameters: {
          "year": _year,
          "month": _month,
        },
        showLoading: true);
    if (res.code == 0) {
      if (mounted) {
        List<GaugeSegment> data = [];
        res.data['achievementDetailMap'].forEach((key, value) {
          data.add(
              GaugeSegment('${value['totalAmount']}元', value['totalAmount']));
        });
        setState(() {
          _partnerMonthTotalAmount = res.data['partnerMonthTotalAmount'];
          _achievementDetailMap = res.data['achievementDetailMap']; // 所有团队数据
          _achievementData =
              _achievementDetailMap[res.data['teamId']] ?? {}; // 单个团队数据
          _afterSaleCommissionVo =
              _achievementData['afterSaleCommissionVo'] ?? {};
          _bottomTeam = res.data['bottomTeam'];
          _myTeamName = res.data['teamName'] ?? '';
          _teamName = _myTeamName;
          if (data.isNotEmpty) {
            _chartData = [
              charts.Series<GaugeSegment, String>(
                id: 'Segments',
                colorFn: (_, index) =>
                    charts.Color.fromHex(code: _colorList[index]),
                domainFn: (GaugeSegment segment, _) => segment.segment,
                measureFn: (GaugeSegment segment, _) => segment.size,
                data: data,
                // labelAccessorFn: (GaugeSegment row, _) => '${row.year}: ${row.sales}',
              )
            ];
            _chartImg = GaugeChart(_chartData);
          } else {
            _chartImg = null;
          }
        });
        WidgetsBinding.instance.addPostFrameCallback(_getWidgetHeight);
      }
    } else {
      Utils.showToast(res.msg);
    }
  }

  Future<void> _getSubTeam() async {
    ResultDataModel res =
        await httpGet(Apis.achievementSubteam, showLoading: true);
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          _subTeamList = res.data;
          if (_subTeamList.length > 0) {
            _teamId = _subTeamList[0]['id'];
            _teamName = _subTeamList[0]['name'];
          }
        });
      }
    } else {
      Utils.showToast(res.msg);
    }
  }

  Future<void> _refresh() async {
    await _getSubTeam();
    _getAchievementData();
    // _getTeamsData();
  }

  void _showMonthPicker() {
    showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 1, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: DateTime(_year, _month))
        .then((date) {
      if (date != null) {
        setState(() {
          _dateTime = date;
          _year = date.year;
          _month = date.month;
        });
        _refresh();
      }
    });
  }

  Future<void> _appeal() async {
    var confirm = await MessageBox.confirm(context, '是否确认申诉？');
    if (confirm) {
      ResultDataModel res = await httpGet(
        Apis.achievementAppeal + '/${_achievementData['billId'] ?? ''}',
      );
      if (res.code == 0) {
        Utils.showToast("申诉成功");
        _getAchievementData();
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  Future<void> _confirm() async {
    ResultDataModel res = await httpGet(
        Apis.achievementConfirm + '/${_achievementData['billId'] ?? ''}');
    if (res.code == 0) {
      Utils.showToast("确认成功");
      _getAchievementData();
    } else {
      Utils.showToast(res.msg);
    }
  }

  void _showTeamPicker(BuildContext context, List list) {
    List<Widget> _list = [];
    list.forEach((item) {
      _list.add(InkWell(
        onTap: () {
          _achievementDetailMap.forEach((key, value) {
            if (item['id'] == value['teamId']) {
              setState(() {
                _teamId = item['id'];
                _teamName = item['name'];
                _achievementData = value ?? {};
                _afterSaleCommissionVo =
                    _achievementData['afterSaleCommissionVo'] ?? {};
              });
            }
          });
          WidgetsBinding.instance.addPostFrameCallback(_getWidgetHeight);
          rootNavigatorState.pop();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: CRMGaps.gap_dp20, horizontal: CRMGaps.gap_dp16),
          child: Text(item['name']),
        ),
      ));
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: _list);
        });
  }

  Future<void> _otherIncomeDialog() {
    return MessageBox.showContentDialog(context,
        title: '其他应收',
        content: Column(
          children: <Widget>[
            ...((_achievementData['otherIncomeVOS'] ?? []).map<Widget>((item) {
              if (item['directionType'] == 1) {
                return Padding(
                  padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('${item['reasonType'] ?? ''}'),
                      ),
                      Text('${item['amount'].toString() ?? ''}'),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })),
            CRMBorder.dividerDp1,
            Padding(
              padding: EdgeInsets.symmetric(vertical: CRMGaps.gap_dp8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '合计',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${_achievementData["otherIncome"] ?? ""}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _otherCostDialog() {
    return MessageBox.showContentDialog(context,
        title: '其他应付',
        content: Column(
          children: <Widget>[
            ...((_achievementData['otherOutlayVOS'] ?? []).map((item) {
              if (item['directionType'] == 2) {
                return Padding(
                  padding: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(item['reasonType'].toString()),
                      ),
                      Text(item['amount'].toString()),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })),
            CRMBorder.dividerDp1,
            Padding(
              padding: EdgeInsets.symmetric(vertical: CRMGaps.gap_dp8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '合计',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${_achievementData["otherOutlay"] ?? ""}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  ///构建主标题
  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.only(top: CRMGaps.gap_dp12, bottom: CRMGaps.gap_dp8),
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

  ///国内阶梯交易佣金卡片
  Widget _buildIntenalLadder() {
    List<Widget> domesticTradeStepCommissionVos = [];
    (_achievementData['domesticTradeStepCommissionVos'] ?? []).forEach((item) {
      domesticTradeStepCommissionVos.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Text('阶梯${item["step"] ?? ""}交易佣金点数:'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Row(
                children: <Widget>[
                  Text('${item["baseAmount"] ?? ""}*${item["rate"] ?? ""}%='),
                  Text(
                    "${item['amount'] ?? ''}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ]));
    });

    return AnimateContainerWidget(
      duration: duration,
      isCollapse: false,
      endHeight: _intenalLadderBluePanelHeight,
      title: '国内阶梯交易佣金',
      subTitle:
          '￥${_achievementData["domesticTradeStepCommissionAmount"] ?? ""}',
      child: Column(
          key: _intenalLadderKey,
          children: domesticTradeStepCommissionVos.isEmpty
              ? [Text('暂无数据')]
              : domesticTradeStepCommissionVos),
    );
  }

  ///非国内交易佣金卡片
  Widget _buildForeignCard() {
    List<Widget> notDomesticTradeCommissionVos = [];
    (_achievementData['notDomesticTradeCommissionVos'] ?? []).forEach((item) {
      if (item['fundType'] <= 5) {
        notDomesticTradeCommissionVos.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                child: Text(
                    '${item['fundTypeStr'] ?? ''}流水*${item['fundTypeStr'] ?? ''}${item['commissionTypeStr'] ?? ''}点数:'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                child: Row(
                  children: <Widget>[
                    Text('${item['baseAmount'] ?? ''}*${item['rate'] ?? ''}%='),
                    Text(
                      '${item['amount'] ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ]));
      }
    });
    return AnimateContainerWidget(
      duration: duration,
      endHeight: _foreignBluePanelHeight,
      title: '非国内交易佣金',
      subTitle:
          '￥${_achievementData["notDomesticTradeCommissionAmount"] ?? ""}',
      child: Column(
          key: _foreignKey,
          children: notDomesticTradeCommissionVos.isEmpty
              ? [Text('暂无数据')]
              : notDomesticTradeCommissionVos),
    );
  }

  ///交易佣金卡片
  Widget _buildTradeCard() {
    List<Widget> tradeCommissionVos = [];
    (_achievementData['tradeCommissionVos'] ?? []).forEach((item) {
      if (item['fundType'] >= 6) {
        tradeCommissionVos.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                child: Text(
                    '${item['fundTypeStr'] ?? ''}流水*${item['fundTypeStr'] ?? ''}${item['commissionTypeStr'] ?? ''}点数:'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
                child: Row(
                  children: <Widget>[
                    Text('${item['baseAmount'] ?? ''}*${item['rate'] ?? ''}%='),
                    Text(
                      '${item['amount'] ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ]));
      }
    });
    return AnimateContainerWidget(
      duration: duration,
      endHeight: _tradeBluePanelHeight,
      title: '交易佣金',
      subTitle: '￥${_achievementData["tradeCommissionAmount"] ?? ""}',
      child: Column(
          key: _tradeSaleKey,
          children:
              tradeCommissionVos.isEmpty ? [Text('暂无数据')] : tradeCommissionVos),
    );
  }

  ///服务佣金卡片
  Widget _buildServiceCard() {
    List<Widget> serviceCommissionVos = [];
    (_achievementData['serviceCommissionVos'] ?? []).forEach((item) {
      serviceCommissionVos.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Text(
                  '${item['fundTypeStr'] ?? ''}流水*${item['fundTypeStr'] ?? ''}${item['commissionTypeStr'] ?? ''}点数:'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Row(
                children: <Widget>[
                  Text('${item['baseAmount'] ?? ''}*${item['rate'] ?? ''}%='),
                  Text(
                    '${item['amount'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ]));
    });
    return AnimateContainerWidget(
        duration: duration,
        endHeight: _serviceBluePanelHeight,
        title: '服务佣金',
        subTitle: '￥${_achievementData["serviceCommissionAmount"] ?? ""}',
        child: Column(
            key: _serviceSaleKey,
            children: serviceCommissionVos.isEmpty
                ? [Text('暂无数据')]
                : serviceCommissionVos));
  }

  ///售后佣金卡片
  Widget _buildAfterSaleCard() {
    return AnimateContainerWidget(
      duration: duration,
      endHeight: _afterSaleBluePanelHeight,
      title: '售后佣金',
      subTitle: '￥${_achievementData["afterSaleCommissionAmount"] ?? ""}',
      child: Column(
          key: _afterSaleKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Text(
                  '本月退换货率：${_afterSaleCommissionVo["monthReturnRate"] ?? ""}%'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Row(
                children: <Widget>[
                  Text('${_afterSaleCommissionVo['monthSaleformula'] ?? ''}='),
                  Expanded(
                      child: Text(
                    '${_achievementData['afterSaleCommissionAmount'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _buildBlueHeader() {
    return Container(
        height: 145,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [CRMColors.primary, CRMColors.gradientLightBlue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _myTeamName,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: CRMGaps.gap_dp10),
                            child: Text(
                              '总收入',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: CRMGaps.gap_dp8),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 32),
                                  text: '${_partnerMonthTotalAmount ?? 0.0}',
                                  children: [
                                    TextSpan(
                                        text: '元',
                                        style: TextStyle(fontSize: 15))
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _showMonthPicker,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(12, 6, 2, 6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16))),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '$_year/$_month',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: CRMColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: CRMGaps.gap_dp4),
                              child: Icon(CRMIcons.right_arrow,
                                  size: CRMText.normalTextSize,
                                  color: CRMColors.primary),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16))),
            ),
          ],
        ));
  }

  Widget _buildChartWrap() {
    double itemWidth =
        (MediaQuery.of(context).size.width - CRMGaps.gap_dp16 * 2) / 3;
    List<Widget> items = [];
    int index = 0;
    _achievementDetailMap.forEach((key, value) {
      items.add(Container(
        width: itemWidth,
        child: Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(color: _colorList2[index]),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  value['teamName'] ?? '',
                  style: TextStyle(fontSize: 9),
                ),
              ),
            )
          ],
        ),
      ));
      index++;
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
            child: _buildTitle('团队收入情况'),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp10),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 168,
                    child: _chartImg ??
                        Center(
                          child: Text('暂无数据'),
                        ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: CRMGaps.gap_dp20),
                    padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp16),
                    child: Wrap(
                        // spacing: 8.0,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        children: items),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildOtherIncome() {
    return Container(
      height: 48,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text('其他应收'),
                      InkWell(
                        onTap: _otherIncomeDialog,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            CRMIcons.question,
                            size: ScreenFit.width(32),
                            color: CRMColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 38),
                  child: Text('¥${_achievementData["otherIncome"] ?? ""}'),
                )
              ],
            ),
          ),
          CRMBorder.dividerDp1
        ],
      ),
    );
  }

  Widget _buildOtherCost() {
    return Container(
      height: 48,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text('其他应付'),
                      InkWell(
                        onTap: _otherCostDialog,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            CRMIcons.question,
                            size: ScreenFit.width(32),
                            color: CRMColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 38),
                  child: Text('¥${_achievementData["otherOutlay"] ?? ""}'),
                )
              ],
            ),
          ),
          CRMBorder.dividerDp1
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppbarWidget(
        title: '业绩',
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CRMColors.primary,
        onRefresh: _refresh,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      _buildBlueHeader(),
                      if (_subTeamList.length > 1) _buildChartWrap(),
                      if (_subTeamList.length > 1)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CRMGaps.gap_dp16),
                          child: DashSeparator(),
                        ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            CRMGaps.gap_dp16, 6, 0, CRMGaps.gap_dp10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16))),
                        child: Column(
                          children: <Widget>[
                            if (_bottomTeam)
                              _buildTitle('${_teamName ?? ''} 收入明细'),
                            if (!_bottomTeam)
                              InkWell(
                                  onTap: () =>
                                      _showTeamPicker(context, _subTeamList),
                                  child: Row(
                                    children: <Widget>[
                                      _buildTitle('${_teamName ?? ''} 收入明细'),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: CRMGaps.gap_dp10),
                                        child: Icon(CRMIcons.right_arrow,
                                            size: 12),
                                      )
                                    ],
                                  )),
                            _buildIntenalLadder(),
                            _buildForeignCard(),
                            _buildTradeCard(),
                            _buildServiceCard(),
                            _buildAfterSaleCard(),
                            _buildOtherIncome(),
                            _buildOtherCost()
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (_achievementData['billStatus'] == 2)
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    top: CRMGaps.gap_dp10, bottom: CRMGaps.gap_dp16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: ScreenFit.width(328),
                      height: 44,
                      child: OutlineButton(
                          onPressed: _appeal,
                          child: Text('申诉',
                              style: TextStyle(color: CRMColors.primary)),
                          borderSide: BorderSide(color: CRMColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CRMRadius.radius4))),
                    ),
                    Container(
                        width: ScreenFit.width(328),
                        height: 44,
                        child: FlatButton(
                            color: CRMColors.primary,
                            onPressed: _confirm,
                            child: Text(
                              '确认',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(CRMRadius.radius4))))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
