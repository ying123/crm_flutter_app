import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message_box_widget.dart';

class TextFieldTimeWidget extends StatefulWidget {
  final String title;
  final startTimeChange;
  final endTimeChange;
  TextFieldTimeWidget(
      {this.title,
      @required this.startTimeChange,
      @required this.endTimeChange});

  @override
  _TextFieldTimeWidgetState createState() => _TextFieldTimeWidgetState();
}

class _TextFieldTimeWidgetState extends State<TextFieldTimeWidget> {
  String startDateStr;
  String endDateStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(CRMGaps.gap_dp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title ?? '',
            style: TextStyle(
                color: CRMColors.textNormal,
                fontSize: CRMText.normalTextSize,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: CRMGaps.gap_dp16,
          ),
          Row(
            children: <Widget>[
              _buildTimeFieldsItem(context, onTap: () async {
                DateTime start = await MessageBox.datePicker(context);
                if (start != null) {
                  setState(() {
                    startDateStr = DateFormat('yyyy-MM-dd').format(start);
                  });
                  widget.startTimeChange('$startDateStr 00:00:00'); //传给父组件
                }
              }, placeholder: startDateStr ?? '请选择开始时间'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp12),
                width: 8,
                height: 1,
                color: CRMColors.textLight,
              ),
              _buildTimeFieldsItem(context, onTap: () async {
                DateTime end = await MessageBox.datePicker(context);

                if (end != null) {
                  setState(() {
                    endDateStr = DateFormat('yyyy-MM-dd').format(end);
                  });
                  widget.endTimeChange('$endDateStr 23:59:59'); //传给父组件
                }
              }, placeholder: endDateStr ?? '请选择结束时间'),
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildTimeFieldsItem(BuildContext context,
    {@required GestureTapCallback onTap, String placeholder}) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2 - 35,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: CRMColors.commonBg,
              borderRadius: BorderRadius.circular(CRMRadius.radius4)),
          child: Text(
            placeholder ?? '',
            style: CRMText.smallText,
          ),
        ),
        Positioned(
          top: 12,
          right: 20,
          child: Icon(
            CRMIcons.down_arrow,
            size: 6,
            color: CRMColors.textLight,
          ),
        )
      ],
    ),
  );
}
