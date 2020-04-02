import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/widgets/circle_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';

import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/link_cell_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';

class CustomerListPage extends StatefulWidget {
  final String type;
  final String mfctyIds;
  CustomerListPage({Key key, this.type, this.mfctyIds}) : super(key: key);

  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  TextEditingController _searchEditController = new TextEditingController();
  List _list = new List();

  int _page = 1;
  int _pageSize = 20;
  String _keyword = '';
  bool _loading = false;
  bool hasMore = true;
  int _totalPage = 0;

  // 跳转到详情页
  _jumpToDetail(item, mfctyId) {
    CRMNavigator.goCustomerInfoPage(item, int.parse(mfctyId));
  }

  // 搜索处理函数
  _handleSearch(text) {
    this.setState(() {
      this._keyword = text;
      this._loading = false;
      this.hasMore = true;
      this._page = 1;
      this._list.length = 0;
      this._getData(page: 1);
    });
  }

  @override
  void initState() {
    super.initState();
    this._getData(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppbarWidget(
        title: '${widget.type == 'new' ? '新客户信息' : '客户信息'}',
      ),
      body: Column(
        children: <Widget>[
          SearchCardWidget(
              textEditingController: _searchEditController,
              onSubmitted: (text) {
                this._handleSearch(text);
              }),
          Expanded(
            child: _buildListWidget(),
          )
        ],
      ),
    );
  }

  // 判断显示loading图标
  Widget _getMoreWidget() {
    if (hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  // 加载数据源
  Future<void> _getData({page}) async {
    if (this.hasMore && !this._loading && mounted) {
      setState(() {
        this._loading = true;
        if (page != null) {
          this._page = page;
          this._list.length = 0;
        }
      });

      Map<String, dynamic> params = {
        "limit": this._pageSize,
        "mfctyName": this._keyword,
        'page': this._page,
        // 'mfctyIds': mfctyIds,
        'queryNewCustomer': widget.type == 'new' ? true : false
      };

      if (widget.type == 'new' && widget.mfctyIds == '') {
      } else {
        params['mfctyIds'] = widget.mfctyIds;
      }

      ResultDataModel res = await httpGet(Apis.CustomerList,
          queryParameters: params, showLoading: true);

      if (res.code == 0 && mounted) {
        if (res.data != null) {
          setState(() {
            this._loading = false;
            this._totalPage = (res.data['total'] / this._pageSize).ceil();
            this._list.addAll(res.data['list']);
            this._page++;
          });
          print('当前的页码， 总的页码数据, ${this._page}, ${this._totalPage}');
          if (this._page > this._totalPage) {
            setState(() {
              this.hasMore = false;
            });
          }
        } else {
          setState(() {
            this._loading = false;
            this._totalPage = 0;
            this._list.length = 0;
          });
        }
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    this.hasMore = true;
    this._loading = false;
    _getData(page: 1);
  }

  // 列表区域
  Widget _buildListWidget() {
    return PullRefreshWidget(_list, (context, index) {
      return this._list.length > 0
          ? Column(
              children: <Widget>[
                linkCellWidget(
                    title: '${_list[index]['mfctyName']}',
                    showRightArrow: false,
                    tapCallback: () {
                      _jumpToDetail(
                          '${_list[index]['id']}', _list[index]['mfctyId']);
                    }),
                if (index == this._list.length - 1) _getMoreWidget()
              ],
            )
          : NoDataWidget();
    }, _getData, _onRefresh);
  }
}
