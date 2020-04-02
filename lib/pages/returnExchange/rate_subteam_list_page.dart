import 'dart:async';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/ellipsis_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/returnExchange/rate_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RateSubteamListPage extends StatefulWidget {
  final String date;
  RateSubteamListPage({Key key, this.date}) : super(key: key);

  _RateSubteamListPageState createState() => _RateSubteamListPageState();
}

class _RateSubteamListPageState extends State<RateSubteamListPage>
    with AutomaticKeepAliveClientMixin {
  List _list = [];
  String _date = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    this._getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getData() async {
    ResultDataModel resultDataModel =
        await httpGet(Apis.subteamStatisticList, queryParameters: {
      "date": _date,
    });
    if (mounted) {
      if (resultDataModel.code == 0) {
        setState(() {
          this._list = resultDataModel.model;
        });
      } else {
        Utils.showToast(resultDataModel.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppbarWidget(
        title: '子团队明细',
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp14),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        width: ScreenFit.width(1),
                        color: CRMColors.borderLight))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text('时间：'),
                      InkWell(
                        onTap: () async {
                          showMonthPicker(
                                  context: context,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 9),
                                  initialDate: DateTime.now())
                              .then((date) {
                            setState(() {
                              if (date != null) {
                                _date = DateFormat('yyyy-MM').format(date);
                                this._getData();
                              }
                            });
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _date,
                              style: TextStyle(color: CRMColors.textDark),
                            ),
                            Icon(
                              CRMIcons.right_arrow,
                              size: ScreenFit.width(28),
                              color: CRMColors.textNormal,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CRMColors.primary,
                onRefresh: _getData,
                child: ListView.builder(
                  itemCount: _list.isNotEmpty ? _list.length : 1,
                  itemBuilder: (BuildContext context, int index) {
                    return _list.isNotEmpty
                        ? Column(
                            children: <Widget>[
                              EllipsisTitleWidget(
                                  _list[index]['team_name'] ?? ''),
                              RateItemWidget(_list[index], widget.date)
                            ],
                          )
                        : NoDataWidget();
                  },
                )),
          )
        ],
      ),
    );
  }
}
