import 'package:bot_toast/bot_toast.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _CustomAlertDialog extends StatelessWidget {
  final String message;
  final Widget content;
  final String title;
  final String subTitle;
  final bool showCancelButton;
  final bool showTitle;
  final String cancelButtonText;
  final String confirmButtonText;
  final WidgetBuilder builder;

  _CustomAlertDialog({
    this.message,
    this.content,
    this.title,
    this.subTitle,
    this.showCancelButton,
    this.showTitle,
    this.cancelButtonText,
    this.confirmButtonText,
    this.builder,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: builder != null
              ? builder(context)
              : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ScreenFit.width(560),
                    minWidth: ScreenFit.width(560),
                    maxHeight: 600,
                    minHeight: 150,
                  ),
                  child: Material(
                    color: Theme.of(context).dialogBackgroundColor,
                    type: MaterialType.card,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (showTitle)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 19, 20, 4),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    title ?? '温馨提示',
                                    textAlign: TextAlign.center,
                                    style: CRMText.boldTitleText,
                                  ),
                                  if (subTitle != null)
                                    Text(
                                      subTitle,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: CRMText.largeTextSize,
                                          color: CRMColors.textDark),
                                    ),
                                ],
                              )),
                        if (message != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: CRMText.normalText,
                            ),
                          ),
                        if (content != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                            child: content,
                          ),
                        SizedBox(
                          height: 45,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              buttonTheme: ButtonThemeData(
                                height: 45,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                if (showCancelButton)
                                  Expanded(
                                    child: FlatButton(
                                      shape: Border(
                                          top: BorderSide(
                                              color: CRMColors.borderLight)),
                                      child: Text(cancelButtonText ?? '取消',
                                          style: CRMText.bottomButtonText(
                                              color: CRMColors.textLight)),
                                      color: Colors.white,
                                      onPressed: _onCloseFactory(false),
                                    ),
                                  ),
                                Expanded(
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                CRMRadius.radius8))),
                                    child: Text(confirmButtonText ?? '确认',
                                        style: CRMText.bottomButtonText()),
                                    color: CRMColors.primary,
                                    onPressed: _onCloseFactory(true),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    borderRadius: BorderRadius.circular(CRMRadius.radius8),
                    clipBehavior: Clip.antiAlias,
                  ),
                ),
        ),
      ),
    );
  }
}

class _CustomCurtain extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  _CustomCurtain({@required this.child, this.width, this.height}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: height,
          child: Material(
            color: Theme.of(context).dialogBackgroundColor,
            type: MaterialType.card,
            borderRadius: BorderRadius.circular(CRMRadius.radius10),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
        Container(
          color: Colors.transparent,
          height: 60,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              child: Icon(
                CRMIcons.close,
                size: ScreenFit.width(60),
                color: Colors.white,
              ),
              onTap: _onCloseFactory(false),
            ),
          ),
        )
      ],
    );
  }
}

Future<T> _showDialog<T>(BuildContext context,
    {String message,
    String title,
    bool showCancelButton,
    bool showTitle,
    String cancelButtonText,
    String confirmButtonText,
    WidgetBuilder builder}) {
  return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _CustomAlertDialog(
          message: message,
          title: title,
          showCancelButton: showCancelButton,
          showTitle: showTitle,
          cancelButtonText: cancelButtonText,
          confirmButtonText: confirmButtonText,
          builder: builder,
        );
      });
}

VoidCallback _onCloseFactory(bool result) {
  return () {
    // 关闭对话框并返回值
    rootNavigatorState.pop(result);
  };
}

class MessageBox {
  MessageBox._();

  /// 自定义弹窗
  static Future<T> builder<T>(BuildContext context, WidgetBuilder builder) {
    return _showDialog<T>(context, builder: builder);
  }

  /// 确定返回`true`,取消返回`false`
  static Future<bool> alert(BuildContext context, String message,
      {String title = '温馨提示',
      bool showTitle = true,
      String confirmButtonText = '确定'}) {
    return _showDialog<bool>(context,
        message: message,
        showCancelButton: false,
        title: title,
        showTitle: showTitle,
        cancelButtonText: '取消',
        confirmButtonText: confirmButtonText);
  }

  /// 确定返回`true`,取消返回`false`
  static Future<bool> confirm(BuildContext context, String message,
      {String title = '温馨提示',
      bool showTitle = true,
      String cancelButtonText = '取消',
      String confirmButtonText = '确定'}) {
    assert(context != null);
    return _showDialog<bool>(context,
        message: message,
        showCancelButton: true,
        title: title,
        showTitle: showTitle,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText);
  }

