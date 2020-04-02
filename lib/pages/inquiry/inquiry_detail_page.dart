import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/routes/route_animation.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/button_big_radius_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/gray_panel_widget.dart';
import 'package:crm_flutter_app/widgets/hero_photo_view_wrapper_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/photo_view_gallery_screen.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/customer_info_widget.dart';
import 'package:crm_flutter_app/widgets/title_value_widget.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InquryDetailPage extends StatefulWidget {
  final String inquiryId;
  const InquryDetailPage(this.inquiryId, {Key key}) : super(key: key);

  @override
  _InquryDetailPageState createState() => _InquryDetailPageState();
}

class _InquryDetailPageState extends State<InquryDetailPage>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<InquryDetailPage> {
  static const h96 = 40.0; //车型行+横向tab的高度
  static const clampingScrollPhysics = const ClampingScrollPhysics();
  static const neverScrollableScrollPhysics =
      const NeverScrollableScrollPhysics();
  // 价格栏是否已固定
  bool hasFixed = false;
  Map<String, dynamic> _model = {};
  Map<String, dynamic> _insuranceInfo = {};

  List _leftList = [];
  List _rightList = [];
  Map<String, dynamic> _inquiryInfo = {};

  bool _loading = false;
  bool _hasmore = true;
  int _page = 1;
  int _pageSize = 20;
  int selectParts = 0;

  int _invoiceValue = -1; // -1 不要发票 0 普通发票
  // 1 可催报价 2 不可催报价 3 已催 4/null 不显示
  int _urgeStatus = 4;
  int _remindSeconds = 0;
  // 倒计时controller
  AnimationController _animationController;

  bool _showInsuranceInfo = false;
  Map<dynamic, dynamic> _factoryTypesMap = {
    0: '原厂',
    1: '品牌',
    2: '品牌',
    5: '旧件',
    6: '特价',
    9: '其他',
    'SCRAP_PIECES': '旧件',
    '1,2': '品牌',
    'ORIGINAL': '原厂',
    'DOMESTIC_BRANDS': '品牌',
    'FOREIGN_BRANDS': '品牌',
    'DEPRECIATED_PIECES': '特价'
  };

  bool _loadPicError = false;

