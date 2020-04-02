import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/constant_util.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class InvoiceListFilterPage extends StatefulWidget {
  @override
  _InvoiceListFilterPageState createState() => _InvoiceListFilterPageState();
}

class _InvoiceListFilterPageState extends State<InvoiceListFilterPage> {
  String invoiceType; // 发票类型
  int invoiceTypeId; // 发票类型Id

  String invoiceOrderType; // 是否冲红
  int invoiceOrderTypeId; // 是否冲红Id

  String invoiceStatus; // 发票状态
  int invoiceStatusId; // 发票状态Id

  String isInvoice; // 是否开发票
  int isInvoiceId; // 是否开发票Id

  String year; // 发票所在的年份
  String month; // 发票所在的月份

  String codeNo; // 单据号
  String invoiceApplyNo; // 申请号
  String invoiceNo; // 发票号码

  TextEditingController invoiceApplyNoController =
      TextEditingController(); // 申请号
  TextEditingController codeNoController = TextEditingController(); // 单据号
  TextEditingController invoiceNoController = TextEditingController(); // 发票号码

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    invoiceApplyNoController.dispose();
    codeNoController.dispose();
    invoiceNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '筛选',
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: CRMColors.borderLight, width: ScreenFit.onepx()))),
        child: Column(
          children: <Widget>[
            formWidget('申请年月',
                value:
                    (year != null && month != null) ? '$year年$month月' : '请选择',
                type: 'popMenu', callback: () async {
              DateTime time = await showMonthPicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 1, 5),
                  lastDate: DateTime(DateTime.now().year + 1, 9),
                  initialDate: DateTime.now());
              if (time != null) {
                setState(() {
                  this.year = time.year.toString();
                  this.month = time.month.toString();
                  print('筛选的年份和月份,$year, $month');
                });
              }
            }),
            formWidget('申请号',
                value: '请输入申请号',
                type: 'input',
                controller: invoiceApplyNoController),
            formWidget('单据号',
                value: '请输入单据号', type: 'input', controller: codeNoController),
            formWidget('发票号码',
                value: '请输入发票号码',
                type: 'input',
                controller: invoiceNoController),
            formWidget('发票种类', value: invoiceType ?? '请选择', type: 'popMenu',
                callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.invoiceType
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.invoiceTypeId = ConstantUtil.invoiceType[index]['key'];
                  this.invoiceType = ConstantUtil.invoiceType[index]['value'];
                });
              });
            }),
            formWidget('是否冲红',
                value: invoiceOrderType ?? '请选择',
                type: 'popMenu', callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.invoiceOrderType
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.invoiceOrderTypeId =
                      ConstantUtil.invoiceOrderType[index]['key'];
                  this.invoiceOrderType =
                      ConstantUtil.invoiceOrderType[index]['value'];
                });
              });
            }),
            formWidget('状态', value: invoiceStatus ?? '请选择', type: 'popMenu',
                callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.invoiceStatus
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.invoiceStatusId =
                      ConstantUtil.invoiceStatus[index]['key'];
                  this.invoiceStatus =
                      ConstantUtil.invoiceStatus[index]['value'];
                });
              });
            }),
            formWidget('是否开发票', value: isInvoice ?? '请选择', type: 'popMenu',
                callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.isInvoice
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.isInvoiceId = ConstantUtil.isInvoice[index]['key'];
                  this.isInvoice = ConstantUtil.isInvoice[index]['value'];
                });
              });
            }),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        Map<String, dynamic> params = {
                          "year": this.year,
                          "month": this.month,
                          "invoiceApplyNo": this.invoiceApplyNoController.text,
                          "codeNo": this.codeNoController.text,
                          "invoiceNo": this.invoiceNoController.text,
                          "invoiceType": this.invoiceTypeId,
                          "invoiceOrderType": this.invoiceOrderTypeId,
                          "status": this.invoiceStatusId,
                          "isInvoice": this.isInvoiceId
                        };
                        print('需要过滤的数据是,$params');
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
