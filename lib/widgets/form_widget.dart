import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/text_field_small_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 表单编辑组件
Widget formWidget(String title,
    {bool isRequired = false,
    String type = 'text',
    value = '',
    bool hasBorder = true,
    String imgUrl,
    callback,
    bool hasRightWiget = false,
    Widget rightWiget,
    final ValueChanged<int> childcallback,
    TextEditingController controller}) {
  return Column(
    children: <Widget>[
      Container(
        padding: hasRightWiget && imgUrl != null && imgUrl != ''
            ? EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp20, vertical: 5)
            : EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp20, vertical: 8),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Offstage(
                  offstage: !isRequired,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '*',
                        style: TextStyle(
                            color: CRMColors.danger,
                            fontSize: CRMText.hugeTextSize),
                      ),
                      SizedBox(
                        width: 2,
                      )
                    ],
                  ),
                ),
                Text(
                  title,
                  style: CRMText.mainTitleText,
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Offstage(
                    // 纯文本
                    offstage: !(type == 'text'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              value,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: CRMText.normalTextSize,
                                  color: CRMColors.textLighter),
                            ),
                          ),
                          Offstage(
                            offstage: !hasRightWiget,
                            child: rightWiget,
                          )
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    // 输入框
                    offstage: !(type == 'input'),
                    child: Container(
                      width: 150,
                      // height: 50,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.centerRight,
                      child: smallTextFieldWidget(controller,
                          hintText: value, width: 150),
                    ),
                  ),
                  Offstage(
                    // actionSheet 或是 link
                    offstage: !(type == 'popMenu'),
                    child: Container(
                      // height: 50,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      child: InkWell(
                        onTap: callback,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Text(value,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: CRMText.normalTextSize,
                                      color: CRMColors.textLighter)),
                            ),
                            SizedBox(width: 10.0),
                            Icon(CRMIcons.right, size: 15, color: Colors.grey)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !(type == 'radio'),
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text('满减券',
                                    style: TextStyle(
                                        fontSize: CRMText.normalTextSize,
                                        color: CRMColors.textLighter)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  value == '1'
                                      ? CRMIcons.checked
                                      : CRMIcons.unchecked,
                                  color: CRMColors.primary,
                                  size: 20,
                                )
                              ],
                            ),
                            onTap: () => {childcallback(1)},
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '折扣券',
                                  style: TextStyle(
                                      fontSize: CRMText.normalTextSize,
                                      color: CRMColors.textLighter),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  value == '2'
                                      ? CRMIcons.checked
                                      : CRMIcons.unchecked,
                                  color: CRMColors.primary,
                                  size: 20,
                                )
                              ],
                            ),
                            onTap: () => {childcallback(2)},
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // ),
      ),
      Offstage(
        offstage: !(hasBorder == true),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp16),
          child: CRMBorder.dividerDp1,
        ),
      )
    ],
  );
}
