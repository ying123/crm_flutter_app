import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/button_big_radius_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/loading_complete_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:crm_flutter_app/widgets/pull_refresh_widget.dart';
import 'package:flutter/material.dart';

class CouponRecords extends StatefulWidget {
  final int id;
  final String name;
  CouponRecords(this.id, this.name, {Key key}) : super(key: key);

  @override
  _CouponRecordsState createState() => _CouponRecordsState();
}

class _CouponRecordsState extends State<CouponRecords> {
  List _list = [];
  int _page = 1;
  int _pageSize = 10;
  bool _hasMore = true; //判断有没有数据
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData({page}) async {
    if (page != null) {
      // 传入page，用于下拉刷新时获取第1页数据
      setState(() {
        _page = page;
        _list = [];
        _hasMore = true;
        _loading = false;
      });
    }
    if (this._hasMore) {
      if (_loading) return;
      setState(() {
        _loading = true;
      });
      var res;
      ResultDataModel resultDataModel = await httpGet(Apis.CouponsRecords,
          queryParameters: {
            "ruleId": widget.id,
            "page": this._page,
            "limit": 10,
          },
          showLoading: true);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (resultDataModel.code == 0) {
        res = resultDataModel.data['list'] ?? [];

        if (this.mounted) {
          setState(() {
            this._list.addAll(res); //拼接
            this._page++;
          });
          //判断是否是最后一页
          if (res.length < this._pageSize && mounted) {
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

  //下拉刷新
  Future<void> _onRefresh() async {
    await _getData(page: 1);
  }

  void _withdraw(couponId) async {
    var confirm = await MessageBox.confirm(context, '请确认是否撤回该优惠券?');
    if (confirm) {
      ResultDataModel res =
          await httpDelete('${Apis.WithdrawCoupons}/$couponId');
      if (res.code == 0) {
        Utils.showToast('撤回成功！');
        _getData(page: 1);
      } else {
        Utils.showToast(res.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(
        title: '派券记录',
      ),
      body: Column(
        children: <Widget>[
          DarkTitleWidget(
            title: widget.name ?? '',
            size: Status.MINI,
            titleStyle: TextStyle(
                color: CRMColors.textNormal, fontWeight: FontWeight.bold),
          ),
          Expanded(
              child:
                  PullRefreshWidget(_list, (BuildContext context, int index) {
            return _list.isNotEmpty
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp16),
                        child: Container(
                          margin:
                              EdgeInsetsDirectional.only(top: CRMGaps.gap_dp10),
                          decoration: BoxDecoration(
                              color: CRMColors.blueLight,
                              borderRadius:
                                  BorderRadius.circular(CRMRadius.radius4)),
                          padding: EdgeInsets.symmetric(
                              vertical: CRMGaps.gap_dp10,
                              horizontal: CRMGaps.gap_dp16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_list[index]['orgName'] ?? ''),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: CRMGaps.gap_dp8),
                                      child: Text(
                                        _list[index]['createTime'] ?? '',
                                        style: TextStyle(
                                            fontSize: CRMText.smallTextSize),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (_list[index]['status'] == 0)
                                ButtonBigRadiusWidget(
                                  color: CRMColors.warning,
                                  title: '撤回',
                                  onPressed: () {
                                    _withdraw(_list[index]['couponId']);
                                  },
                                )
                              else
                                ButtonBigRadiusWidget(
                                  color: CRMColors.borderDark,
                                  title: '撤回',
                                  onPressed: () {},
                                )
                            ],
                          ),
                        ),
                      ),
                      if (index == _list.length - 1)
                        (_hasMore
                            ? LoadingMoreWidget()
                            : LoadingCompleteWidget())
                    ],
                  )
                : NoDataWidget();
          }, _getData, _onRefresh))
        ],
      ),
    );
  }
}
