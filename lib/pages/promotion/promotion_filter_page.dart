import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_arrow_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_small_widget.dart';
import 'package:flutter/material.dart';

class PromotionFilterPage extends StatefulWidget {
  PromotionFilterPage({Key key}) : super(key: key);

  _PromotionFilterPageState createState() => _PromotionFilterPageState();
}

class _PromotionFilterPageState extends State<PromotionFilterPage> {
  TextEditingController _controllerOrgName = TextEditingController();
  int status;
  List _statusList = ['审核中', '推广成功', '推广失败'];

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controllerOrgName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '筛选',
      ),
      body: Container(
        color: CRMColors.commonBg,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 5,
            ),
            DarkTitleWidget(
                title: '汽修厂',
                trailing: smallTextFieldWidget(_controllerOrgName,
                    hintText: '请输入汽修厂名称', width: ScreenFit.width(240))),
            textFieldArrowWidget(
                title: '账号状态',
                hintText: '请选择状态',
                value: status != null ? _statusList[status] : null,
                onTap: () {
                  MessageBox.showActionsheet(context,
                      list: _statusList, initialItem: status, onChange: (val) {
                    setState(() {
                      status = val;
                    });
                  });
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomButtonWidget(
        text: '确定',
        onPressed: () {
          Utils.trackEvent('promo_code_screening');
          Map<String, dynamic> params = {
            "orgName": _controllerOrgName.text,
            "status": status ?? '',
          };
          rootNavigatorState.pop(params);
        },
      ),
    );
  }
}
