import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/image_text_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:flutter/material.dart';

class CustomerDetailPage extends StatefulWidget {
  final String id;
  CustomerDetailPage(this.id);

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  var customerInfo = {};
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      this._isloading = true;
    });
    ResultDataModel res =
        await httpGet(Apis.CustomerDetail + '/${widget.id}', showLoading: true);

    setState(() {
      this._isloading = false;
    });

    if (res.code == 0) {
      if (mounted) {
        if (res.data != null) {
          customerInfo = res.data;
        }
      }
    }
  }

  Widget _buildMainContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        formWidget('企业名称',
            value: customerInfo['mfctyName']?.toString() ?? '未知'),
        formWidget('客户类型',
            value: customerInfo['customerType'] == 1
                ? '普通客户'
                : customerInfo['customerType'] == 2
                    ? '集团客户'
                    : customerInfo['customerType'] == 3 ? '保险客户' : '未知'),
        formWidget('法人名称', value: customerInfo['legalName']?.toString() ?? ''),
        formWidget(
          '门头照片',
          type: 'text',
          hasRightWiget: true,
          imgUrl: customerInfo['facadePic']?.toString(),
          rightWiget: customerInfo['facadePic']?.toString() == '' ||
                  customerInfo['facadePic'] == null
              ? Container()
              : imageTextWidget(
                  src: customerInfo['facadePic']?.toString(),
                  width: 50,
                  height: 50,
                  hasGap: false,
                  hasText: false,
                  text: '',
                  tag: '1',
                  context: context),
        ),
        formWidget('营业执照号',
            value: customerInfo['busiLicenceNo']?.toString() ?? ''),
        formWidget(
          '营业执照图',
          type: 'text',
          imgUrl: customerInfo['busiLicenceUrl']?.toString(),
          hasRightWiget: true,
          rightWiget: customerInfo['busiLicenceUrl']?.toString() == '' ||
                  customerInfo['busiLicenceUrl'] == null
              ? Container()
              : imageTextWidget(
                  src: customerInfo['busiLicenceUrl']?.toString(),
                  width: 50,
                  height: 50,
                  hasGap: false,
                  hasText: false,
                  text: '',
                  tag: '2',
                  context: context),
        ),
        formWidget('所在地',
            value:
                '${customerInfo['provinceName']?.toString() ?? ''}${customerInfo['cityName']?.toString() ?? ''}${customerInfo['countyName']?.toString() ?? ''}${customerInfo['townName']?.toString() ?? ''}'),
        formWidget('详细地址', value: customerInfo['address']?.toString() ?? ''),
        formWidget('业务电话', value: customerInfo['cactTel']?.toString() ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(title: '客户详情'),
      body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: CRMColors.borderLight, width: 1))),
          child: _isloading ? LoadingMoreWidget() : _buildMainContent(context)),
    );
  }
}