  /// 日期选择弹窗
  static Future<DateTime> datePicker(BuildContext context,
      {DateTime firstDate,
      DateTime lastDate,
      DateTime initialDate,
      TransitionBuilder builder}) {
    var now = DateTime.now();
    return showDatePicker(
      locale: Locale('zh'),
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 100),
      lastDate: lastDate ?? DateTime(now.year + 1),
      builder: builder ??
          (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: CRMColors.primary,
                  accentColor: CRMColors.primary),
              child: child,
            );
          },
    );
  }

  /// 公告弹窗
  static Future<bool> notice(
      BuildContext context, String imageUrl, int read, String noticeId) {
    return builder<bool>(context, (context) {
      return _CustomCurtain(
          width: ScreenFit.width(600),
          child: GestureDetector(
            onTap: () {
              rootNavigatorState.pop(true);
              Utils.trackEvent('window_notice');
              CRMNavigator.goAnnouncementDetailsPage(read, noticeId);
            },
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.fill,
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/notice_dialog.png'),
            ),
          ));
    });
  }

  /// 物流状态弹窗
  static Future<void> statusStep(
      BuildContext context, String title, int currentStep, List steps) {
    List reverseSteps = new List();
    steps.forEach((item) => reverseSteps.insert(0, item));

    return builder<void>(context, (context) {
      return _CustomCurtain(
          width: ScreenFit.width(600),
          height: ScreenFit.height(600),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: CRMColors.commonBg,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: CRMText.mainTitleText,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenFit.width(50),
                        vertical: ScreenFit.width(30)),
                    child: ListView.builder(
                        itemCount: reverseSteps.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenFit.width(28),
                                    0,
                                    0,
                                    ScreenFit.width(20)),
                                margin:
                                    EdgeInsets.only(left: ScreenFit.width(16)),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                  width: 1,
                                  color: index == reverseSteps.length - 1
                                      ? Colors.transparent
                                      : CRMColors.borderLight,
                                ))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(reverseSteps[index]['handle_time'],
                                        style: currentStep == index
                                            ? CRMText.mainTitleText
                                            : CRMText.normalLighterText),
                                    Text(reverseSteps[index]['desc'],
                                        style: currentStep == index
                                            ? CRMText.normalText
                                            : CRMText.normalLighterText),
                                  ],
                                ),
                              ),
                              Positioned(
                                  left: ScreenFit.width(8),
                                  top: 0,
                                  child: Container(
                                    width: ScreenFit.width(16),
                                    height: ScreenFit.width(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: ScreenFit.width(4),
                                        color: index == currentStep
                                            ? CRMColors.primary
                                            : CRMColors.borderDark,
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ));
    });
  }

  /// loading
  static CancelFunc loading({
    /// 等待多少毫秒关闭loading，不设置不自动关闭
    Duration duration = const Duration(seconds: 10),
  }) {
    return BotToast.showCustomLoading(
        toastBuilder: (CancelFunc cancelFunc) {
          return Center(
            child: SizedBox(
              width: ScreenFit.width(160),
              child: Image.asset(
                'assets/images/loading.gif',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        duration: duration,
        crossPage: false);
  }

  // 物流底部弹窗
  static Future<void> showLogisticsSheet(
      BuildContext context, orderDetailTrackVOS) {
    if (orderDetailTrackVOS.length == 0) {
      orderDetailTrackVOS = {
        'order_detail_id': null,
        'total_num': 0,
        'part_name': '',
        'order_detail_track_log_vos': [],
        'order_detail_track_package_vos': [],
      };
    }
    String partName = orderDetailTrackVOS['part_name'];
    List packages = orderDetailTrackVOS['order_detail_track_package_vos'];
    List steps = orderDetailTrackVOS['order_detail_track_log_vos'];

    List<Widget> packagesWidgets = new List<Widget>();
    if (packages.length > 0) {
      packages.forEach((item) {
        packagesWidgets.add(Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
              '包裹 ${item['package_no'] ?? ''} 【$partName X ${item['num']}】'),
        ));
      });
    }

    Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('拨打电话失败');
      }
    }

    _loadLogInfo(steps, index) {
      List<Widget> widgetList = new List<Widget>();
      steps[index]['order_detail_track_log_infos'].forEach((val) {
        widgetList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(val['operate_time'] ?? '',
                style: val['operation'] == null
                    ? CRMText.normalOrangeText
                    : index == 0
                        ? CRMText.normalText
                        : CRMText.normalLighterText),
            steps[index]['stage'] != 'ACCEPTANCE_CHECK' &&
                    steps[index]['stage'] != 'ACCEPTANCE_CHECK_REJECT' &&
                    steps[index]['stage'] != 'DISTRIBUTION'
                ? Text(val['log'] ?? '',
                    strutStyle: StrutStyle(height: 1.5),
                    style: 0 == index
                        ? CRMText.normalText
                        : CRMText.normalLighterText)
                : InkWell(
                    child: RichText(
                      text: TextSpan(
                          text:
                              '${val['log'] ?? ''}  合伙人：${val['operator'] ?? ''}',
                          style: val['operation'] == null
                              ? CRMText.normalOrangeText
                              : index == 0
                                  ? CRMText.normalText
                                  : CRMText.normalLighterText,
                          children: <TextSpan>[
                            TextSpan(
                                text: '(${val['phone_no'] ?? ''})',
                                style: TextStyle(color: CRMColors.blueDark))
                          ]),
                    ),
                    onTap: () async {
                      var confirm = await MessageBox.confirm(
                          context, val['phone_no'],
                          title: '确认拨打电话');
                      if (confirm) {
                        _makePhoneCall('tel:${val['phone_no']}');
                      }
                    }),
          ],
        ));
      });
      return widgetList;
    }

    return showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Container(
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Center(child: Text(partName)),
                      Positioned(
                        right: 20,
                        child: IconButton(
                          onPressed: () {
                            _onCloseFactory(false)();
                          },
                          icon: Icon(
                            CRMIcons.delete,
                            size: 20,
                            color: CRMColors.borderDark,
                          ),
                        ),
                      )
                    ],
                  )),
              packages.length > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration:
                          BoxDecoration(color: CRMColors.gradientLightYellow),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 80,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.topRight,
                            child: Text('已打包为：'),
                          ),
                          Expanded(
                            child: packagesWidgets.length < 4
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: packagesWidgets,
                                  )
                                : Container(
                                    height: 110,
                                    // child: ListView(children: packagesWidgets),
                                    child: Scrollbar(
                                      child:
                                          ListView(children: packagesWidgets),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              steps.length > 0
                  ? Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Scrollbar(
                            child: ListView.builder(
                              itemCount: steps.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    steps[index]['stage'] !=
                                                'CUSTOMER_CANCEL' &&
                                            steps[index]['stage'] != 'PAY'
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              steps[index]['stage_desc'] ?? '',
                                              style: index == 0
                                                  ? CRMText.mainTitleText
                                                  : CRMText.normalLighterText,
                                            ),
                                          )
                                        : SizedBox(width: 48),
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenFit.width(30),
                                                0,
                                                0,
                                                ScreenFit.width(20)),
                                            margin: EdgeInsets.only(
                                                left: ScreenFit.width(16)),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                              width: 1,
                                              color: index == steps.length - 1
                                                  ? Colors.transparent
                                                  : CRMColors.borderLight,
                                            ))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  _loadLogInfo(steps, index),
                                            ),
                                          ),
                                          Positioned(
                                              left: steps[index]['stage'] !=
                                                          'CUSTOMER_CANCEL' &&
                                                      steps[index]['stage'] !=
                                                          'PAY'
                                                  ? ScreenFit.width(0)
                                                  : ScreenFit.width(8),
                                              top: 0,
                                              child: Container(
                                                width: steps[index]['stage'] !=
                                                            'CUSTOMER_CANCEL' &&
                                                        steps[index]['stage'] !=
                                                            'PAY'
                                                    ? ScreenFit.width(38)
                                                    : ScreenFit.width(16),
                                                height: steps[index]['stage'] !=
                                                            'CUSTOMER_CANCEL' &&
                                                        steps[index]['stage'] !=
                                                            'PAY'
                                                    ? ScreenFit.width(38)
                                                    : ScreenFit.width(16),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: index == 0
                                                      ? CRMColors.warning
                                                      : CRMColors.borderDark,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: ScreenFit.width(4),
                                                    color: index == 0
                                                        ? CRMColors.warning
                                                        : CRMColors.borderDark,
                                                  ),
                                                ),
                                                child: steps[index]['stage'] !=
                                                            'CUSTOMER_CANCEL' &&
                                                        steps[index]['stage'] !=
                                                            'PAY'
                                                    ? Icon(
                                                        steps[index]['stage'] ==
                                                                'DISTRIBUTION'
                                                            ? CRMIcons.transport
                                                            : steps[index]['stage'] ==
                                                                        'ACCEPTANCE_CHECK' ||
                                                                    steps[index]
                                                                            [
                                                                            'stage'] ==
                                                                        'ACCEPTANCE_CHECK_REJECT'
                                                                ? CRMIcons.check
                                                                : steps[index][
                                                                            'stage'] ==
                                                                        'OUTBOUND'
                                                                    ? CRMIcons
                                                                        .export
                                                                    : steps[index]['stage'] ==
                                                                            'INBOUND'
                                                                        ? CRMIcons
                                                                            .import
                                                                        : CRMIcons
                                                                            .tuidan,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )
                                                    : Container(),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: Text('暂无物流信息')),
                    )
            ],
          );
        });
  }

  // 底部actionSheet
  static Future<void> showBottomActionSheet(
      BuildContext context, Widget childWidget,
      {String title = '说明'}) {
    return showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Container(
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Center(child: Text(title, style: CRMText.boldTitleText)),
                      Positioned(
                        right: 20,
                        child: IconButton(
                          onPressed: () {
                            _onCloseFactory(false)();
                          },
                          icon: Icon(
                            CRMIcons.delete,
                            size: 20,
                            color: CRMColors.borderDark,
                          ),
                        ),
                      )
                    ],
                  )),
              Expanded(
                child: ListView(
                  children: <Widget>[childWidget],
                ),
              )
            ],
          );
        });
  }

  ///bottomsheet
  static Future<void> showActionsheet(BuildContext context,
      {@required List list,
      String label,
      onChange,
      onCancel,
      int initialItem,
      String title}) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(context,
            list: list,
            onCancel: onCancel,
            onChange: onChange,
            title: title,
            label: label,
            initialItem: initialItem);
      },
    );
  }

  static Widget _buildBottomPicker(BuildContext context,
      {List list,
      onChange,
      onCancel,
      String label,
      int initialItem,
      String title}) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(
            initialItem: initialItem == null ? -1 : initialItem); // 默认选中项
    int selectIndex;
    return Container(
      height: 262,
      width: double.infinity,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CRMColors.textNormal,
          fontSize: CRMText.hugeTextSize,
        ),
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: CRMColors.borderLight,
                            width: ScreenFit.onepx()))),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          '取消',
                          style: TextStyle(
                              color: CRMColors.textLight,
                              fontSize: CRMText.largeTextSize),
                        ),
                        onTap: _onCloseFactory(false),
                      ),
                      Expanded(
                        child: Text(
                          title ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          '确定',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: CRMColors.primary,
                              fontSize: CRMText.largeTextSize),
                        ),
                        onTap: () {
                          onChange(selectIndex ?? 0);
                          _onCloseFactory(false)();
                        },
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: CupertinoPicker(
                magnification: 1,
                // 整体放大率
                // offAxisFraction: 10, // 球面效果的透视系数,消失点位置
                scrollController: scrollController,
                // 用于读取和控制当前项的FixedxtentScrollController
                itemExtent: 48,
                // 所以子节点 统一高度
                backgroundColor: CupertinoColors.white,
                // 所有子节点下面的背景颜色
                useMagnifier: true,
                // 是否使用放大效果
                onSelectedItemChanged: (int index) {
                  // 当正中间选项改变时的回调
                  selectIndex = index;
                },
                children: List<Widget>.generate(list.length, (int index) {
                  return Center(
                    child: Text(
                      label != null ? list[index][label] : list[index],
                      style: TextStyle(
                          color: CRMColors.textDark,
                          fontSize: CRMText.hugeTextSize),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<bool> showCupertinoDialog(
    BuildContext context, {
    WidgetBuilder builder,
    String title,
  }) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return _CustomAlertDialog(builder: (context) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ScreenFit.width(720),
                minWidth: ScreenFit.width(686),
                maxHeight: 400,
                minHeight: 150,
              ),
              child: Material(
                color: Theme.of(context).dialogBackgroundColor,
                type: MaterialType.card,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: CRMText.boldTitleText,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: builder(context)),
                    ),
                    SizedBox(
                      height: 44,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          buttonTheme: ButtonThemeData(
                            height: 44,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                shape: Border(
                                    top: BorderSide(
                                        color: CRMColors.borderLight)),
                                child: Text('取消',
                                    style: CRMText.bottomButtonText(
                                        color: CRMColors.textLight)),
                                color: Colors.white,
                                onPressed: _onCloseFactory(false),
                              ),
                            ),
                            Expanded(
                              child: FlatButton(
                                child: Text('确认',
                                    style: CRMText.bottomButtonText()),
                                color: CRMColors.primary,
                                onPressed: _onCloseFactory(true),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                borderRadius: BorderRadius.circular(CRMRadius.radius8),
                clipBehavior: Clip.antiAlias,
              ),
            );
          });
        });
  }

  static Future<T> showContentDialog<T>(BuildContext context,
      {Widget content,
      String title,
      String subTitle,
      bool showCancelButton = false,
      bool showTitle = true,
      String cancelButtonText,
      String confirmButtonText,
      WidgetBuilder builder}) {
    return showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _CustomAlertDialog(
            content: content,
            title: title,
            subTitle: subTitle,
            showCancelButton: showCancelButton,
            showTitle: showTitle,
            cancelButtonText: cancelButtonText,
            confirmButtonText: confirmButtonText,
            builder: builder,
          );
        });
  }
}
