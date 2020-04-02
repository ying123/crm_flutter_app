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

class InvoiceListPage extends StatefulWidget {
  final orgId;
  final int activeTab;
  InvoiceListPage(this.orgId, {this.activeTab});

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  int activeTab;
  List _list = new List();
  String _year = '';
  String _month = '';
  String _codeNo = ''; // 单据号
  String _invoiceApplyNo = ''; // 申请号
  String _invoiceNo = ''; // 发票号码
  int _invoiceOrderType; // 发票明细类型
  int _status; // 发票状态
  int _invoiceType; // 发票类型
  int _isInvoice; // 开票状态
  int _page = 1; // 页码
  int _pageSize = 10; // 条数
  bool hasMore = true;
  bool _isloading = false;

  // tab item
  Widget _buildTabItemWidget(String title, int key) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          this.setState(() => {
                // 清空过滤的数据
                clearFilterParams(),
                this.activeTab = key,
                this.hasMore = true,
                this._isloading = false,
                this._getData(page: 1)
              });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(title,
              style: TextStyle(
                  color: activeTab == key
                      ? CRMColors.primary
                      : CRMColors.textNormal)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: activeTab == key
                          ? CRMColors.primary
                          : CRMColors.borderLight,
                      width: activeTab == key ? 2 : 1))),
        ),
      ),
    );
  }

  // tab
  Widget _buildTabWiget() {
    return Container(
      height: 40,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          _buildTabItemWidget('未开', 0),
          _buildTabItemWidget('已开', 1),
          _buildTabItemWidget('全部', null),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.activeTab = widget.activeTab;
    this._getData(page: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 清空过滤数据
  clearFilterParams() {
    setState(() {
      this._year = '';
      this._month = '';
      this._codeNo = '';
      this._invoiceApplyNo = '';
      this._invoiceNo = '';
      this._isInvoice = null;
      this._status = null;
      this._invoiceType = null;
      this._invoiceOrderType = null;
    });
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
          this._list.length = 0;
        }
      });

      Map<String, dynamic> query = {
        // 'orgId': '1003237',
        'orgId': widget.orgId,
        'page': this._page,
        'limit': this._pageSize,
        'codeNo': this._codeNo ?? '',
        'year': this._year ?? '',
        'month': this._month ?? '',
        'invoiceApplyNo': this._invoiceApplyNo ?? '',
        'invoiceNo': this._invoiceNo ?? '',
      };
      if (this.activeTab != null) {
        query['isInvoice'] = this.activeTab;
      }
      if (this._isInvoice != null) {
        query['isInvoice'] = this._isInvoice;
      }
      if (this._invoiceOrderType != null) {
        query['invoiceOrderType'] = this._invoiceOrderType;
      }
      if (this._status != null) {
        query['status'] = this._status;
      }
      if (this._invoiceType != null) {
        query['invoiceType'] = this._invoiceType;
      }

      ResultDataModel res = await httpGet(Apis.InvoiceList,
          queryParameters: query, showLoading: true);

      if (res.code == 0 && mounted) {
        setState(() {
          this._isloading = false;
          this._list.addAll(res.data);
          this._page++;
          print('当前的页码，$_page, $hasMore');
          if (res.data.length < this._pageSize) {
            this.hasMore = false;
          }
        });
      }
    }
  }

  // 判断显示loading图标
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '发票管理',
        elevation: 2,
        bottom: PreferredSize(
            child: _buildTabWiget(),
            preferredSize: Size(double.infinity, 40.0)),
        actions: <Widget>[
          IconButton(
            icon: Icon(CRMIcons.filter, size: ScreenFit.width(42)),
            onPressed: () async {
              var result = await CRMNavigator.goInvoiceListFilterPage();
              if (result != null) {
                setState(() {
                  this._year = result['year'] ?? '';
                  this._month = result['month'] ?? '';
                  this._invoiceApplyNo = result['invoiceApplyNo'] ?? '';
                  this._codeNo = result['codeNo'] ?? '';
                  this._invoiceNo = result['invoiceNo'] ?? '';
                  this._invoiceType = result['invoiceType'] ?? null;
                  this._invoiceOrderType = result['invoiceOrderType'] ?? null;
                  this._status = result['status'] ?? null;
                  this._isInvoice = result['isInvoice'] ?? null;
                  this.hasMore = true;
                  this._isloading = false;
                  this._getData(page: 1);
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenFit.height(10),
            ),
            Expanded(
              child: PullRefreshWidget(this._list, (context, index) {
                return this._list.length == 0
                    ? NoDataWidget()
                    : Column(
                        children: <Widget>[
                          _buildInvoiceItem(this._list[index]),
                          if (index == this._list.length - 1) _getMoreWidget()
                        ],
                      );
              }, _getData, _onRefresh),
            )
          ],
        ),
      ),
    );
  }

  // 列表项
  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(title, style: TextStyle(color: CRMColors.textLight)),
            Text('：', style: TextStyle(color: CRMColors.textLight)),
            Text(value.toString(),
                style: TextStyle(color: CRMColors.textLight)),
          ],
        ),
        SizedBox(height: ScreenFit.height(16)),
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
              child: Text(title.toString(),
                  style: TextStyle(color: CRMColors.textLight)),
            ),
            Expanded(
              flex: 1,
              child: Text(value.toString(),
                  style: TextStyle(color: CRMColors.textLight)),
            ),
            Expanded(
              flex: 1,
              child: Text(status.toString(),
                  style: TextStyle(color: CRMColors.textLight)),
            ),
          ],
        ),
        SizedBox(height: ScreenFit.height(16)),
      ],
    );
  }

  // 发票列表项
  Widget _buildInvoiceItem(item) {
    return GestureDetector(
      onTap: () {
        CRMNavigator.goInvoiceDetailPage(item['id'], item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: CRMColors.blueLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            _buildInfoItem('单据号', item['codeNo'].toString()),
            _buildInfoItem('申请单', item['invoiceApplyNo'].toString()),
            _buildInfoItem('税率', item['taxRate'].toString()),
            _buildInfoItem('含税价', item['totalMoney'].toString()),
            _buildInfoItem('不含税价', item['noTaxMoney'].toString()),
            item['isInvoice'] == 0
                ? Container()
                : _buildInfoItem('发票号码', item['invoiceNo'] ?? '未知'),
            _buildThreeeColumnsItem(
                item['invoiceType'] == 0 ? '普通发票' : '增值税发票',
                '${item['year']}年${item['month']}月' ?? '未知',
                item['isInvoice'] == 0 ? '未开' : '已开'),
            _buildThreeeColumnsItem(
                item['qualificationType'] == 0
                    ? '有发票资质'
                    : item['qualificationType'] == 1
                        ? '没有发票资质'
                        : item['qualificationType'] == 2 ? '发票资质待审核' : '未知',
                item['invoiceOrderType'] == 0 ? '没冲红' : '冲红',
                item['status'] == 0
                    ? '正常'
                    : item['status'] == 1
                        ? '作废'
                        : item['status'] == 1 ? '重开' : ''),
          ],
        ),
      ),
    );
  }
}
