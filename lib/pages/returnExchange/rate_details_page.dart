import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RateDetailsPage extends StatefulWidget {
  final int subTeamId;
  final int type;
  final String typeDesc;
  final String date;
  RateDetailsPage(
      {@required this.subTeamId,
      @required this.type,
      @required this.typeDesc,
      this.date});
  @override
  _RateDetailsPageState createState() => _RateDetailsPageState();
}

class _RateDetailsPageState extends State<RateDetailsPage> {
  List _list = [];
  bool _loading = false;
  String _date = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    this._getData();
  }

  Future<void> _getData() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });

    ResultDataModel resultDataModel =
        await httpGet(Apis.orgStaticsList, queryParameters: {
      "subTeamId": widget.subTeamId,
      "type": widget.type,
      "date": _date,
    });
    setState(() {
      _loading = false;
    });
    if (resultDataModel.success) {
      var res = resultDataModel.model;
      if (this.mounted) {
        setState(() {
          this._list = res;
        });
      }
    } else {
      Utils.showToast(resultDataModel.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '${widget.typeDesc ?? ""}明细',
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
            onRefresh: _getData,
            color: Colors.white,
            backgroundColor: CRMColors.primary,
            child: ListView.builder(
              itemCount: _list.isNotEmpty ? _list.length : 1,
              itemBuilder: (BuildContext context, int index) {
                return _list.isNotEmpty
                    ? DarkTitleWidget(
                        title: _list[index]['org_name'] ?? '',
                        titleStyle: CRMText.normalText,
                        subtitle: '${_list[index]['statistics'] ?? ""}',
                        subtitleColor: CRMColors.primary,
                        subtitleFontSize: 14)
                    : NoDataWidget();
              },
            ),
          ))
        ],
      ),
    );
  }
}
