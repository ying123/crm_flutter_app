import 'dart:io';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/hero_photo_view_wrapper_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_border_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkOrderAddPage extends StatefulWidget {
  final String orderNo;
  final int workOrderNo;
  final Map<String, dynamic> details;
  WorkOrderAddPage({this.orderNo, this.workOrderNo, this.details, Key key})
      : super(key: key);

  _WorkOrderAddPageState createState() => _WorkOrderAddPageState();
}

class _WorkOrderAddPageState extends State<WorkOrderAddPage> {
  List<Asset> images = List<Asset>();
  List _fileInfo = List<Map<String, String>>();
  List _workGoupList = [];
  String _workgroupName = '';
  String _displayName = '';
  int _selectIndex;

  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contentInputController = TextEditingController();

  bool get _isUpdatePage => widget.workOrderNo != null; // 判断是否为编辑页面

  @override
  void initState() {
    super.initState();
    setState(() {
      _subjectController.text = widget.orderNo;
    });
    _getWorkGroupList();
  }

  void _showActionSheet() {
    _workGoupList.forEach((item) {
      if (item['workgroupName'] == _workgroupName) {
        setState(() {
          _selectIndex = _workGoupList.indexOf(item);
        });
      }
    });
    MessageBox.showActionsheet(context,
        list: _workGoupList,
        label: 'displayName',
        initialItem: _selectIndex, onChange: (index) {
      setState(() {
        _selectIndex = index;
        _workgroupName = _workGoupList[index]['workgroupName'];
        _displayName = _workGoupList[index]['displayName'];
      });
    });
  }

  Future<void> _getWorkGroupList() async {
    ResultDataModel res = await httpGet(Apis.workGoupList, showLoading: true);
    if (res.code == 0) {
      setState(() {
        _workGoupList = res.data['workgroups'];
      });
      if (_isUpdatePage) {
        _fillForm(_workGoupList);
      }
    }
  }

  void _fillForm(List workgroupList) {
    //回填表单
    setState(() {
      _contentInputController.text = widget.details['description'];
      _subjectController.text = widget.details['subject'];
      _workgroupName = widget.details['acceptWkgroupJID'];

      widget.details['files'].forEach((item) {
        Map<String, String> fileMap = {
          "fileName": item['attachName'],
          "fileUrl": item['attachURL']
        };
        print(item['attachURL']);
        _fileInfo.add(fileMap);
      });
      workgroupList.forEach((item) {
        if (item['workgroupName'] == _workgroupName) {
          _displayName = item['displayName'];
          _selectIndex = workgroupList.indexOf(item);
        }
      });
    });
  }

  ///新建工单
  Future _submit() async {
    if (_subjectController.text.trim() == '') {
      Utils.showToast('请输入主题');
      return;
    }
    if (_workgroupName == '') {
      Utils.showToast('请输入受理客服组');
      return;
    }
    if (_contentInputController.text.trim() == '') {
      Utils.showToast('请输入内容');
      return;
    }
    if (_contentInputController.text.length > 200) {
      Utils.showToast('内容不能超过200字');
      return;
    }
    ResultDataModel res = await httpPost(Apis.workOrderAdd,
        data: {
          "json": {
            "extendFieldMap": {
              "AGNET": '',
              "CONTENT": _contentInputController.text,
              "PRIORITY": 1,
              "SUBJECT": _subjectController.text,
              "WORKGROUP": _workgroupName,
            },
            "operator": '',
            "file": _fileInfo,
          }
        },
        showLoading: true);
    if (res.code == 0) {
      bool result;
      result = await MessageBox.confirm(context, '提交成功，点击确定查看工单详情');
      if (result) {
        if (res.data != null && res.data['receipt'] != null) {
          CRMNavigator.goWorkOrderDetailsPage(
              '${res.data['receipt']['orderNo'] ?? ""}');
        } else {
          Utils.showToast('工单异常！');
        }
      }
    } else {
      Utils.showToast(res.msg ?? '操作失败');
    }
    Utils.trackEvent('work_order_add');
  }

  ///修改工单
  Future _update() async {
    if (_subjectController.text.trim() == '') {
      Utils.showToast('请输入主题');
      return;
    }
    if (_workgroupName == '') {
      Utils.showToast('请输入受理客服组');
      return;
    }
    if (_contentInputController.text.trim() == '') {
      Utils.showToast('请输入内容');
      return;
    }
    if (_contentInputController.text.length > 200) {
      Utils.showToast('内容不能超过200字');
      return;
    }
    ResultDataModel res = await httpPut(Apis.workOrderAdd,
        data: {
          "orderNo": widget.workOrderNo,
          "json": {
            "extendFieldMap": {
              "AGNET": '',
              "CONTENT": _contentInputController.text,
              "PRIORITY": 1,
              "SUBJECT": _subjectController.text,
              "WORKGROUP": _workgroupName,
            },
            "operator": '',
            "file": _fileInfo,
          }
        },
        showLoading: true);
    if (res.code == 0) {
      bool result;
      result = await MessageBox.confirm(context, '修改成功，点击确定查看工单详情');
      if (result) {
        rootNavigatorKey.currentState.pop(true);
      }
    } else {
      Utils.showToast(res.msg ?? '操作失败');
    }
  }

