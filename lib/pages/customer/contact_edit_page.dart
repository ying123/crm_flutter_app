import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/constant_util.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/form_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatefulWidget {
  final int orgId;
  final int id;
  final Map<String, dynamic> info;
  ContactEditPage({this.orgId, this.id, this.info});

  @override
  _ContactEditPageState createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  String selectJobType;
  int selectJobTypeId;
  String selectAge;
  int selectAgeId;
  String selectAttitude;
  int selectAttitudeId;
  var infoObj;
  String id;
  List images;
  TextEditingController _controller = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 验证
  _validateFormItem() {
    RegExp mobileReg =
        RegExp(r"^0{0,1}(13[0-9]|15[7-9]|153|156|18[7-9])[0-9]{8}$");
    RegExp telReg = RegExp(r"^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,8}$");
    RegExp emailReg = RegExp(
        r"^[A-Za-z0-9]+([_\.][A-Za-z0-9]+)*@([A-Za-z0-9\-]+\.)+[A-Za-z]{2,6}$");
    bool hasError = false;
    bool hasEmailError = false;
    if (_phoneController.text != '') {
      hasError = !(mobileReg.hasMatch(_phoneController.text) ||
          telReg.hasMatch(_phoneController.text));
    }
    if (_emailController.text != '') {
      hasEmailError = !emailReg.hasMatch(_emailController.text);
    }
    return _nameController.text != '' &&
        this.selectAttitudeId != null &&
        this.selectJobTypeId != null &&
        this.selectAgeId != null &&
        !hasError &&
        !hasEmailError;
  }

  // 保存
  _saveCreateContact() async {
    if (_validateFormItem()) {
      ResultDataModel res = await httpRequest('PUT', Apis.EditContract, data: {
        'id': id,
        'custId': widget.id,
        'ageScope': selectAgeId,
        'cactName': _nameController.text,
        'cactTel': _phoneController.text,
        'custId': widget.id,
        'email': _emailController.text,
        'internetAttitude': selectAttitudeId,
        'jobType': selectJobTypeId,
        'remark': _controller.text
      });

      if (res.code == 0) {
        Utils.showToast('编辑成功');
        rootNavigatorState.pop();
      }
    } else {
      Utils.showToast('请填写完整的正确的信息');
    }
  }

  @override
  void initState() {
    super.initState();
    infoObj = widget.info;
    id = infoObj['id'];
    _nameController.text = infoObj['cactName'];
    _phoneController.text = infoObj['cactTel'];
    _emailController.text = infoObj['email'];
    _controller.text = infoObj['remark'];
    this.selectAgeId = infoObj['ageScope'];
    this.selectAttitudeId = infoObj['internetAttitude'];
    this.selectJobTypeId = infoObj['jobType'];
    this.selectAge = ConstantUtil.age[infoObj['ageScope']]['value'];
    this.selectJobType = ConstantUtil.jobType[infoObj['jobType']]['value'];
    this.selectAttitude =
        ConstantUtil.internetAttitude[infoObj['internetAttitude']]['value'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '编辑联系人',
        actions: <Widget>[
          GestureDetector(
            onTap: _saveCreateContact,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 13, left: 10, right: 10, bottom: 10),
              child: Text(
                '保存',
                style: TextStyle(color: CRMColors.textNormal),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: CRMColors.borderLight, width: ScreenFit.onepx()))),
        child: ListView(
          children: <Widget>[
            formWidget('姓名',
                value: '请输入',
                isRequired: true,
                type: 'input',
                controller: _nameController),
            formWidget('岗位',
                value: selectJobType ?? '请输入联系人岗位',
                type: 'popMenu',
                isRequired: true, callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.jobType
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.selectJobTypeId = ConstantUtil.jobType[index]['key'];
                  this.selectJobType = ConstantUtil.jobType[index]['value'];
                });
              });
            }),
            formWidget('联系电话',
                value: '请输入联系人电话', type: 'input', controller: _phoneController),
            formWidget('邮箱',
                value: '请输入联系人邮箱', type: 'input', controller: _emailController),
            formWidget('年龄段', value: selectAge ?? '请选择', type: 'popMenu',
                callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.age.map((item) => item['value']).toList(),
                  onChange: (index) {
                setState(() {
                  this.selectAgeId = ConstantUtil.age[index]['key'];
                  this.selectAge = ConstantUtil.age[index]['value'];
                });
              });
            }, isRequired: true),
            formWidget('对互联网的态度',
                value: selectAttitude ?? '请选择', type: 'popMenu', callback: () {
              MessageBox.showActionsheet(context,
                  list: ConstantUtil.internetAttitude
                      .map((item) => item['value'])
                      .toList(), onChange: (index) {
                setState(() {
                  this.selectAttitudeId =
                      ConstantUtil.internetAttitude[index]['key'];
                  this.selectAttitude =
                      ConstantUtil.internetAttitude[index]['value'];
                });
              });
            }, isRequired: true),
            formWidget('备注', hasBorder: false),
            Container(
              padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp10),
              child: TextField(
                keyboardAppearance: Brightness.light,
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: CRMColors.borderLight),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    hintText: '请填写内容',
                    hintStyle: TextStyle(
                        color: CRMColors.textLighter,
                        fontSize: CRMText.smallTextSize),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
