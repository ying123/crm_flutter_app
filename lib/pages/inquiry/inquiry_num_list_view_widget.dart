import 'dart:async';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/inquiry_huge_trans_list_model.dart';
// import 'package:crm_flutter_app/pages/inquiry/inquiry_item_widget.dart';
import 'package:crm_flutter_app/pages/inquiry/inquiry_list_view_widget.dart';
import 'package:crm_flutter_app/providers/provider_base_widget.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/local_util.dart';

import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable

class InquiryNumTransListViewWidget extends StatefulWidget {
  @override
  _InquiryNumTransListViewWidgetState createState() =>
      _InquiryNumTransListViewWidgetState();
}

class _InquiryNumTransListViewWidgetState
    extends State<InquiryNumTransListViewWidget> {
  static StreamController streamController;

  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<InuiqryHugeTransListModel>(
      model: InuiqryHugeTransListModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppbarWidget(
          title: '新询价单',
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CRMIcons.filter,
                size: ScreenFit.width(42),
              ),
              onPressed: () async {
                var result = await CRMNavigator.goInquiryFilterPage();
                LocalStorage.save('inquiryCurTabIndex',
                    'null'); // 保存当前的tabIndex,未转化的tabIndex为5
                streamController.sink.add(result);
                // print('需要过滤的重点数据，$result');
              },
            ),
          ],
        ),
        body: InquiryListViewWidget(
          streamController: streamController,
          inquiryStatus: '',
        ),
      ),
    );
  }
}
