import 'package:crm_flutter_app/model/address/address_model.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/address_picker_widget.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_arrow_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_small_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_time_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderFilterPage extends StatefulWidget {
  OrderFilterPage({Key key}) : super(key: key);

  _OrderFilterPageState createState() => _OrderFilterPageState();
}

class _OrderFilterPageState extends State<OrderFilterPage> {
  TextEditingController _controllerEditOrderNo = TextEditingController();
  TextEditingController _controllerCustomerName = TextEditingController();
  String startDateStr;
  String endDateStr;
  String address;
  String provinceId;
  String cityId;
  String countryId;

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controllerEditOrderNo.dispose();
    _controllerCustomerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                      provinceId = res.provinceId.toString();
                      cityId = res.cityId.toString();
                      countryId = res.areaId.toString();
                    });
                  }
                });
              }),
          DarkTitleWidget(
              title: '订单号',
              trailing: smallTextFieldWidget(_controllerEditOrderNo,
                  hintText: '请输入订单号')),
          DarkTitleWidget(
              title: '客户名称',
              trailing: smallTextFieldWidget(_controllerCustomerName,
                  hintText: '请输入客户名称')),
          TextFieldTimeWidget(
            title: '支付时间',
            startTimeChange: (val) => startDateStr = val,
            endTimeChange: (val) => endDateStr = val,
          ),
        ],
      ),
      bottomNavigationBar: BottomButtonWidget(
        text: '确认',
        onPressed: () {
          Utils.trackEvent('order_screening');
          Map<String, dynamic> params = {
            'provinceId': provinceId ?? '',
            'cityId': cityId ?? '',
            'countyId': countryId ?? '',
            'orderNo': _controllerEditOrderNo.text,
            'custName': _controllerCustomerName.text,
            'payStartTime': startDateStr ?? '',
            'payEndTime': endDateStr ?? '',
          };
          rootNavigatorState.pop(params);
        },
      ),
    );
  }
}
