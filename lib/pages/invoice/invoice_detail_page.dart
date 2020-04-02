import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceDetailPage extends StatefulWidget {
  final int id;
  final Map<String, dynamic> info;
  InvoiceDetailPage(this.id, this.info);

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  int activeTab;
  List invoiceInfo = new List();
  String orderNo;
  String startDateStr;
  String endDateStr;

  GlobalKey _keyFilter = GlobalKey();

  Size _fixSize;
  bool _isloading = true;
  bool hasMore = true;
  int _page = 1;
  int _pageSize = 10;

  final ScrollController _scrollViewController =
      ScrollController(initialScrollOffset: 0.0);

  // 列表项
  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: CRMColors.textLight)),
            title != ''
                ? Text('：', style: TextStyle(color: CRMColors.textLight))
                : Container(),
            Expanded(
              child: Text(value, style: TextStyle(color: CRMColors.textLight)),
            ),
          ],
        ),
        SizedBox(
          height: ScreenFit.height(16),
        ),
      ],
    );
  }

  // 两列布局
  Widget _buildTwoColumnsItem(
      String title1, String value1, String title2, String value2,
      {Color value1Color = CRMColors.textLight,
      Color value2Color = CRMColors.textLight}) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Text(title1, style: TextStyle(color: CRMColors.textLight)),
                  title1 != ''
                      ? Text('：', style: TextStyle(color: CRMColors.textLight))
                      : Container(),
                  Expanded(
                    child: Text(value1, style: TextStyle(color: value1Color)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Text(title2, style: TextStyle(color: CRMColors.textLight)),
                  title2 != ''
                      ? Text('：', style: TextStyle(color: CRMColors.textLight))
                      : Container(),
                  Expanded(
                    child: Text(value2, style: TextStyle(color: value2Color)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenFit.height(16),
        ),
      ],
    );
  }

  // 三列布局
  Widget _buildThreeeColumnsItem(String title, String value, String status) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(title, style: TextStyle(color: CRMColors.textLight)),
            ),
            Expanded(
              flex: 1,
              child: Text(value, style: TextStyle(color: CRMColors.textLight)),
            ),
            Expanded(
              flex: 1,
              child: Text(status, style: TextStyle(color: CRMColors.textLight)),
            ),
          ],
        ),
        SizedBox(
          height: ScreenFit.height(16),
        ),
      ],
    );
  }

  // 发票详情
  Widget _buildInvoiceInfo() {
    return Column(
      children: <Widget>[
        // SizedBox(height: 50),
        CRMBorder.dividerDp1Dark,
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: <Widget>[
              _buildInfoItem('单据号', widget.info['codeNo'].toString()),
              _buildInfoItem('申请单', widget.info['invoiceApplyNo'].toString()),
              _buildInfoItem('税率', widget.info['taxRate'].toString()),
              _buildInfoItem('含税价', widget.info['totalMoney'].toString()),
              _buildInfoItem('不含税价', widget.info['noTaxMoney'].toString()),
              widget.info['isInvoice'] == 0
                  ? Container()
                  : _buildInfoItem('发票号码', widget.info['invoiceNo'] ?? '未知'),
              _buildThreeeColumnsItem(
                  widget.info['invoiceType'] == 0 ? '普通发票' : '增值税发票',
                  '${widget.info['year']}年${widget.info['month']}月' ?? '未知',
                  widget.info['isInvoice'] == 0 ? '未开' : '已开'),
              _buildThreeeColumnsItem(
                  widget.info['qualificationType'] == 0
                      ? '有发票资质'
                      : widget.info['qualificationType'] == 1
                          ? '没有发票资质'
                          : widget.info['qualificationType'] == 2
                              ? '发票资质待审核'
                              : '未知',
                  widget.info['invoiceOrderType'] == 0 ? '没冲红' : '冲红',
                  widget.info['status'] == 0
                      ? '正常'
                      : widget.info['status'] == 1
                          ? '作废'
                          : widget.info['status'] == 1 ? '重开' : ''),
            ],
          ),
        ),
        Container(height: 10, color: CRMColors.commonBg)
      ],
    );
  }

  // tab item
  Widget _buildTabItemWidget(String title, int index) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            this.activeTab = index;
            this._clearFilter();
            this.hasMore = true;
            this._isloading = false;
            this._getData(page: 1);
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(title,
              style: TextStyle(
                  color: activeTab == index
                      ? CRMColors.primary
                      : CRMColors.textNormal)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: activeTab == index
                          ? CRMColors.primary
                          : CRMColors.borderLight,
                      width: activeTab == index ? 2 : 1))),
        ),
      ),
    );
  }

  // tab
  Widget _buildTabWiget() {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _buildTabItemWidget('发票详情', 1),
              _buildTabItemWidget('退款详情', 2),
            ],
          ),
        )
      ],
    );
  }

  // 发票列表项
  Widget _buildInvoiceItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: CRMColors.blueLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            _buildInfoItem('订单号', item['orderNo'] ?? ''),
            _buildInfoItem('配件名', item['partsName'] ?? ''),
            _buildInfoItem('支付时间', item['payTime'] ?? ''),
            // _buildInfoItem('含税价', item['applyAmount']?.toString() ?? ''),
            _buildInfoItem('不含税价', item['noTaxMoney']?.toString() ?? ''),
            _buildThreeeColumnsItem('数量：${item['num']}',
                '单位：${item['unit'] ?? ''}', '单价：${item['unitPrice']}'),
          ],
        ),
      ),
    );
  }

  // 退款详情列表项
  Widget _buildRefundInvoiceItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: CRMGaps.gap_dp10, vertical: CRMGaps.gap_dp14),
        decoration: BoxDecoration(
          color: CRMColors.blueLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            _buildInfoItem('', item['partsName'] ?? ''),
            _buildTwoColumnsItem(
                '备注号',
                item['invoiceDetailReportNo'],
                '',
                (item['returnNo'] != null && item['returnNo'] != '')
                    ? item['returnNo'].toString().substring(0, 2)
                    : '',
                value2Color: CRMColors.danger),
            _buildTwoColumnsItem('订单号', item['orderNo']?.toString() ?? '',
                '退款单号', item['returnNo']?.toString() ?? ''),
            _buildTwoColumnsItem('数量', item['num']?.toString() ?? '', '单价',
                item['unitPrice']?.toString() ?? ''),
            _buildTwoColumnsItem(
                '实付金额',
                item['partsCashAmount']?.toString() ?? '',
                '实退金额',
                item['applyAmount']?.toString() ?? ''),
            _buildInfoItem('支付时间', item['payTime']?.toString() ?? ''),
            _buildInfoItem('退款时间', item['returnTime']?.toString() ?? ''),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.activeTab = 1;
    this.hasMore = true;
    this._isloading = false;
    this._getData(page: 1);

    /// 获取元素的位置与尺寸
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
  }

  // 页面layout之后获取widget的位置和尺寸
  _afterLayout(_) {
    _getPositions('_keyFilter', _keyFilter);
    _getSizes('_keyFilter', _keyFilter);
  }

  _getPositions(log, GlobalKey globalKey) {
    RenderBox renderBoxFix = globalKey.currentContext.findRenderObject();
    var positionFix = renderBoxFix.localToGlobal(Offset.zero);
    print('position of $log: $positionFix');
  }

  _getSizes(log, GlobalKey globalKey) {
    RenderBox renderBoxFix = globalKey.currentContext.findRenderObject();
    _fixSize = renderBoxFix.size;
    setState(() {});
    print('SIZE of $log: $_fixSize');
  }

  // 清除筛选条件
  _clearFilter() {
    this.endDateStr = null;
    this.startDateStr = null;
    this.orderNo = null;
  }

  // 判断显示loading图标
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    if (mounted) {
      setState(() {
        this.hasMore = true;
        this._isloading = false;
        _getData(page: 1);
      });
    }
  }

  // 请求与数据
  Future<void> _getData({page}) async {
    if (this.hasMore && !this._isloading && mounted) {
      setState(() {
        this._isloading = true;
        if (page != null) {
          this._page = page;
          this.invoiceInfo.length = 0;
        }
      });

      Map<String, dynamic> params = {
        'invoiceId': activeTab == 1 ? widget.id : widget.info['invoiceApplyId'],
        'page': this._page,
        'limit': this._pageSize
      };

      if (this.orderNo != null) {
        params['orderNo'] = this.orderNo;
      }

      if (this.startDateStr != null) {
        params['startTime'] = this.startDateStr;
      }

      if (this.endDateStr != null) {
        params['endTime'] = this.endDateStr;
      }

      ResultDataModel res;
      if (activeTab == 1) {
        res = await httpGet(Apis.InvoiceDetail,
            queryParameters: params, showLoading: true);
      } else if (activeTab == 2) {
        res = await httpGet(Apis.InvoiceRefundDetail,
            queryParameters: params, showLoading: true);
      }

      if (res.code == 0) {
        setState(() {
          this._isloading = false;
          this.invoiceInfo.addAll(res.data);
          this._page++;
          if (res.data.length < this._pageSize) {
            setState(() {
              this.hasMore = false;
            });
          }
          print('当前的页码, $_page, $hasMore');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              forceElevated: boxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: _buildInvoiceInfo(),
                ),
              ),
              expandedHeight: (_fixSize == null
                      ? ScreenUtil.screenHeight
                      : _fixSize.height) +
                  45,
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 45),
                child: _buildTabWiget(),
              ),
            ),
          ];
        },
        body: Container(
            color: Colors.white,
            child: PullRefreshWidget(this.invoiceInfo, (context, index) {
              return invoiceInfo.length > 0
                  ? Column(
                      children: <Widget>[
                        SizedBox(height: ScreenFit.height(16)),
                        activeTab == 1
                            ? _buildInvoiceItem(invoiceInfo[index])
                            : _buildRefundInvoiceItem(invoiceInfo[index]
                                ['invoiceApplyOrderDetailDTO']),
                        SizedBox(height: ScreenFit.height(10)),
                        if (index == this.invoiceInfo.length - 1)
                          _getMoreWidget()
                      ],
                    )
                  : NoDataWidget();
            }, _getData, _onRefresh)));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '发票管理明细',
        actions: <Widget>[
          IconButton(
            icon: Icon(CRMIcons.filter, size: ScreenFit.width(42)),
            onPressed: () async {
              var result = await CRMNavigator.goInvoiceDetailFilterPage();
              if (result != null) {
                setState(() {
                  this.orderNo = result['orderNo'];
                  this.startDateStr = result['startDateStr'];
                  this.endDateStr = result['endDateStr'];
                  this.hasMore = true;
                  this._isloading = false;
                  this._getData(page: 1);
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Offstage(
                offstage: true,
                child: Container(
                  child: _buildInvoiceInfo(),
                  key: _keyFilter,
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
