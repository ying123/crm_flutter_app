import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/config/permission.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/custom_exception_util.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/back_home_widget.dart';
import 'package:crm_flutter_app/widgets/env_switcher.dart';
import 'package:crm_flutter_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class UserLoginPage extends StatefulWidget {
  final VoidCallback onLoginSucces;
  UserLoginPage({this.onLoginSucces});
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  /// 是否测试账号
  bool isTestUser;

  /// 用于验证码倒计时
  Timer countDownTimer;
  String verifyText = '获取验证码';
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPwd = TextEditingController();
  final TextEditingController _controllerVerfiyCode = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  void _continue() async {
    String username = _controllerPhone.text;
    try {
      _formValidator([Inputs.PHONE]);
      ResultDataModel res = await httpGet(Apis.JudgeUser,
          queryParameters: {
            "username": username,
          },
          showLoading: true);
      if (res.code == 0) {
        setState(() {
          isTestUser = res.data;
          // FocusScope.of(context).requestFocus(_focusNode);
        });
      } else {
        Utils.showToast(res.msg);
      }
    } on ValidatorException catch (e) {
      Utils.showToast(e.toString());
    }
  }

  void setName() async {
    var phone = await LocalStorage.get(Inputs.PHONE);
    _controllerPhone.value = new TextEditingValue(text: phone ?? '');
  }

  @override
  void initState() {
    super.initState();
    setName();
  }

  @override
  void dispose() {
    _clearTimer();
    _controllerPhone.dispose();
    _controllerPwd.dispose();
    _controllerVerfiyCode.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  void _clearTimer() {
    countDownTimer?.cancel(); //如果已存在先取消置空
    countDownTimer = null;
  }

  void _resetVerifyText() {
    verifyText = '获取验证码';
    _clearTimer();
  }

  ///手机验证码登录
  void _loginLimit() async {
    String username = _controllerPhone.text;
    String pwd = _controllerPwd.text;
    String verifyCode = _controllerVerfiyCode.text;
    var verString = isTestUser ? Inputs.PASSWORD : Inputs.VCODE;
    try {
      _formValidator([Inputs.PHONE, verString]);
      // mta 统计
      Utils.trackEvent('register');
      ResultDataModel res =
          await httpPost(Apis.LoginMessage, showLoading: true, data: {
        "username": username,
        "verifyCode": isTestUser ? pwd : verifyCode,
      });
      if (res.code == 0) {
        _loginSuccess(res);
      } else {
        Utils.showToast(res.msg);
      }
    } on ValidatorException catch (e) {
      Utils.showToast(e.toString());
    }
  }

  ///登录成功后的操作
  void _loginSuccess(res) async {
    LocalStorage.save(Inputs.TOKEN_KEY, res.data['token']);
    LocalStorage.save(
        Inputs.COOKIES_KEY, 'crm-token=${res.data['old-crm-token']}');
    LocalStorage.save(Inputs.PHONE, _controllerPhone.text);
    await _getPermission(); //获取权限列表并存储
    CRMNavigator.goHomePage(replace: true, onLoginSucces: widget.onLoginSucces);
  }

  ///获取用户功能权限
  Future<void> _getPermission() async {
    ResultDataModel res = await httpGet(Apis.permission, showLoading: true);
    if (res.code == 0) {
      await LocalStorage.save(
          Permission.PERMISSION_KEY, res.data.join(',')); //存储用户权限
    }
  }

  ///表单校验
  _formValidator(List<String> inputs) {
    if (inputs.contains(Inputs.PASSWORD)) {
      if (_controllerPwd.text.isEmpty) {
        throw ValidatorException('请输入密码~');
      }
    }
    if (inputs.contains(Inputs.PHONE)) {
      if (_controllerPhone.text.isEmpty) {
        throw ValidatorException('请输入登录账户~');
      }
    }
    if (inputs.contains(Inputs.VCODE)) {
      if (_controllerVerfiyCode.text.isEmpty) {
        throw ValidatorException('请输入验证码~');
      }
    }
  }

  ///获取验证码
  _getVerifyCode() async {
    try {
      _formValidator([Inputs.PHONE]);
      setState(() {
        verifyText = '获取中...';
      });

      ResultDataModel res = await httpGet(Apis.MessageLogin,
          queryParameters: {"username": _controllerPhone.text});
      if (res.code == 0) {
        Utils.showToast(res.data);
        _clearTimer();
        countDownTimer = new Timer.periodic(Duration(seconds: 1), (t) {
          setState(() {
            if (60 - t.tick > 0) {
              // 60-t.tick代表剩余秒数
              verifyText = "剩余${60 - t.tick}秒";
            } else {
              _resetVerifyText();
            }
          });
        });
      } else {
        Utils.showToast(res.msg);
        setState(_resetVerifyText);
      }
    } on ValidatorException catch (e) {
      Utils.showToast(e.toString());
    }
  }

  Widget phoneLogin() {
    return Column(
      children: <Widget>[
        TextFieldWidget(
            autofocus: true,
            controller: _controllerPhone,
            hintText: '请输入登录账号',
            onChanged: (newVal) async {
              var phone = await LocalStorage.get(Inputs.PHONE);
              if (newVal != phone) {
                LocalStorage.save(Inputs.PHONE, newVal);
              }
              // 用户清除账户顺便清掉验证码和密码
              if (newVal.isEmpty && isTestUser != null) {
                setState(() {
                  isTestUser = null;
                  _controllerPwd.clear();
                  _controllerVerfiyCode.clear();
                  _resetVerifyText();
                });
              }
            }),
        Offstage(
          offstage: isTestUser == null || isTestUser == false,
          child: TextFieldWidget(
            // focusNode: _focusNode,
            controller: _controllerPwd,
            hintText: '请输入登录密码',
            obscureText: true,
          ),
        ),
        Offstage(
          offstage: isTestUser == null || isTestUser == true,
          child: TextFieldWidget(
            // focusNode: _focusNode,
            controller: _controllerVerfiyCode,
            hintText: '请输入验证码',
            buttonText: this.verifyText,
            isVerify: true,
            onGetVerifyCodeCallback:
                verifyText == '获取验证码' ? _getVerifyCode : null,
          ),
        ),
      ],
    );
  }

  ///蓝色按钮
  Widget blueButton(context, title, onPressedCallback) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenFit.height(80)),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: ScreenFit.height(21)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenFit.width(8))),
        onPressed: () {
          onPressedCallback();
        },
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            title,
            style:
                TextStyle(color: Colors.white, fontSize: CRMText.hugeTextSize),
          ),
        ),
      ),
    );
  }

  ///登录欢迎字体
  Widget loginWelcomeWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: ScreenFit.height(88)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          welcomeTitleText('你好'),
          welcomeTitleText('欢迎来到CRM'),
        ],
      ),
    );
  }

  Widget welcomeTitleText(title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: CRMColors.textDark,
        fontSize: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackHomeWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(ScreenFit.width(56),
                ScreenFit.width(144), ScreenFit.width(56), 0),
            child: Column(
              children: <Widget>[
                loginWelcomeWidget(),
                Column(
                  children: <Widget>[
                    phoneLogin(),
                    blueButton(context, isTestUser == null ? '继续' : '登录',
                        isTestUser == null ? _continue : _loginLimit)
                  ],
                ),
              ],
            ),
          ),
        )),
        floatingActionButton: EnvSwitcher(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