  String get hoursString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inHours).toString().padLeft(2, '0')}';
  }

  String get minutesString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  String get secondsString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  ScrollPhysics get physics {
    return hasFixed ? clampingScrollPhysics : neverScrollableScrollPhysics;
  }

  @override
  void initState() {
    super.initState();
    _getInquiryBaseInfo();
    _getInquiryQuoteDetail(page: 1);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    if (state == AppLifecycleState.resumed) {
      _getInquiryBaseInfo();
    }
    super.didChangeAppLifecycleState(state);
  }

  ///判断是否处于18:00到次日9:00
  bool _checkAuditTime() {
    int nowHours = DateTime.now().hour;
    if (nowHours >= 18 || nowHours < 9) {
      return true;
    }
    return false;
  }

  ///催报价
  Future _urge() async {
    if (_urgeStatus == 1) {
      // FormData formData = FormData.from({"inquiryId": widget.inquiryId});
      ResultDataModel res =
          await httpPost(Apis.Urge, data: {'inquiryId': widget.inquiryId});
      if (res.code == 0) {
        Utils.showToast('已通知商家快马加鞭报价，请耐心等候~');
        _getInquiryBaseInfo();
      } else {
        Utils.showToast(res.msg);
      }
    } else if (_remindSeconds != 0 || _urgeStatus == 2) {
      MessageBox.alert(context, '报价倒计时结束后，若有报价数≠需求数可点击“催报价”催平台给出报价~');
    }
  }

  ///开始倒计时
  void _startCountdown(seconds) {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
            hours: (seconds / (60 * 60)).floor(),
            minutes: (seconds / 60 % 60).floor(),
            seconds: seconds % 60));
    _animationController.reverse(
        from: _animationController.value == 0.0
            ? 1.0
            : _animationController.value);
    _animationController.addListener(() {
      // 当处于18:00-次日19:00，暂停倒计时
      if (_checkAuditTime()) {
        _animationController?.stop();
      }
      //倒计时结束
      if (_animationController.value.toString() == '0.0') {
        _getInquiryBaseInfo();
      }
    });
  }

  ///获取询价单的基本信息
  _getInquiryBaseInfo() async {
    ResultDataModel res = await httpGet(Apis.TrackOrderInquiryBaseInfo,
        queryParameters: {'inquiryId': widget.inquiryId}, showLoading: true);
    if (res.code == 0 && res.data != null) {
      if (mounted) {
        setState(() {
          _model = res.data['inquiryVO'];
          _insuranceInfo = {
            'clientOrgId': res.data['clientOrgId'] ?? '',
            'clientOrgName': res.data['clientOrgName'] ?? '',
            'clientContactPerson': res.data['clientContactPerson'] ?? '',
            'clientContactMobile': res.data['clientContactMobile'] ?? '',
            'address': res.data['address'] ?? ''
          };
          _urgeStatus = res.data['urgeStatus'];
          int seconds = int.parse(res.data['remindSecond']);
          _remindSeconds = seconds;
          // 倒计时
          if (seconds != null) {
            _startCountdown(seconds);
          }
        });
      }
    } else {
      Utils.showToast(res.msg);
    }
    // 获取元素的位置与尺寸
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  ///获取询价单详请-配件报价信息
  Future<void> _getInquiryQuoteDetail({int page}) async {
    setState(() {
      if (page != null) {
        // 传入page，用于下拉刷新时获取第1页数据
        _page = page;
        _leftList = [];
        _rightList = [];
        _inquiryInfo = {
          'partsName': '',
          'modifiedPartsName': '',
          'partCode': '',
          'priceOf4s': '',
          'attrValue': '',
          'beatBackInfoDTO': {},
          'inquiryDetailUserPicDTOs': [],
          'inquiryDetailPhysicalPicDTOs': [],
          'inquiryDetailQuoteStatus': null,
          'remark': '',
          'remarkByCS': '',
          'epcPicUrls': [],
        };
      }
    });

    if (this._hasmore) {
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      ResultDataModel res = await httpGet(Apis.TrackOrderInquiryQuoteDetail,
          queryParameters: {
            'inquiryId': widget.inquiryId,
            'invoiceType': _invoiceValue,
            "page": _page,
            "limit": _pageSize
          },
          showLoading: true);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (res.code == 0) {
        if (mounted) {
          if (res.data != null && res.data.length > 0) {
            setState(() {
              if (page != null) {
                _leftList = res.data;
                this._choosePart(_leftList[0]);
                this.selectParts = 0;
              } else {
                this._leftList.addAll(res.data);
              }
              _page++;
            });
          } else {
            if (_page == 1) {
              setState(() {
                _leftList = [];
                _rightList = [];
                _inquiryInfo = {
                  'partsName': '',
                  'modifiedPartsName': '',
                  'attrValue': '',
                  'beatBackInfoDTO': {},
                  'inquiryDetailUserPicDTOs': [],
                  'inquiryDetailPhysicalPicDTOs': [],
                  'inquiryDetailQuoteStatus': null,
                  'remark': '',
                  'remarkByCS': '',
                  'partCode': '',
                  'priceOf4s': '',
                  'epcPicUrls': [],
                };
              });
            } else {
              this._hasmore = false;
            }
          }
        }
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    setState(() {
      this._hasmore = true;
    });
    await _getInquiryQuoteDetail(page: 1);
  }

  void _choosePart(part) {
    if (mounted) {
      setState(() {
        if (_leftList.isNotEmpty) {
          _leftList.forEach((item) {
            if (item['inquiryDetailId'] == part['inquiryDetailId']) {
              _inquiryInfo = {
                'partsName': item['partsName'] ?? '',
                'modifiedPartsName': item['modifiedPartsName'] ?? '',
                'remark': item['remark'] ?? '',
                'remarkByCS': item['remarkByCS'] ?? '',
                'partCode': item['partCode'] ?? '',
                'priceOf4s': item['priceOf4s'] ?? '',
                'epcPicUrls': item['epcPicUrls'] ?? [],
                'beatBackInfoDTO': item['beatBackInfoDTO'] ?? {},
                'attrValue': item['attrValue'] ?? '',
                'inquiryDetailQuoteStatus': item['inquiryDetailQuoteStatus'],
                'inquiryDetailUserPicDTOs':
                    item['inquiryDetailUserPicDTOs'] ?? [],
                'inquiryDetailPhysicalPicDTOs':
                    item['inquiryDetailPhysicalPicDTOs'] ?? [],
              };
              _rightList = item['quoteDetailVOS'];
            }
          });
        } else {
          Utils.showToast('暂无数据！');
        }
      });
    }
  }

  // 信息显示
  Widget _buildInfoItem(String title,
      {String value,
      Color color = CRMColors.textNormal,
      Widget rightWidget,
      CrossAxisAlignment align = CrossAxisAlignment.center}) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: align,
          children: <Widget>[
            Text(title, style: CRMText.normalText),
            Expanded(
              child: rightWidget ?? rightWidget,
            ),
          ],
        ),
      ],
    );
  }

  // 倒计时
  Widget _buildCountDown() {
    return Container(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, Widget child) {
          return Row(
            children: <Widget>[
              Text(hoursString,
                  style: TextStyle(color: CRMColors.warning)), //小时
              Text(':', style: TextStyle(color: CRMColors.warning)),
              Text(minutesString,
                  style: TextStyle(color: CRMColors.warning)), //分钟
              Text(':', style: TextStyle(color: CRMColors.warning)),
              Text(secondsString,
                  style: TextStyle(color: CRMColors.warning)), //
            ],
          );
        },
      ),
    );
  }

  // 询价单详情
  Widget _buildInquiryItem() {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    titleValueWidget(
                        title: '询价时间：', value: _model['lastPublishTime'] ?? ''),
                    _buildInfoItem('发票类型：',
                        align: CrossAxisAlignment.start,
                        rightWidget: Container(
                          height: 20,
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        _invoiceValue == 0
                                            ? CRMIcons.checked
                                            : CRMIcons.unchecked,
                                        size: 18,
                                        color: _invoiceValue == 0
                                            ? CRMColors.primary
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text('带票'),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                  onTap: () => {
                                        setState(() {
                                          _invoiceValue = 0;
                                          this._hasmore = true;
                                          this._getInquiryQuoteDetail(page: 1);
                                        })
                                      }),
                              SizedBox(width: 12),
                              GestureDetector(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      SizedBox(height: 8),
                                      Icon(
                                        _invoiceValue == -1
                                            ? CRMIcons.checked
                                            : CRMIcons.unchecked,
                                        size: 18,
                                        color: _invoiceValue == -1
                                            ? CRMColors.primary
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text('不带票'),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                  onTap: () => {
                                        setState(() {
                                          _invoiceValue = -1;
                                          this._hasmore = true;
                                          this._getInquiryQuoteDetail(page: 1);
                                        })
                                      }),
                            ],
                          ),
                        )),
                    if (_model['beatBackInfo'] != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 0, top: 8),
                        child: titleValueWidget(
                            title: '客服打回原因：',
                            value: _model['beatBackInfo'] ?? ''),
                      ),
                    if (_model['customerType'] == 3)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: titleValueWidget(
                            title: '汽修厂名称：',
                            value: _insuranceInfo['clientOrgName'] ?? ''),
                      ),
                    if (_model['customerType'] == 3)
                      titleValueWidget(
                          title: '联系人：',
                          value: _insuranceInfo['clientContactPerson'] ?? ''),
                    if (_model['customerType'] == 3)
                      titleValueWidget(
                          title: '联系方式：',
                          value: _insuranceInfo['clientContactMobile'] ?? ''),
                    if (_model['customerType'] == 3)
                      titleValueWidget(
                          title: '地址：', value: _insuranceInfo['address'] ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // tab区域
  Widget _buildMianContent() {
    return Container(
      height: h96,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          DarkTitleWidget(
            size: Status.MINI,
            title: _model['carTypeDisplayName'] ?? '未知车型',
          ),
        ],
      ),
    );
  }

  // 标签弹出框
  Widget _buildTagDialog(List activityTag) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          ...(activityTag.map((value) => Column(
                children: <Widget>[
                  _buildImageText(value['tagTip'], CRMText.normalText,
                      imageUrl: value['iconUrl'], mainTitle: value['tagName']),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CRMBorder.dividerDp1,
                  ),
                ],
              )))
        ],
      ),
    );
  }

  // 图片文字区域
  Widget _buildImageText(String title, TextStyle textStyle,
      {String imageUrl = '',
      Icon icon,
      String tagTip = '',
      String mainTitle = ''}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (imageUrl != null || icon != null)
          imageUrl != ''
              ? GestureDetector(
                  onTap: () => {
                    if (tagTip != '')
                      {
                        MessageBox.showBottomActionSheet(
                            context,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: _buildImageText(tagTip, CRMText.normalText,
                                  imageUrl: imageUrl),
                            ))
                      }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Image.network(
                      imageUrl,
                      height: 18,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
              : icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: icon,
                    )
                  : Container(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (mainTitle != '')
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 2),
                  child: Text(mainTitle, style: CRMText.boldTitleText),
                ),
              Text(
                title,
                style: textStyle,
              )
            ],
          ),
        )
      ],
    );
  }

  // 图片渲染区域
  Widget renderImage(List imgs, int index,
      {double width: 50, double height: 50, bool isRight: true}) {
    var img = imgs[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(FadeInRoute(
            widget: PhotoViewGalleryScreen(
          imgs: imgs,
          index: index,
          heroTag: img,
        )));
      },
      child: Container(
        alignment: isRight ? Alignment.topRight : Alignment.topLeft,
        width: width,
        height: height,
        child: Hero(
          tag: img,
          child: Image.network(
            img,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  // 主体滚动区域
  Widget _buildScrollContainer() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: double.infinity,
            color: CRMColors.commonBg,
            child: PullRefreshWidget(_leftList, (context, index) {
              return this._leftList.length > 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: selectParts == index
                                  ? Colors.white
                                  : CRMColors.commonBg,
                              border: Border(
                                  left: BorderSide(
                                      color: CRMColors.primary,
                                      width: selectParts == index ? 2 : 0))),
                          child: Stack(
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  children: <Widget>[
                                    Text(
                                        _leftList[index]['modifiedPartsName'] !=
                                                    '' &&
                                                _leftList[index]
                                                        ['modifiedPartsName'] !=
                                                    null
                                            ? _leftList[index]
                                                ['modifiedPartsName']
                                            : _leftList[index]['partsName'],
                                        style: TextStyle(
                                            color: selectParts == index
                                                ? CRMColors.primary
                                                : CRMColors.textLight,
                                            fontWeight: selectParts == index
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: CRMText.normalTextSize)),
                                    if (_leftList[index]
                                            ['inquiryDetailQuoteStatus'] ==
                                        3)
                                      Text(
                                        '(打回)',
                                        style: TextStyle(
                                            color: CRMColors.warning,
                                            fontSize: CRMText.normalTextSize),
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  selectParts = index;
                                  _choosePart(_leftList[index]);
                                },
                              ),
                              if (_leftList[index]['quoteDetailVOS']?.length ==
                                      0 ||
                                  _leftList[index]['quoteDetailVOS'] == null)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: CRMColors.borderDark,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        CRMBorder.dividerDp1
                      ],
                    )
                  : Container();
            }, _getInquiryQuoteDetail, _onRefresh),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(CRMGaps.gap_dp8),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (_inquiryInfo['partsName'] != null &&
                                _inquiryInfo['partsName'] != '')
                              _buildImageText(_inquiryInfo['partsName'],
                                  TextStyle(color: CRMColors.textDark),
                                  icon: Icon(
                                    CRMIcons.inquiryIcon,
                                    color: CRMColors.primary,
                                    size: 20,
                                  )),
                            if (_inquiryInfo['attrValue'] != '')
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('属性：${_inquiryInfo['attrValue']}'),
                              ),
                            if (_inquiryInfo['inquiryDetailUserPicDTOs'] !=
                                    null &&
                                _inquiryInfo['inquiryDetailUserPicDTOs']
                                        .length !=
                                    0)
                              Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Text('图片:'),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          width: 25,
                                          height: 25,
                                          child: ListView.builder(
                                            itemCount: (_inquiryInfo[
                                                        'inquiryDetailUserPicDTOs'] ??
                                                    [])
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              List imgs = _inquiryInfo[
                                                      'inquiryDetailUserPicDTOs']
                                                  .map((item) => item['picUrl'])
                                                  .toList();
                                              return renderImage(
                                                  imgs ?? [], index,
                                                  isRight: false,
                                                  width: 20,
                                                  height: 20);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            if (_inquiryInfo['remark'] != null &&
                                _inquiryInfo['remark'] != '')
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('备注：${_inquiryInfo['remark']}'),
                              ),
                            if (_inquiryInfo['remarkByCS'] != null &&
                                _inquiryInfo['remarkByCS'] != '')
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child:
                                    Text('客服备注：${_inquiryInfo['remarkByCS']}'),
                              ),
                            if (_inquiryInfo['inquiryDetailQuoteStatus'] == 3)
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    '打回原因：${_inquiryInfo['beatBackInfoDTO'] != null ? _inquiryInfo['beatBackInfoDTO']['beatBackInfo'] : '缺失信息'}'),
                              ),
                            SizedBox(height: 5),
                            if (_inquiryInfo['modifiedPartsName'] != null &&
                                _inquiryInfo['modifiedPartsName'] != '')
                              _buildImageText(_inquiryInfo['modifiedPartsName'],
                                  TextStyle(color: CRMColors.textDark),
                                  icon: Icon(
                                    CRMIcons.baoIcon,
                                    color: CRMColors.warning,
                                    size: 20,
                                  )),
                            if (_inquiryInfo['modifiedPartsName'] !=
                                    _inquiryInfo['partCode'] &&
                                _inquiryInfo['partCode'] != '' &&
                                _inquiryInfo['partCode'] != null)
                              Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text(
                                  _inquiryInfo['partCode'],
                                  style: TextStyle(color: CRMColors.textNormal),
                                ),
                              ),
                            SizedBox(height: 5),
                            if (_inquiryInfo['priceOf4s'] != null &&
                                _inquiryInfo['priceOf4s'] != '')
                              _buildImageText(
                                  '参考价：¥${_inquiryInfo['priceOf4s']}',
                                  TextStyle(color: CRMColors.textDarkLight),
                                  icon: Icon(
                                    CRMIcons.price4s,
                                    color: CRMColors.textNormal,
                                    size: 20,
                                  )),
                          ],
                        ),
                      ),
                      if ((_inquiryInfo['epcPicUrls'] ?? []).length > 0 ||
                          (_inquiryInfo['inquiryDetailPhysicalPicDTOs'] ?? [])
                                  .length >
                              0)
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                width: 45,
                                height: 45,
                                child: ListView.builder(
                                  itemCount:
                                      (_inquiryInfo['epcPicUrls'] ?? []).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return renderImage(
                                        _inquiryInfo['epcPicUrls'] ?? [],
                                        index);
                                  },
                                ),
                              ),
                              if ((_inquiryInfo[
                                              'inquiryDetailPhysicalPicDTOs'] ??
                                          [])
                                      .length >
                                  0)
                                Container(
                                  alignment: Alignment.topLeft,
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.only(left: 5),
                                  child: ListView.builder(
                                    itemCount: (_inquiryInfo[
                                                'inquiryDetailPhysicalPicDTOs'] ??
                                            [])
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List imgs = _inquiryInfo[
                                              'inquiryDetailPhysicalPicDTOs']
                                          .map((item) => item['picUrl'])
                                          .toList();
                                      return renderImage(imgs ?? [], index,
                                          isRight: false);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                  child: CRMBorder.dividerDp1,
                ),
                // Expanded(
                // child:
                _rightList != null && _rightList.isNotEmpty
                    ? Column(
                        children: <Widget>[
                          ...(_rightList ?? []).map<Widget>((partItem) {
                            bool hasIcon = partItem['activityTagDTOS'] !=
                                    null &&
                                (partItem['activityTagDTOS']
                                        .where((val) => val['region'] == 'A')
                                        .toList()
                                        .length >
                                    0);
                            bool hasIconB = partItem['activityTagDTOS'] !=
                                    null &&
                                (partItem['activityTagDTOS']
                                        .where((val) => val['region'] == 'B')
                                        .toList()
                                        .length >
                                    0);
                            List tagCDE = (partItem['activityTagDTOS'] ?? [])
                                .where((val) =>
                                    val['region'] == 'C' ||
                                    val['region'] == 'D' ||
                                    val['region'] == 'E')
                                .toList();
                            return Stack(
                              children: <Widget>[
                                GrayPanelWidget(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _buildImageText(
                                          '${partItem['factoryType'] != 'ORIGINAL' ? _factoryTypesMap[partItem['factoryType']] : ''}${partItem['partsBrandName']}  ${partItem['placeOfOrigin']}',
                                          CRMText.mainTitleText,
                                          imageUrl: hasIcon
                                              ? partItem['activityTagDTOS']
                                                  .where((item) =>
                                                      item['region'] == 'A')
                                                  .toList()
                                                  .map((value) =>
                                                      value['iconUrl'])
                                                  .first
                                              : ''),
                                      if (partItem['bookGoodsDTO'] != null &&
                                          partItem['bookGoodsDTO']
                                                  ['bookGoodsDays'] !=
                                              null)
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            '(订货${partItem['bookGoodsDTO']['bookGoodsDays']}个工作日，${partItem['bookGoodsDTO']['returnable'] ? '' : '不'}可退)',
                                            style: TextStyle(
                                                color: CRMColors.warning,
                                                fontSize:
                                                    CRMText.smallTextSize),
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: RichText(
                                            text: TextSpan(
                                                text:
                                                    '质保${partItem['guaranteePeriod'] ?? 0}个月',
                                                style: TextStyle(
                                                    color: CRMColors.textNormal,
                                                    fontSize:
                                                        CRMText.smallTextSize),
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: partItem['quoteDeliveryDTO'] !=
                                                              null &&
                                                          partItem['quoteDeliveryDTO']
                                                                  [
                                                                  'supplierShippedPlan'] !=
                                                              null
                                                      ? ' | ${partItem['quoteDeliveryDTO']['supplierShippedPlan']}'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize:
                                                        CRMText.smallTextSize,
                                                  ))
                                            ])),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: _buildImageText(
                                            partItem['quoteDetailWarehouseInfoDTO'] !=
                                                        null &&
                                                    (partItem['quoteDetailWarehouseInfoDTO']
                                                            ['warehouseName'] !=
                                                        null)
                                                ? '| 由${partItem['quoteDetailWarehouseInfoDTO']['warehouseName']}从${partItem["deliveryPlace"] ?? ''}发货'
                                                : '${hasIconB ? '| ' : ''}从${partItem["deliveryPlace"] ?? ''}发货',
                                            TextStyle(
                                                color: CRMColors.textNormal,
                                                fontSize:
                                                    CRMText.smallTextSize),
                                            imageUrl: hasIconB
                                                ? partItem['activityTagDTOS']
                                                    .where((item) =>
                                                        item['region'] == 'B')
                                                    .toList()
                                                    .map((value) =>
                                                        value['iconUrl'])
                                                    .first
                                                : '',
                                            tagTip: hasIconB
                                                ? partItem['activityTagDTOS']
                                                    .where((item) =>
                                                        item['region'] == 'B')
                                                    .toList()
                                                    .map((value) => value['tagTip'])
                                                    .first
                                                : ''),
                                      ),
                                      if (partItem["arriveTimeTip"] != null &&
                                          partItem["arriveTimeTip"] != '')
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            '(${partItem["arriveTimeTip"]})',
                                            style: TextStyle(
                                                color: CRMColors.textNormal,
                                                fontSize:
                                                    CRMText.smallTextSize),
                                          ),
                                        ),
                                      if (partItem["remark"] != null &&
                                          partItem["remark"] != '')
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: titleValueWidget(
                                              title: '备注：',
                                              value: partItem["remark"] ?? '',
                                              textSize: CRMText.smallTextSize,
                                              titleColor: CRMColors.textNormal),
                                        ),
                                      if (partItem["remark"] == null ||
                                          partItem["remark"] == '')
                                        SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => {
                                          MessageBox.showBottomActionSheet(
                                              context, _buildTagDialog(tagCDE))
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            ...(tagCDE.map((value) => Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5, bottom: 10),
                                                child: Image.network(
                                                    value['iconUrl'],
                                                    height: 20,
                                                    fit: BoxFit.fitHeight))))
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            CRMRadius.radius16),
                                        child: Container(
                                            width: double.infinity,
                                            height: ScreenFit.width(52),
                                            color: CRMColors.primaryApla10,
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    '现价：￥${partItem['couponDiscountPrice'] ?? partItem['promotionUnitPrice'] ?? partItem['quotePrice'] ?? ''}',
                                                    textAlign: partItem[
                                                                    'couponDiscountPrice'] !=
                                                                null ||
                                                            partItem[
                                                                    'promotionUnitPrice'] !=
                                                                null
                                                        ? TextAlign.right
                                                        : TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            CRMColors.primary,
                                                        fontSize: CRMText
                                                            .normalTextSize,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                if (partItem[
                                                            'couponDiscountPrice'] !=
                                                        null ||
                                                    partItem[
                                                            'promotionUnitPrice'] !=
                                                        null)
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      '原价 ¥${partItem['preDiscountQuotePrice']}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: CRMColors
                                                              .textLight,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: CRMText
                                                              .smallTextSize),
                                                    ),
                                                  ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        height: CRMGaps.gap_dp10,
                                      )
                                    ],
                                  ),
                                  onXiaobaTap: () {
                                    XiaobaQueryModel xiaoba = XiaobaQueryModel(
                                        inquiryId: int.parse(widget.inquiryId),
                                        inquiryDetailId: int.parse(
                                            partItem['inquiryDetailId']),
                                        supplierId:
                                            int.parse(partItem['supplierId']),
                                        orderType: 1,
                                        targetType: 1,
                                        distributeTo: 'service');
                                    CRMNavigator.goXiaobaPage(xiaoba);
                                  },
                                ),
                                Positioned(
                                    right: CRMGaps.gap_dp16,
                                    top: CRMGaps.gap_dp16,
                                    child: Row(
                                      children: <Widget>[
                                        ...(partItem['pictures'] ?? []).map(
                                          (item) => Padding(
                                              padding: EdgeInsets.only(
                                                  left: CRMGaps.gap_dp4),
                                              // left: index == 0
                                              //     ? 0
                                              //     : CRMGaps.gap_dp4),
                                              child: InkWell(
                                                onTap: () {
                                                  if (item != '' &&
                                                      !_loadPicError) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              HeroPhotoViewWrapper(
                                                            imageProvider:
                                                                NetworkImage(
                                                                    item),
                                                          ),
                                                        ));
                                                  }
                                                },
                                                child: Hero(
                                                  tag: '$item',
                                                  child: CachedNetworkImage(
                                                      width:
                                                          ScreenFit.width(60),
                                                      height:
                                                          ScreenFit.width(60),
                                                      fit: BoxFit.cover,
                                                      imageUrl: item,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        setState(() {
                                                          _loadPicError = true;
                                                        });
                                                        return Image.asset(
                                                            'assets/images/image_error.png',
                                                            width:
                                                                ScreenFit.width(
                                                                    120),
                                                            height:
                                                                ScreenFit.width(
                                                                    120));
                                                      }),
                                                ),
                                              )),
                                        )
                                      ],
                                    ))
                              ],
                            );
                          })
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: NoDataWidget(
                          colorful: false,
                          title: '此配件正在报价中~',
                        ),
                      ),
                // ),
              ],
            ),
          )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var topWidget = Column(
      children: <Widget>[
        if (_urgeStatus != 4)
          Container(
            color: CRMColors.warningLightApla,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: _buildInfoItem(
              '报价倒计时：',
              color: CRMColors.warning,
              rightWidget: Row(
                // direction: Axis.horizontal,
                children: <Widget>[
                  if (_animationController != null) _buildCountDown(),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Icon(
                          CRMIcons.question,
                          size: 16,
                          color: CRMColors.textNormal,
                        ),
                      ),
                      onTap: () => MessageBox.alert(context,
                          '当您发起一次询价后，会立即生成报价倒计时，在倒计时结束前，平台会尽快给您报价。非平台工作时间内（18:00~次日9:00）倒计时暂停'),
                    ),
                  ),
                  if (_urgeStatus != 4 && _urgeStatus != null)
                    ButtonBigRadiusWidget(
                      title: _urgeStatus == 3 ? '已催' : '催报价',
                      color: _urgeStatus == 1
                          ? CRMColors.primary
                          : CRMColors.borderDark,
                      onPressed: _urge,
                    ),
                ],
              ),
            ),
          ),
        CustomerInfoWidget(
          orgName: _model['orgName'],
          phone: _model['contactPhone'],
          contact: _model['contactUsername'],
          customerId: _model['customerId']?.toString(),
          orgId: _model['orgId'],
          isGroup: _model['customerType'] == 2,
          isInsurance: _model['customerType'] == 3,
          rightWidget: IconButton(
            onPressed: () {
              setState(() {
                this._showInsuranceInfo = !this._showInsuranceInfo;
              });
            },
            icon: Icon(_showInsuranceInfo ? CRMIcons.pickup : CRMIcons.expand,
                size: _showInsuranceInfo ? 11 : 20,
                color: CRMColors.textNormal),
          ),
        ),
        CRMBorder.dividerDp1,
        if (_showInsuranceInfo) _buildInquiryItem(),
        Container(
          color: CRMColors.commonBg,
          width: double.infinity,
          height: 10,
        ),
      ],
    );

    var body = RefreshIndicator(
      color: Colors.white,
      backgroundColor: CRMColors.primary,
      onRefresh: _onRefresh,
      child: Column(
        children: <Widget>[
          topWidget,
          _buildMianContent(),
          Expanded(
            child: Container(
              child: _leftList.length > 0
                  ? _buildScrollContainer()
                  : NoDataWidget(
                      colorful: false,
                      height: 50,
                    ),
              color: Colors.white,
            ),
          )
        ],
      ),
    );

    return Scaffold(
        appBar: AppbarWidget(
          title: '${_model['inquiryNo'] ?? ''}',
          actions: <Widget>[
            IconButton(
              onPressed: () {
                CRMNavigator.goWorkOrderAddPage(
                    orderNo: _model['inquiryNo'] ?? '');
              },
              icon: Icon(
                CRMIcons.workOrderAdd,
                size: ScreenFit.width(41),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: body,
          ),
        ));
  }

  // 实现tab的状态保存
  @override
  bool get wantKeepAlive => true;
}
