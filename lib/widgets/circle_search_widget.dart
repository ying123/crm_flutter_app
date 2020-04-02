import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class SearchCardWidget extends StatefulWidget {
  final FocusNode focusNode;
  TextEditingController textEditingController;
  final VoidCallback onTap;
  final bool isShowLeading;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final bool isShowSuffixIcon;
  final double elevation;
  final Widget rightWidget;

  SearchCardWidget({
    Key key,
    this.focusNode,
    this.textEditingController,
    this.onTap,
    this.isShowLeading = true,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.isShowSuffixIcon = true,
    this.hintText,
    this.elevation = 2.0,
    this.rightWidget,
  }) : super(key: key);

  @override
  _SearchCardWidgetState createState() => _SearchCardWidgetState();
}

class _SearchCardWidgetState extends State<SearchCardWidget> {
  String _hintText;
  Widget _rightWidget;
  // Timer _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _rightWidget = widget.rightWidget;
    _hintText = widget.hintText;
    _hintText = _hintText ?? '请输入客户名称';
    if (widget.textEditingController == null) {
      widget.textEditingController = TextEditingController();
    }

    return searchCard();
  }

  Widget searchCard() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: widget.elevation,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))), //设置圆角
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.isShowLeading
                    ? Padding(
                        padding: EdgeInsets.only(right: 5, top: 0, left: 5),
                        child: Icon(
                          CRMIcons.search,
                          color: Colors.grey,
                          size: 16,
                        ),
                      )
                    : SizedBox(
                        width: 10,
                      ),
                Expanded(
                  child: Container(
                      height: 34,
                      child: TextField(
                        autofocus: widget.autofocus,
                        onTap: widget.onTap,
                        focusNode: widget.focusNode,
                        style: TextStyle(fontSize: 12),
                        controller: widget.textEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 8),
                          border: InputBorder.none,
                          hintText: _hintText,
                          // hintStyle: TextStyle(height: 0.5),
                          suffixIcon: widget
                                      .textEditingController.text.length ==
                                  0
                              //  || !widget.isShowSuffixIcon
                              ? SizedBox()
                              : Container(
                                  width: 20.0,
                                  height: 20.0,
                                  alignment: Alignment.centerRight,
                                  child: new IconButton(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 6),
                                    iconSize: 18.0,
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.grey[500],
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      Future.delayed(Duration(milliseconds: 50),
                                          () {
                                        setState(() {
                                          widget.textEditingController.text =
                                              '';
                                          widget.onSubmitted('');
                                        });
                                      });
                                    },
                                  ),
                                ),
                        ),
                        onSubmitted: (text) {
                          widget.onSubmitted(text);
                        },
                        // onChanged: (text) {
                        //   if (_debounce?.isActive ?? false)
                        //     _debounce.cancel(); // 防抖函数
                        //   _debounce =
                        //       Timer(const Duration(milliseconds: 500), () {
                        //     widget.onChanged(text);
                        //   });
                        // },
                      )),
                ),
                widget.textEditingController.text.length == 0
                    //  ||!widget.isShowSuffixIcon
                    ? Padding(
                        padding: EdgeInsets.only(right: 5), child: _rightWidget)
                    : SizedBox(),
              ],
            ),
          ),
        ),
      );
}
