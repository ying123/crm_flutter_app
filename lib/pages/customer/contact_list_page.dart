import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/circle_search_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListPage extends StatefulWidget {
  final String customerId;
  ContactListPage(
    this.customerId, {
    Key key,
  }) : super(key: key);

  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  String _keyword = '';
  int _pageSize = 20;
  int _page = 1;
  int _totalPage = 0;
  List _list = new List();
  bool hasMore = true;
  bool _loading = false;

  TextEditingController _searchEditController = new TextEditingController();
  Widget _buildCustomerItem(String id, String name, String phone) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  CRMNavigator.goContactDetailPage(
                      int.parse(id), int.parse(widget.customerId));
                },
                child: Padding(
                    padding: EdgeInsets.only(
                        top: CRMGaps.gap_dp10,
                        bottom: CRMGaps.gap_dp10,
                        left: CRMGaps.gap_dp16),
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: CRMText.normalTextSize,
                          fontWeight: FontWeight.bold,
                          color: CRMColors.textNormal),
                    )),
              ),
            ),
            Offstage(
              offstage: !(phone != null && phone != ''),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showDialog(context, phone);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: CRMGaps.gap_dp16),
                      child: Text(phone, style: CRMText.normalText),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDialog(context, phone);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        CRMIcons.phone,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Offstage(
              offstage: !(phone == null || phone == ''),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 23),
              ),
            )
          ],
        ),
        CRMBorder.dividerDp1,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getData(page: 1);
  }

  // 弹出确认弹窗
  Future<void> _showDialog(context, phone) async {
    var confirm = await MessageBox.confirm(context, phone, title: '确认拨打电话');
    if (confirm) {
      this._makePhoneCall('tel:$phone');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('拨打电话失败');
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppbarWidget(
          title: '联系人',
          actions: <Widget>[
            IconButton(
              onPressed: () {
                CRMNavigator.goContactCreatePage(int.parse(widget.customerId));
              },
              icon: Icon(CRMIcons.add),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            SearchCardWidget(
              hintText: '请输入联系人名称',
              textEditingController: _searchEditController,
              onSubmitted: (text) {
                this._handleSearch(text);
              },
            ),
            Expanded(
              child: _buildListWidget(),
            )
          ],
        ));
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
      ResultDataModel res = await httpGet(Apis.ContractList,
          queryParameters: {
            "cactName": this._keyword,
            "limit": this._pageSize,
            "custId": widget.customerId
          },
          showLoading: true);

      if (mounted) {
        setState(() {
          this._loading = false;
        });
      }

      if (res.code == 0 && mounted) {
        setState(() {
          this._loading = false;
          this._totalPage = (res.data['total'] / this._pageSize).ceil();
          this._list.addAll(res.data['list']);
        });
        this._page++;
        print('当前的页码， 总的页码数据, ${this._page}, ${this._totalPage}');
        if (this._page > this._totalPage) {
          setState(() {
            this.hasMore = false;
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
                _buildCustomerItem(_list[index]['id'], _list[index]['cactName'],
                    _list[index]['cactTel']),
                if (index == this._list.length - 1) _getMoreWidget()
              ],
            )
          : NoDataWidget();
    }, _getData, _onRefresh);
  }
}
