import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_time_widget.dart';
import 'package:flutter/material.dart';

class InvoiceDetailFilterPage extends StatefulWidget {
  @override
  _InvoiceDetailFilterPageState createState() =>
      _InvoiceDetailFilterPageState();
}

class _InvoiceDetailFilterPageState extends State<InvoiceDetailFilterPage> {
  String startDateStr;
  String endDateStr;
  TextEditingController _orderNoController = TextEditingController();

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _orderNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(title: '筛选'),
      body: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: CRMColors.borderLight, width: ScreenFit.onepx()))),
        child: Column(
          children: <Widget>[
            formWidget('订单号',
                value: '请输入订单号', type: 'input', controller: _orderNoController),
            TextFieldTimeWidget(
              title: '支付时间',
              startTimeChange: (val) =>
                  {print('筛选支付开始时间,$val'), this.startDateStr = val},
              endTimeChange: (val) =>
                  {print('筛选支付结束时间，$val'), this.endDateStr = val},
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        Map<String, dynamic> params = {
                          'orderNo': this._orderNoController.text,
                          'startDateStr': this.startDateStr,
                          'endDateStr': this.endDateStr
                        };
                        rootNavigatorState.pop(params);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        color: CRMColors.primary,
                        child: Text('确认',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
