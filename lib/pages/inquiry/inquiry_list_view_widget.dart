import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/local_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class InquiryListViewWidget extends StatefulWidget {
  final StreamController streamController;
  final String inquiryStatus;
  final int tabIndex;
  final int documentaryTabIndex; //跟单页的当前tab，用于防止别的Tab在下拉的时候，触发本页的refresh方法
  final orgId;

  InquiryListViewWidget(
      {this.streamController,
      @required this.inquiryStatus,
      this.tabIndex,
      this.documentaryTabIndex,
      this.orgId,
      Key key})
      : super(key: key);

  _InquiryListViewWidgetState createState() => _InquiryListViewWidgetState();
}

class _InquiryListViewWidgetState extends State<InquiryListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  int _page = 1;
  int _pageSize = 10;
  int _total = 0;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;
  String provinceId = '';
  String cityId = '';
  String countyId = '';
  String orgName = '';
  String inquiryId = '';
  String startTime = '';
  String endTime = '';
  StreamSubscription streamSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.streamController != null) {
      //订阅广播，刷新当前页面
      streamSubscription = widget.streamController.stream.listen((value) async {
        print('询价单页面筛选条件，$value');
        String loacalTabIndex = await LocalStorage.get('inquiryCurTabIndex');
        if (loacalTabIndex == widget.tabIndex.toString() && value != null) {
          setState(() {
            _loading = false;
            _hasMore = true;
            provinceId = '${value['provinceId'] ?? ''}';
            cityId = '${value['cityId'] ?? ''}';
            countyId = '${value['countyId'] ?? ''}';
            orgName = value['orgName'] != null ? value['orgName'] : '';
            inquiryId = value['inquiryId'] != null ? value['inquiryId'] : '';
            startTime = value['startTime'] != null ? value['startTime'] : '';
            endTime = value['endTime'] != null ? value['endTime'] : '';
          });

          _getData(page: 1);
        }
      });
    }

    this._getData();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getData({page}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      _page = page;
      _list = [];
      _hasMore = true;
      _loading = false;
    }
    if (this._hasMore) {
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      var model;
      ResultDataModel resultDataModel =
          await httpGet(Apis.TrackOrderInquiryList,
              queryParameters: {
                "status": widget.inquiryStatus,
                "orgId": widget.orgId ?? '',
                "areaQuery.provinceId": provinceId,
                "areaQuery.cityId": cityId,
                "areaQuery.countyId": countyId,
                "orgName": orgName,
                "inquiryId": inquiryId ?? '',
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
        inquiryId: this._list[index]['inquiryId']?.toString(),
        quoteStatus: this._list[index]['quoteStatus'] ?? 0,
        inquiryStatus: this._list[index]['status'] ?? '0',
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
    //如果跟单页的tab不是询价单，那么不刷新
    if (widget.documentaryTabIndex != null && widget.documentaryTabIndex != 1) {
      return;
    }
    await _getData(page: 1);
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
    super.build(context);
    return PullRefreshWidget(_list, (context, index) {
      return _list.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp10),
              color: CRMColors.commonBg,
              child: Column(
                children: <Widget>[
                  InquryItemWidget(this.getInquiryDTOModel(index)),
                  if (index == this._list.length - 1) _getMoreWidget()
                ],
              ),
            )
          : NoDataWidget();
      //19
    }, _getData, _onRefresh);
  }
}
