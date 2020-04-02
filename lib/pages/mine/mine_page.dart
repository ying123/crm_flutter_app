import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:crm_flutter_app/config/permission.dart';
import 'package:crm_flutter_app/utils/check_update_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/link_cell_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:xiaobaim/xiaobaim.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  String _version = '';
  double _commissionTotal;
  double _incomeTotal;
  bool _showCommissionCard = false;
  Map _commissionDetails = {};
  Map _costDetail = {};
  List _permission = [];
  var _userName;
  String duwnloadMsg = '';
  String file = '';
  CancelFunc cancelFunc;

  @override
  void initState() {
    super.initState();
    _refresh();
    _getPermissionList();
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
      _getCurVersion(),
      _getCommission(),
      _getUserInfo()
    ];
    await Future.wait(tickets);
  }

  Future<void> _getCurVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        this._version = packageInfo.version;
      });
    });
  }

  Future<void> _getCommission() async {
    ResultDataModel res = await httpGet(Apis.commission);
    if (mounted && res.code == 0) {
      setState(() {
        _showCommissionCard = true;
        _commissionTotal = res.data['commissionTotal'].toDouble();
        _incomeTotal = res.data['incomeTotal'].toDouble();
        _commissionDetails = res.data['commissionDetail'];
        _costDetail = res.data['costDetail'];
      });
    } else {
      if (res.code == 403) return;
      Utils.showToast(res.msg);
    }
  }

  Future<void> _getUserInfo() async {
    ResultDataModel res = await httpGet(Apis.userInfo);
    if (res.code == 0) {
      setState(() {
        _userName = res.data['realName'];
      });
    } else {
      Utils.showToast(res.msg);
    }
  }

  Future _goCostEntryPage() async {
    Utils.trackEvent('cost_record');
    if (_costDetail.isNotEmpty) {
      await CRMNavigator.goCostEntryPage(costDto: _costDetail);
    } else {
      await CRMNavigator.goCostEntryPage();
    }
    _getCommission(); // 录入成本页面返回来时刷新数据
  }

  //佣金预测说明弹窗
  void _showComssionDialog() {
    MessageBox.showContentDialog(context,
        title: '佣金预测说明',
        subTitle: '（各类激励及应收均未统计在内）',
        confirmButtonText: '确定',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp16),
              child: CRMBorder.dividerDp1,
            ),
            _buildComissionText(title: '佣金预测=交易佣金+服务佣金'),
            _buildComissionText(
                title: '交易佣金',
                value:
                    '=国内品牌件合伙人净流水*国内品牌件阶梯交易佣金点数 + 非国内品牌件合伙人净流水*非国内品牌件交易佣金点数 + 油品合伙人净流水*油品交易佣金点数＋轮胎合伙人净流水*轮胎交易佣金点数'),
            _buildComissionText(title: '服务佣金', value: '=合伙人净流水*服务佣金点数'),
            _buildComissionText(title: '合伙人净流水', value: '=现支付金额-现金运费-现金总退款'),
          ],
        ));
  }

  ///盈利预测说明弹窗
  void _showIncomeDialog() {
    MessageBox.showContentDialog(context,
        title: '盈利预测说明',
        subTitle: '（各类激励及应收均未统计在内）',
        confirmButtonText: '确定',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: CRMGaps.gap_dp16),
              child: CRMBorder.dividerDp1,
            ),
            _buildComissionText(title: '盈利预测=佣金预测-成本'),
            Text('成本=配送员工资-业务员工资-仓库月租金-每月油耗费-车辆折损费-月管理费用-其他费用')
          ],
        ));
  }

  ///佣金预测弹窗文字
  Widget _buildComissionText({@required String title, String value = ''}) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: RichText(
                  text: TextSpan(
                      text: title,
                      style: TextStyle(
                          color: CRMColors.textNormal,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                    TextSpan(
                        style: TextStyle(
                            color: CRMColors.textNormal,
                            fontWeight: FontWeight.normal),
                        text: value)
                  ])),
            )
          ],
        ));
  }

  ///佣金标题
  Widget _buildTitle({@required String title, onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: CRMColors.textNormal, fontSize: CRMText.largeTextSize),
          ),
          SizedBox(
            width: CRMGaps.gap_dp4,
          ),
          InkWell(
            child: Icon(
              CRMIcons.question,
              size: ScreenFit.width(32),
              color: CRMColors.textNormal,
            ),
            onTap: onTap,
          )
        ],
      ),
    );
  }

  ///佣金金额
  Widget _buildDarkNumber({@required double number}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$number',
          style: TextStyle(color: CRMColors.textDark, fontSize: 32),
        ),
        Text(
          '元',
          style: CRMText.normalText,
        )
      ],
    );
  }

  ///空心按钮
  Widget _buildPlainButton(
      {@required String title, @required VoidCallback onPressed}) {
    return Center(
      child: Container(
        width: ScreenFit.width(248),
        height: 22,
        margin: EdgeInsets.only(top: CRMGaps.gap_dp10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CRMRadius.radius16),
            border: Border.all(color: CRMColors.primary)),
        child: FlatButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
                fontSize: CRMText.smallTextSize,
                fontWeight: FontWeight.normal,
                color: CRMColors.primary),
          ),
        ),
      ),
    );
  }

  ///佣金卡片
  Widget _buildWhiteCard() {
    return Positioned(
      top: 80,
      left: ScreenFit.width(15),
      child: Container(
        width: ScreenFit.width(720),
        height: 136,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(CRMRadius.radius8)),
          image: DecorationImage(
              image: AssetImage("assets/images/card_bg.png"), fit: BoxFit.fill),
        ),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: CRMGaps.gap_dp26),
                    child:
                        _buildTitle(title: '佣金预测', onTap: _showComssionDialog),
                  ),
                  _buildDarkNumber(number: _commissionTotal),
                  _buildPlainButton(
                      title: '查看佣金明细',
                      onPressed: () {
                        CRMNavigator.goCommissionDetailsPage(
                            _commissionDetails);
                      })
                ],
              ),
            ),
            Container(
              width: 1,
              height: 84,
              color: CRMColors.commonBg,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
                    child: _buildTitle(title: '盈利预测', onTap: _showIncomeDialog),
                  ),
                  Center(
                    child: Container(
                      width: ScreenFit.width(248),
                      child: _costDetail.isNotEmpty
                          ? _buildDarkNumber(number: _incomeTotal)
                          : Padding(
                              padding: EdgeInsets.only(top: CRMGaps.gap_dp4),
                              child: Text(
                                '完善成本信息可实时查看预测盈利',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: CRMText.normalTextSize,
                                    color: CRMColors.textLight),
                              ),
                            ),
                    ),
                  ),
                  _costDetail.isNotEmpty
                      ? _buildPlainButton(
                          title: '查看成本明细', onPressed: _goCostEntryPage)
                      : _buildPlainButton(
                          title: '马上录入成本',
                          onPressed: () async {
                            await _goCostEntryPage();
                          })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///个人信息卡片
  Widget _buildUserInfoCard(context, showCommissionCard) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: CRMNavigator.goPersonalInfoPage,
          child: Column(
            children: <Widget>[
              Container(
                height: showCommissionCard ? 136 : 96,
                color: CRMColors.gradientDarkBlue,
              ),
              Offstage(
                offstage: !showCommissionCard,
                child: Container(
                  color: Colors.white,
                  height: 78,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: CRMGaps.gap_dp12,
          left: ScreenFit.width(32),
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenFit.width(96.0),
                height: 60,
                child: CircleAvatar(
                  child: Image.asset('assets/images/user_head.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: CRMGaps.gap_dp10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_userName ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
        ),
        if (showCommissionCard) _buildWhiteCard()
      ],
    );
  }

  ///退出登录弹窗
  Future<void> _showDialog(context) async {
    var confirm = await MessageBox.confirm(context, '确定退出登录吗？');
    if (confirm) {
      Utils.trackEvent('log_out');
      ResultDataModel res = await httpPost(Apis.Logout);
      if (res.code == 0) {
        LocalStorage.remove(Permission.PERMISSION_KEY); //删除功能模块的权限
        LocalStorage.remove(Inputs.COOKIES_KEY); // 删除cookies
        LocalStorage.remove(Inputs.TOKEN_KEY); // 删除tooken
        LocalStorage.remove(Inputs.IMINFO); // 删除小巴 tooken
        Xiaobaim.logout();
        CRMNavigator.goUserLoginPage();
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
          child: AppbarWidget(
            brightness: Brightness.dark,
            backgroundColor: CRMColors.primary,
            color: Colors.white,
            automaticallyImplyLeading: false,
          ),
          preferredSize: Size.fromHeight(44),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.white,
          backgroundColor: CRMColors.primary,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    _buildUserInfoCard(context, _showCommissionCard),
                    if (_permission.contains(Permission.ACHIEVEMENT))
                      linkCellWidget(
                          leading: CRMIcons.performance,
                          title: '我的业绩',
                          tapCallback: () {
                            Utils.trackEvent('performance');
                            CRMNavigator.goPerformancePage();
                          }),
                    if (_permission.contains(Permission.ACHIEVEMENT))
                      linkCellWidget(
                          leading: CRMIcons.cost,
                          title: '成本',
                          tapCallback: _goCostEntryPage),
                    linkCellWidget(
                        leading: CRMIcons.privacy,
                        title: '隐私',
                        tapCallback: CRMNavigator.goPrivacyPolicyPage),
                    if (_permission.contains(Permission.APPEAL))
                      linkCellWidget(
                          leading: CRMIcons.feedbackout,
                          title: '合伙人事务诉求反馈',
                          tapCallback: () {
                            Utils.trackEvent('feedback'); //打点
                            XiaobaQueryModel xiaoba = XiaobaQueryModel(
                                groupId: 'DEFAULT_SERVICE',
                                reqPage: 'mine',
                                distributeTo: Platform.isAndroid?"${new DateTime.now().millisecondsSinceEpoch}":'group');
                            //打开小巴问题列表，加时间戳防止安卓返回原会话
                            CRMNavigator.goXiaobaPage(xiaoba);
                          }),
                    linkCellWidget(
                        leading: CRMIcons.about,
                        title: '关于CRM',
                        subTitle: '版本$_version',
                        tapCallback: () =>
                            CheckUpdateUtil.checkUpdates(context)),
                    linkCellWidget(
                        leading: CRMIcons.logout,
                        title: '退出登录',
                        tapCallback: () => _showDialog(context)),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
