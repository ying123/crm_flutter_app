import 'package:crm_flutter_app/model/address/address_model.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/address_picker_widget.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_arrow_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_small_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_time_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InquiryFilterPage extends StatefulWidget {
  InquiryFilterPage({Key key}) : super(key: key);

  _InquiryFilterPageState createState() => _InquiryFilterPageState();
}

class _InquiryFilterPageState extends State<InquiryFilterPage> {
  TextEditingController _controllerOrgName = TextEditingController();
  TextEditingController _controllerInquiryId = TextEditingController();
  String address;
  String startDateStr = '';
  String endDateStr = '';
  int provinceId;
  int cityId;
  int countyId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controllerOrgName.dispose();
    _controllerInquiryId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '筛选',
      ),
      body: Column(
        children: <Widget>[
          textFieldArrowWidget(
              title: '所属地区',
              hintText: '请选择地区',
              value: address,
              onTap: () async {
                // var res = await CRMNavigator.goAddressPage<AddressModel>();
                AddressModel res = await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AddressPicker();
                    });
                setState(() {
                  if (res != null) {
                    address =
                        '${res.provinceName} ${res.cityName} ${res.areaName}';
                    setState(() {
                      provinceId = res.provinceId;
                      cityId = res.cityId;
                      countyId = res.areaId;
                    });
                  }
                });
              }),
          DarkTitleWidget(
              title: '询价单号',
              trailing: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('R'),
                  SizedBox(
                    width: 4,
                  ),
                  smallTextFieldWidget(_controllerInquiryId,
                      hintText: '请输入询价单号', width: ScreenFit.width(180))
                ],
              )),
          DarkTitleWidget(
              title: '客户名称',
              trailing: smallTextFieldWidget(_controllerOrgName,
                  hintText: '请输入客户名称')),
          TextFieldTimeWidget(
            title: '询价时间',
            startTimeChange: (val) => startDateStr = val,
            endTimeChange: (val) => endDateStr = val,
          ),
        ],
      ),
      bottomNavigationBar: BottomButtonWidget(
        text: '确定',
        onPressed: () {
          RegExp reg = RegExp(r"^[0-9]+$");
          bool isReg = true;
          if (_controllerInquiryId.text != '') {
            isReg = reg.hasMatch(_controllerInquiryId.text);
          }
          if (isReg) {
            Utils.trackEvent('inquiry_screening');
            Map<String, dynamic> params = {
              "provinceId": provinceId,
              "cityId": cityId,
              "countyId": countyId,
              "orgName": _controllerOrgName.text,
              "inquiryId": _controllerInquiryId.text,
              "startTime": startDateStr,
              "endTime": endDateStr,
            };
            rootNavigatorState.pop(params);
          } else {
            MessageBox.alert(context, '询价单号只能是数字!');
          }
        },
      ),
    );
  }
}