  Future<void> _upload() async {
    List<Asset> resultList = List<Asset>();
    setState(() {
      images = [];
    });
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 4 - _fileInfo.length,
          enableCamera: false,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#3D7EFF",
            actionBarTitle: "汽配铺CRM",
            allViewTitle: "全部图片",
            selectCircleStrokeColor: "#000000",
            selectionLimitReachedText: "最多只能上传4张",
          ));
    } catch (e) {
      print(e);
    }

    if (!mounted || resultList.isEmpty) return;

    setState(() {
      images = resultList;
    });
    final filePath = images.map((item) {
      return item.filePath;
    }).toList();
    final pathList = await Future.wait(filePath);
    Map<String, UploadFileInfo> file = {};
    for (var i = 0; i < pathList.length; i++) {
      file['file$i'] = UploadFileInfo(File(pathList[i]), pathList[i]);
    }
    FormData formData = new FormData.from(file);
    ResultDataModel res =
        await httpPost(Apis.upload, data: formData, showLoading: true);
    if (res.code == 0) {
      List data = res.data;

      setState(() {
        data.forEach((item) {
          Map<String, String> fileMap = {
            "fileName": item['fileName'],
            "fileUrl": item['remoteURL']
          };
          _fileInfo.add(fileMap);
        });
      });
      Utils.showToast('上传成功');
    } else {
      Utils.showToast(res.msg);
    }
  }

  // 图片模块
  Widget buildGridView() {
    return Wrap(
      spacing: 6, // 主轴(水平)方向间距
      runSpacing: 8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start,
      children: <Widget>[
        ..._fileInfo
            .asMap()
            .map((index, item) {
              {
                return MapEntry(
                    index,
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 12, top: 12),
                          child: ClipRRect(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(CRMRadius.radius4)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HeroPhotoViewWrapper(
                                          imageProvider:
                                              NetworkImage(item['fileUrl']),
                                        ),
                                      ));
                                },
                                child: Hero(
                                  tag: item['fileUrl'] ?? '',
                                  child: CachedNetworkImage(
                                      width: ScreenFit.width(120),
                                      height: ScreenFit.width(120),
                                      fit: BoxFit.cover,
                                      imageUrl: item['fileUrl'],
                                      placeholder: (context, url) => SizedBox(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                            'assets/images/image_error.png',
                                            width: ScreenFit.width(120),
                                            height: ScreenFit.width(120));
                                      }),
                                ),
                              )),
                        ),
                        Positioned(
                            right: -12,
                            top: -12,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(_fileInfo.length);
                                    print(images.length);
                                    _fileInfo.removeAt(index);
                                  });
                                },
                                icon: Image.asset(
                                  'assets/images/clear.png',
                                  width: ScreenFit.width(34),
                                )))
                      ],
                    ));
              }
            })
            .values
            .toList(),
        if (_fileInfo.length < 4)
          Container(
              padding: EdgeInsets.only(right: 12, top: 12),
              child: InkWell(
                onTap: _upload,
                child: Image.asset(
                  'assets/images/add.png',
                  width: ScreenFit.width(120),
                ),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: _isUpdatePage ? '修改工单' : '新建工单',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenFit.width(26),
              ),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 49,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '*',
                          style: TextStyle(
                              color: CRMColors.danger,
                              fontSize: CRMText.hugeTextSize),
                        ),
                        Text(
                          '主题：',
                          style: CRMText.mainTitleText,
                        ),
                        Expanded(
                            child: TextFieldWidget(
                          autofocus: true,
                          contentPadding: 15,
                          controller: _subjectController,
                        ))
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '*',
                              style: TextStyle(
                                  color: CRMColors.danger,
                                  fontSize: CRMText.hugeTextSize),
                            ),
                            Text(
                              '受理客服组：',
                              style: CRMText.mainTitleText,
                            ),
                          ],
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _showActionSheet,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _displayName,
                                    textAlign: TextAlign.end,
                                    style:
                                        TextStyle(color: CRMColors.textLight),
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 20,
                                  color: CRMColors.textNormal,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(
                  horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '*',
                        style: TextStyle(
                            color: CRMColors.danger,
                            fontSize: CRMText.hugeTextSize),
                      ),
                      Text(
                        '内容：',
                        style: CRMText.mainTitleText,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CRMGaps.gap_dp8),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: CRMColors.borderDark),
                              borderRadius: BorderRadius.circular(5)),
                          child: borderTextFieldWidget(_contentInputController,
                              maxLines: 10, minLines: 5, hintText: '请输入内容'),
                        ),
                      ],
                    ),
                  ),
                  buildGridView(),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenFit.width(20)),
                    child: Text(
                      '限上传四张',
                      style: CRMText.smallText,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomButtonWidget(
        text: _isUpdatePage ? '修改' : '提交',
        onPressed: _isUpdatePage ? _update : _submit,
      ),
    );
  }
}
