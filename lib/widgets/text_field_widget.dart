import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final IconData prefixIcon;
  final String labelText;
  final String hintText;
  final bool isVerify;
  final bool autofocus;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String buttonText;
  final bool obscureText;
  final GestureTapCallback onGetVerifyCodeCallback;
  final ValueChanged<String> onChanged;
  final double contentPadding;

  TextFieldWidget(
      {Key key,
      this.prefixIcon,
      this.labelText,
      this.hintText,
      this.isVerify = false,
      this.autofocus = false,
      this.focusNode,
      @required this.controller,
      this.buttonText,
      this.obscureText = false,
      this.onGetVerifyCodeCallback,
      this.onChanged,
      this.contentPadding})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool hasSuffixIcon = false;

  void hasSuffixIconHandler() {
    // 判断是否该显示清空icon
    if (widget.controller.text.isNotEmpty) {
      setState(() {
        this.hasSuffixIcon = true;
      });
    } else {
      setState(() {
        this.hasSuffixIcon = false;
      });
    }
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      widget.controller.addListener(hasSuffixIconHandler);
    }
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    widget.controller.removeListener(hasSuffixIconHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 13,
              ),
              Expanded(
                child: TextField(
                  focusNode: widget.focusNode,
                  autofocus: widget.autofocus,
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  keyboardAppearance: Brightness.light,
                  style: TextStyle(
                      color: CRMColors.textNormal,
                      fontSize: CRMText.normalTextSize),
                  decoration: InputDecoration(
                    border: InputBorder.none, // 隐藏Textfield的边框线
                    contentPadding: EdgeInsets.symmetric(
                        vertical: widget.contentPadding ?? 16),
                    labelText: widget.labelText,
                    labelStyle: TextStyle(color: CRMColors.textLighter),
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                        color: CRMColors.textLighter,
                        fontSize: CRMText.normalTextSize),
                    suffixIcon: this.hasSuffixIcon
                        ? IconButton(
                            iconSize: ScreenFit.width(40),
                            icon: Icon(
                              CRMIcons.delete,
                              color: CRMColors.textLighter,
                            ),
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 200),
                                  () async {
                                widget.controller.clear();
                                widget.onChanged?.call(widget.controller.text);
                              });
                            })
                        : null,
                  ),
                ),
              ),
              Offstage(
                offstage: !widget.isVerify,
                child: Row(
                  children: <Widget>[
                    Text(
                      '|',
                      style: TextStyle(
                          color: Color(0xffe5e5e5),
                          fontSize: CRMText.hugeTextSize),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ScreenFit.width(32)),
                      child: InkWell(
                        onTap: widget.onGetVerifyCodeCallback,
                        child: Text(
                          widget.buttonText ?? '获取验证码',
                          style: TextStyle(
                              color: CRMColors.textNormal,
                              fontSize: CRMText.largeTextSize),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(
            height: 1,
            color: CRMColors.borderLight,
          )
        ],
      ),
    );
  }
}
