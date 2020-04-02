import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class InquiryHugeTransListPage extends StatefulWidget {
  @override
  _InquiryHugeTransListPageState createState() =>
      _InquiryHugeTransListPageState();
}

class _InquiryHugeTransListPageState extends State<InquiryHugeTransListPage>
    with SingleTickerProviderStateMixin {
  int activeTab = 0;
  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;
  int _total = 0;
  int _pageSize = 10;
  List _list = new List();
  Map<int, String> inquiryStatusesMap = {
    0: '',
    1: '1',
    2: '2',
    3: '3',
  };
  String provinceId = '';
  String cityId = '';
  String countyId = '';
  String orgName = '';
  String inquiryNo = '';
  String startTime =
      '${DateTime.now().year}-${DateTime.now().month}-01 00:00:00';
  String endTime = '';

  @override
  void initState() {
    super.initState();
    _getData(page: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 重置搜索状态
  void clearFilter() {
    setState(() {
      this.provinceId = '';
      this.cityId = '';
      this.countyId = '';
      this.inquiryNo = '';
      this.orgName = '';
      this.startTime = '';
      this.endTime = '';
    });
  }

  Future<void> _getData({page}) async {
    if (this._loading) return;
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      _hasMore = true;
      _loading = false;
      this._page = page;
      this._list = [];
    }
    if (this._hasMore && !this._loading) {
      if (mounted) {
        setState(() {
          this._loading = true;
        });
      }
      var model;
      ResultDataModel resultDataModel =
          await httpGet(Apis.TrackOrderInquiryList,
              queryParameters: {
                "status": inquiryStatusesMap[this.activeTab],
                "minAveragePrice": 3000,
                "areaQuery.provinceId": provinceId,
                "areaQuery.cityId": cityId,
                "areaQuery.countyId": countyId,
                "orgName": orgName,
                "inquiryId": inquiryNo,
                "startPublishTime": startTime,
                "endPublishTime": endTime,
                "page": this._page,
                "limit": this._pageSize,
              },
              showLoading: true);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (resultDataModel.code == 0) {
        model = resultDataModel.data;
        if (this.mounted) {
          if (model['total'] <= 0) {
            setState(() {
              this._total = 0;
              this._list = [];
              this._hasMore = false;
              return;
            });
          }
          setState(() {
            this._total = model['total'];
            this._list.addAll(model['list']);
            this._page++;
          });
          // 判断是否是最后一页
          if (this._total < (this._page * this._pageSize)) {
            setState(() {
              this._hasMore = false;
            });
          }
        }
      } else {
        Utils.showToast(resultDataModel.msg);
      }
    }
  }

  InquiryDTOModel getInquiryDTOModel(int index) {
    InquiryDTOModel model = InquiryDTOModel(
        inquiryNo: this._list[index]['inquiryNo'],
        inquiryId: this._list[index]['inquiryId']?.toString() ?? '',
        quoteStatus: this._list[index]['quoteStatus'],
        inquiryStatus: this._list[index]['status'],
        lastPublishTime: this._list[index]['lastPublishTime'] ?? '',
        orgName: this._list[index]['orgName'] ?? '',
        carTypeInfo: this._list[index]['carTypeDisplayName'] ?? '未知车型',
        averagePrice: this._list[index]['averagePrice'] ?? 0,
        inquiryDetailCount: this._list[index]['inquiryDetailCount'] ?? 0,
        quoteCount: this._list[index]['quoteCount'] ?? 0,
        customerType: this._list[index]['customerType'] ?? 0);
    return model;
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    _getData(page: 1);
  }

  // more or complete widget
  Widget _getMoreWidget() {
    if (_hasMore) {
      return LoadingMoreWidget();
    } else {
      return LoadingCompleteWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '3000+询价单',
          elevation: 2,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CRMIcons.filter,
                size: ScreenFit.width(42),
              ),
              onPressed: () async {
                var result = await CRMNavigator.goInquiryFilterPage();
                if (result != null) {
                  setState(() {
                    this.provinceId = result['provinceId']?.toString() ?? '';
                    this.cityId = result['cityId']?.toString() ?? '';
                    this.countyId = result['countyId']?.toString() ?? '';
                    this.orgName = result['orgName'];
                    this.startTime = result['startTime'];
                    this.endTime = result['endTime'];
                    this.inquiryNo =
                        result['inquiryId'] != null && result['inquiryId'] != ''
                            ? 'R' + result['inquiryId']
                            : '';
                    this._hasMore = true;
                    this._loading = false;
                    this._getData(page: 1);
                  });
                }
              },
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: Size(double.infinity, 45),
          //   child: _buildTabWiget(),
          // ),
        ),
        body: PullRefreshWidget(_list, (context, index) {
          return _list.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp10),
                  child: Column(
                    children: <Widget>[
                      InquryItemWidget(this.getInquiryDTOModel(index)),
                      if (index == this._list.length - 1) _getMoreWidget()
                    ],
                  ),
                )
              : NoDataWidget();
          //19
        }, _getData, _onRefresh));
  }

  // tab item
  // Widget _buildTabItemWidget(String title, int key) {
  //   return Expanded(
  //     flex: 1,
  //     child: GestureDetector(
  //       onTap: () {
  //         this.setState(() => {
  //               this.activeTab = key,
  //               this._hasMore = true,
  //               // 清除过滤条件
  //               this.clearFilter(),
  //               this._getData(page: 1),
  //             });
  //       },
  //       child: Container(
  //         alignment: Alignment.center,
  //         child: Text(title,
  //             style: TextStyle(
  //                 color: activeTab == key
  //                     ? CRMColors.primary
  //                     : CRMColors.textNormal)),
  //         decoration: BoxDecoration(
  //             border: Border(
  //                 bottom: BorderSide(
  //                     color: activeTab == key
  //                         ? CRMColors.primary
  //                         : CRMColors.borderLight,
  //                     width: activeTab == key ? 2 : 1))),
  //       ),
  //     ),
  //   );
  // }

  // tab
  // Widget _buildTabWiget() {
  //   return Container(
  //     height: 40,
  //     child: Flex(
  //       direction: Axis.horizontal,
  //       children: <Widget>[
  //         _buildTabItemWidget('全部', 0),
  //         _buildTabItemWidget('异常', 1),
  //         _buildTabItemWidget('待报价', 2),
  //         _buildTabItemWidget('已报价', 3),
  //       ],
  //     ),
  //   );
  // }
}
