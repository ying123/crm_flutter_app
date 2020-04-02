import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/env.dart';
import 'package:crm_flutter_app/config/login_constants.dart';
import 'package:crm_flutter_app/pages/documentary/documentary_page.dart';
import 'package:crm_flutter_app/pages/home/home_page.dart';
import 'package:crm_flutter_app/pages/mine/mine_page.dart';
import 'package:crm_flutter_app/providers/im_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/check_update_util.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/back_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xiaobaim/xiaobaim.dart';

class BottomNavigatorWidget extends StatefulWidget {
  final VoidCallback onLoginSucces;
  BottomNavigatorWidget({Key key, this.onLoginSucces}) : super(key: key);
  @override
  _BottomNavigatorWidgetState createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget>
    with WidgetsBindingObserver {
  int _curPageIndex = 0;
  List<Widget> _list = [HomePage(), DocumentaryPage(), MinePage()];
  final pageController = PageController(); // 保持页面状态
  final _bottomNavigationColor = CRMColors.textLight;
  final _bottomNavigationActiveColor = CRMColors.primary;
  List permission;
  List _tabs = [
    {
      "key": 'Home_page',
      "name": '首页',
      "icon": CRMIcons.home,
      "iconOn": CRMIcons.home_active,
    },
    {
      "key": 'documentary',
      "name": '跟单',
      "icon": CRMIcons.order,
      "iconOn": CRMIcons.order_active,
    },
    {
      "key": 'personal_center',
      "name": '我的',
      "icon": CRMIcons.mine,
      "iconOn": CRMIcons.mine_active,
    },
  ];

  List<BottomNavigationBarItem> get barItems {
    List<BottomNavigationBarItem> list = [];

    for (int i = 0; i < _tabs.length; i++) {
      list.add(BottomNavigationBarItem(
          icon: Icon(
            _tabs[i]['icon'],
            color: _bottomNavigationColor,
            size: ScreenFit.width(46),
          ),
          activeIcon: Icon(
            _tabs[i]['iconOn'],
            color: _bottomNavigationActiveColor,
          ),
          title: _buildBarItemTitle(_tabs[i]['name'], i)));
    }
    return list;
  }

// 改变tabs，设置当前页面
  void onPageChanged(int index) {
    setState(() {
      _curPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.onLoginSucces != null) {
      // 登录失效 重新进原来页面
      Future.delayed(Duration(seconds: 2), widget.onLoginSucces);
    }
    initXiaobaIm();
    CheckUpdateUtil.checkUpdates(context, silence: true); //检查版本更新
  }

  // 回调函数
  void listener(int count) {
    final imModel = Provider.of<ImModel>(context);
    imModel.unreadCount = count;
  }

  /// 初始化小巴SDK
  Future<void> initXiaobaIm() async {
    final res = await httpGet(Apis.imInfo);
    if (res.code == 0) {
      final data = res.data;
      final accId = data['accId'];
      final token = data['token'];
      // 用:: 分割
      LocalStorage.save(Inputs.IMINFO, '$accId::$token');
      await Xiaobaim.init(currentEnv.xiaobaHost, accId, token);
      final int count = await Xiaobaim.allUnreadCount(listener);
      // 先调一次
      listener(count);
    } else if (res.code == 3) {
      Utils.showToast('当前账户无小巴客服帐号');
      LocalStorage.save(Inputs.IMINFO, '');
    }
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this); // 在dispose后
    super.dispose();
  }

  // @override
  // didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     // went to Background
  //     stopLoop();
  //   }
  //   if (state == AppLifecycleState.resumed) {
  //     // came back to Foreground
  //     startLoop();
  //   }
  // }

  Widget _buildBarItemTitle(String text, int index) {
    return Text(
      text,
      style: TextStyle(
          color: _curPageIndex == index
              ? _bottomNavigationActiveColor
              : _bottomNavigationColor,
          fontSize: CRMText.smallTextSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return BackHomeWidget(
      child: Scaffold(
        body: PageView(
          children: _list,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: barItems,
          currentIndex: _curPageIndex,
          onTap: (int index) {
            Utils.trackEvent(_tabs[index]['key']);
            pageController.jumpToPage(index);
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
