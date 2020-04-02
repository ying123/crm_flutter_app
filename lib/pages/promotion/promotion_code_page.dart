import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:qr_flutter/qr_flutter.dart';

class PromotionCodePage extends StatefulWidget {
  PromotionCodePage();

  @override
  _PromotionCodePageState createState() => _PromotionCodePageState();
}

class _PromotionCodePageState extends State<PromotionCodePage> {
  String _text = "https://wx.qipeipu.com/#/register/basicInfo?code=";
  String _invitationCode = "";
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;
  //测试使用汽配铺logo
  String _thumnail =
      "https://pic.qipeipu.com/uploadpic/cms/images/2019-09/b0coenKA0.jpg";

  @override
  void initState() {
    super.initState();
    this._getInvitationCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///获取用户的邀请码
  _getInvitationCode() async {
    ResultDataModel res = await httpGet(Apis.TeamReferral, queryParameters: {});
    if (res.code == 0) {
      print(res.data);
      setState(() {
        _invitationCode = res.data;
      });
    } else {
      Utils.showToast(res.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          brightness: Brightness.dark,
          backgroundColor: CRMColors.primary,
          color: Colors.white,
          title: '邀请码',
        ),
        body: Builder(
          builder: (context) {
            return Container(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: CRMColors.primary,
                      height: 304,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: CRMGaps.gap_dp16,
                          vertical: CRMGaps.gap_dp10),
                      child: Column(
                        children: <Widget>[
                          _card(),
                          _bottomButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _bottomButton() {
    return Container(
        height: 46,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CRMRadius.radius4),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Utils.trackEvent('view_promotion_records');
              CRMNavigator.goPromotionRecordPage();
            },
            child: Text(
              '查看我的推广记录',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: CRMText.largeTextSize,
              ),
            ),
          ),
        ));
  }

  Widget _card() {
    return Container(
      margin: EdgeInsets.only(bottom: CRMGaps.gap_dp20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CRMRadius.radius10),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10.0)]),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(CRMRadius.radius10),
                  topRight: Radius.circular(CRMRadius.radius10)),
              color: CRMColors.blueLight,
            ),
            child: Center(
              child: Text('请使用微信或者浏览器扫描二维码',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CRMColors.textNormal,
                    fontSize: CRMText.hugeTextSize,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CRMRadius.radius10),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  QrImage(
                      data: _text + _invitationCode,
                      size: ScreenFit.width(298),
                      foregroundColor: CRMColors.primary),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '分享我的推广链接和推广码',
                    style: CRMText.normalText,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp30),
                    child: Text(
                      _text + _invitationCode,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CRMColors.primary),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 78,
                    child: GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //横轴三个子widget
                      ),
                      children: <Widget>[
                        _iconLink(
                            title: '分享链接',
                            icon: CRMIcons.share,
                            bgColor: CRMColors.success,
                            onTapCallback: () {
                              Utils.trackEvent('promo_code_share_url');
                              fluwx.register(appId: "wxe8b1adbc0f14d14f");
                              _showDialog(context);
                            }),
                        _iconLink(
                            title: '复制链接',
                            icon: CRMIcons.link,
                            bgColor: CRMColors.warning,
                            onTapCallback: () {
                              Utils.trackEvent('promo_code_copy_url');
                              Clipboard.setData(
                                  ClipboardData(text: _text + _invitationCode));
                              Utils.showToast('已复制到剪切板');
                            }),
                        _iconLink(
                            title: '复制推广码',
                            icon: CRMIcons.qrcode,
                            bgColor: CRMColors.purple,
                            onTapCallback: () {
                              Utils.trackEvent('copu_promo_code');
                              Clipboard.setData(
                                  ClipboardData(text: _invitationCode));
                              Utils.showToast('已复制到剪切板');
                            }),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: CRMGaps.gap_dp16,
                          horizontal: CRMGaps.gap_dp20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            CRMIcons.tips,
                            size: ScreenFit.width(24),
                            color: CRMColors.textLighter,
                          ),
                          SizedBox(
                            width: CRMGaps.gap_dp8,
                          ),
                          Expanded(
                            child: Text(
                              '推广链接可以直接复制至浏览器打开，推广码可用于汽配铺注册页填写~ ',
                              style: TextStyle(
                                  fontSize: CRMText.smallTextSize,
                                  color: CRMColors.textLighter),
                            ),
                          )
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Widget _iconLink(
      {@required String title,
      @required Function onTapCallback,
      @required Color bgColor,
      @required icon}) {
    return InkWell(
      onTap: onTapCallback,
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenFit.width(94),
            height: ScreenFit.width(94),
            margin: EdgeInsets.only(bottom: CRMGaps.gap_dp8),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(ScreenFit.width(94))),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            title,
            style: CRMText.smallText,
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext cxt) {
    showCupertinoModalPopup<int>(
        context: cxt,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  rootNavigatorState.pop(0);
                },
                child: Text("取消")),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    Utils.trackEvent('share_url_wechat');
                    rootNavigatorState.pop(2);
                    scene = fluwx.WeChatScene.SESSION;
                    _wechatShare();
                  },
                  child: Text('分享至微信好友')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Utils.trackEvent('share_url_wechat_circle');
                    rootNavigatorState.pop(3);
                    scene = fluwx.WeChatScene.TIMELINE;
                    _wechatShare();
                  },
                  child: Text('分享至朋友圈')),
            ],
          );
          return dialog;
        });
  }

  void _wechatShare() {
    var model = fluwx.WeChatShareWebPageModel(
        webPage: _text + _invitationCode,
        title: '诚意爆表！汽配铺邀请您注册！',
        description: '点我注册！汽配铺在线交易平台等待您的加入！',
        thumbnail: _thumnail,
        scene: scene,
        transaction: "hh");
    fluwx.share(model);
  }
}
