import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/loading_more_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailPage extends StatefulWidget {
  final int id;
  final int custId;
  ContactDetailPage({this.id, this.custId});

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  bool _isloading = true;
  var contractInfo = {};

  @override
  void initState() {
    super.initState();
    _loadContractInfo();
  }

  // 弹出确认弹窗
  Future<void> _showDialog(context, phone) async {
    var confirm = await MessageBox.confirm(context, phone, title: '确认拨打电话');
    if (confirm) {
      this._makePhoneCall('tel:$phone');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('拨打电话失败');
    }
  }

  // 加载用户列表数据
  _loadContractInfo() async {
    if (mounted) {
      setState(() {
        this._isloading = true;
      });
    }
    ResultDataModel res =
        await httpGet(Apis.ContractDetail + '/${widget.id}', showLoading: true);
    if (mounted) {
      setState(() {
        this._isloading = false;
      });
    }
    if (res.code == 0) {
      if (mounted) {
        setState(() {
          contractInfo = res.data;
        });
      }
    }
  }

  Widget _buildMainContent() {
    return ListView(
      children: <Widget>[
        formWidget('姓名', value: contractInfo['cactName']),
        formWidget('岗位',
            value: contractInfo['jobType'] == 1
                ? '老板'
                : contractInfo['jobType'] == 2
                    ? '厂长'
                    : contractInfo['jobType'] == 3
                        ? '采购员'
                        : contractInfo['jobType'] == 4
                            ? '仓管'
                            : contractInfo['jobType'] == 5
                                ? '维修工'
                                : contractInfo['jobType'] == 6
                                    ? '前台'
                                    : contractInfo['jobType'] == 7
                                        ? '财务'
                                        : '未知'),
        formWidget('联系电话',
            value: contractInfo['cactTel'],
            hasRightWiget: contractInfo['cactTel'] != null &&
                contractInfo['cactTel'] != '',
            rightWiget: Padding(
              padding: EdgeInsets.only(left: 15),
              child: GestureDetector(
                onTap: () {
                  _showDialog(context, contractInfo['cactTel']);
                },
                child: Icon(
                  CRMIcons.phone,
                  size: 20,
                ),
              ),
            )),
        formWidget('邮箱', value: contractInfo['email']),
        formWidget('年龄段',
            value: contractInfo['ageScope'] == 1
                ? '30岁以下'
                : contractInfo['ageScope'] == 2
                    ? '30-40岁'
                    : contractInfo['ageScope'] == 3 ? '40岁以上' : '未知'),
        formWidget('对互联网的态度',
            value: contractInfo['internetAttitude'] == 1
                ? '认可'
                : contractInfo['internetAttitude'] == 2
                    ? '不认可'
                    : contractInfo['internetAttitude'] == 3 ? '说不清' : '未知'),
        formWidget('备注', value: contractInfo['remark'])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '联系人详情',
        actions: <Widget>[
          IconButton(
            icon: Icon(CRMIcons.edit),
            onPressed: () {
              CRMNavigator.goContactEditPage(
                  widget.id, widget.custId, contractInfo);
            },
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: CRMColors.borderLight, width: ScreenFit.onepx()))),
          child: _isloading ? LoadingMoreWidget() : _buildMainContent()),
    );
  }
}
