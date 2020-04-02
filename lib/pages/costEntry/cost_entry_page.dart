import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_small_widget.dart';
import 'package:flutter/material.dart';

class CostEntryPage extends StatefulWidget {
  final Map costDto;
  CostEntryPage({Key key, this.costDto});

  @override
  _CostEntryPageState createState() => _CostEntryPageState();
}

class _CostEntryPageState extends State<CostEntryPage> {
  TextEditingController _controllerDelivery = TextEditingController();
  TextEditingController _controllerSalesman = TextEditingController();
  TextEditingController _controllerWarehouse = TextEditingController();
  TextEditingController _controllerOil = TextEditingController();
  TextEditingController _controllerDepre = TextEditingController();
  TextEditingController _controllerMonth = TextEditingController();
  TextEditingController _controllerOther = TextEditingController();
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    if (!addMode) {
      // 编辑，回填表单
      _getDefaultData();
    }
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controllerDelivery.dispose();
    _controllerSalesman.dispose();
    _controllerWarehouse.dispose();
    _controllerOil.dispose();
    _controllerDepre.dispose();
    _controllerMonth.dispose();
    _controllerOther.dispose();
    super.dispose();
  }

  bool get addMode => widget.costDto == null;

  void _getDefaultData() {
    //数据回填
    _controllerDelivery.text = '${widget.costDto['1']}';
    _controllerSalesman.text = '${widget.costDto['2']}';
    _controllerWarehouse.text = '${widget.costDto['3']}';
    _controllerOil.text = '${widget.costDto['4']}';
    _controllerDepre.text = '${widget.costDto['5']}';
    _controllerMonth.text = '${widget.costDto['6']}';
    _controllerOther.text = '${widget.costDto['7']}';
  }

  ///表单验证，只允许输入数字
  bool validate() {
    List<String> controllerList = [
      _controllerDelivery.text,
      _controllerSalesman.text,
      _controllerWarehouse.text,
      _controllerOil.text,
      _controllerDepre.text,
      _controllerMonth.text,
      _controllerOther.text
    ];
    List<bool> tagList = [];
    controllerList.forEach((item) {
      if (item != '') {
        try {
          double.parse(item);
        } catch (e) {
          tagList.add(false);
        }
      } else {
        tagList.add(true);
      }
    });
    if (tagList.contains(false)) {
      return false;
    }
    return true;
  }

  Future _save() async {
    if (!validate()) {
      Utils.showToast('请输入数字类型数据！');
      return;
    }
    ResultDataModel res = await httpPost(Apis.saveCost,
        data: {
          "1": _controllerDelivery.text,
          "2": _controllerSalesman.text,
          "3": _controllerWarehouse.text,
          "4": _controllerOil.text,
          "5": _controllerDepre.text,
          "6": _controllerMonth.text,
          "7": _controllerOther.text
        },
        showLoading: true);
    if (res.code == 0) {
      await Utils.showToast('成本录入成功');
      rootNavigatorState.pop();
    } else {
      Utils.showToast(res.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            appBar: AppbarWidget(
              title: '成本明细',
              actions: <Widget>[
                if (!addMode && !editMode)
                  IconButton(
                    icon: Icon(CRMIcons.edit),
                    onPressed: () async {
                      setState(() {
                        // 切换到编辑模式
                        this.editMode = true;
                      });
                    },
                  ),
                if (editMode)
                  GestureDetector(
                    onTap: _save,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 13, left: 10, right: 10, bottom: 10),
                      child: Text('保存',
                          style: TextStyle(color: CRMColors.textNormal)),
                    ),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    DarkTitleWidget(
                        title: '配送员工资：',
                        trailing: smallTextFieldWidget(_controllerDelivery,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode,
                            autofocus: addMode || editMode)),
                    DarkTitleWidget(
                        title: '业务员工资：',
                        trailing: smallTextFieldWidget(_controllerSalesman,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                    DarkTitleWidget(
                        title: '仓库月租金：',
                        trailing: smallTextFieldWidget(_controllerWarehouse,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                    DarkTitleWidget(
                        title: '每月油耗费：',
                        trailing: smallTextFieldWidget(_controllerOil,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                    DarkTitleWidget(
                        title: '车辆折旧费：',
                        trailing: smallTextFieldWidget(_controllerDepre,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                    DarkTitleWidget(
                        title: '月管理费用：',
                        trailing: smallTextFieldWidget(_controllerMonth,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                    DarkTitleWidget(
                        title: '其他费用：',
                        trailing: smallTextFieldWidget(_controllerOther,
                            hintText: '请输入',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            enabled: addMode || editMode)),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Offstage(
              offstage: !addMode,
              child: BottomButtonWidget(
                text: '确定',
                onPressed: _save,
                secondaryText: '取消',
                secondaryOnPressed: () async {},
              ),
            )));
  }
}
