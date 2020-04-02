import 'dart:async';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/pages/returnExchange/rate_item_widget.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RateListViewWidget extends StatefulWidget {
  RateListViewWidget({Key key}) : super(key: key);

  _RateListViewWidgetState createState() => _RateListViewWidgetState();
}

class _RateListViewWidgetState extends State<RateListViewWidget>
    with AutomaticKeepAliveClientMixin {
  Map _teamStatistic = {};
  String _date = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getData() async {
    ResultDataModel resultDataModel =
        await httpGet(Apis.teamStatisticList, queryParameters: {
      "date": _date,
    });
    if (mounted) {
      if (resultDataModel.success) {
        setState(() {
          _teamStatistic = resultDataModel.model;
        });
      } else {
        setState(() {
          _teamStatistic = {};
        });
        Utils.showToast(resultDataModel.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
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
                                firstDate: DateTime(DateTime.now().year - 1, 5),
                                lastDate: DateTime(DateTime.now().year + 1, 9),
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
              if (_teamStatistic['has_sub_team'] != null &&
                  _teamStatistic['has_sub_team'])
                SizedBox(
                  height: 24,
                  child: OutlineButton(
                      onPressed: () {
                        CRMNavigator.goRateSubteamListPage(date: _date);
                      },
                      child: Text(
                        '团队明细',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: CRMColors.primary,
                            fontSize: CRMText.smallTextSize),
                      ),
                      borderSide: BorderSide(color: CRMColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CRMRadius.radius16))),
                )
            ],
          ),
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: _getData,
          color: Colors.white,
          backgroundColor: CRMColors.primary,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return _teamStatistic.isNotEmpty
                  ? RateItemWidget(_teamStatistic, _date)
                  : NoDataWidget();
            },
          ),
        ))
      ],
    );
  }
}
