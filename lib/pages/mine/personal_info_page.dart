import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  PersonalInfoPage({Key key}) : super(key: key);

  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  ///个人信息item
  Widget _buildBaseInfoItem({String leading, String title, tapCallback}) {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            height: 52,
            child: InkWell(
              onTap: tapCallback,
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    width: ScreenFit.width(180),
                    child: Text(
                      leading,
                      style: TextStyle(
                          color: CRMColors.textLight,
                          fontSize: CRMText.normalTextSize),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      style: CRMText.normalText,
                    ),
                  ),
                ],
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
          title: '个人信息',
        ),
        body: Column(
          children: <Widget>[
            _buildBaseInfoItem(
              leading: '姓名',
              title: '林生',
            ),
            _buildBaseInfoItem(
              leading: '职位',
              title: '业务员',
            ),
            _buildBaseInfoItem(
              leading: '联系方式',
              title: '13631354071',
            ),
            _buildBaseInfoItem(
              leading: '邮箱',
              title: 'eee@qq.com',
            ),
          ],
        ));
  }
}
