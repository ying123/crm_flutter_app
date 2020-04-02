import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

typedef GetTeamDetailData = void Function();

class TeamDetailWidget extends StatelessWidget {
  final String date;
  final String type;
  final String bluebtn;
  final GetTeamDetailData getTeamDetailData;

  //副标题颜色
  final int subtitleColor;

  TeamDetailWidget(
      {Key key,
      this.date,
      this.type,
      this.bluebtn,
      this.subtitleColor,
      this.getTeamDetailData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text("时间：" + date + " >"),
                ),
                Offstage(
                  offstage: getTeamDetailData == null,
                  child: OutlineButton(
                    onPressed: () {
                      getTeamDetailData();
                    },
                    child: Text('团队明细',
                        style: TextStyle(color: CRMColors.primary)),
                    highlightedBorderColor: CRMColors.textLight,
                    disabledBorderColor: CRMColors.primary,
                    borderSide: BorderSide(
                        color: CRMColors.primary,
                        width: 2.0,
                        style: BorderStyle.solid),
                  ),
                )
              ],
            ),
          ),
          CRMBorder.dividerDp1,
        ],
      ),
    );
  }
}
