import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:update_app/update_app.dart';

///检查更新
class CheckUpdateUtil {
  static String duwnloadMsg = '';
  static String file = '';
  static CancelFunc cancelFunc;

  ///检查版本号
  static Future checkUpdates(BuildContext context,
      {bool silence = false}) async {
    Utils.trackEvent('about_crm');
    String apiUrl;
    if (Platform.isIOS) {
      apiUrl = 'https://itunes.apple.com/lookup?id=1440966930';
      try {
        var cancelFunc = MessageBox.loading(); //显示loading
        Response response = await Dio().get(apiUrl);
        var res = json.decode(response.data)["results"];
        String serviceVersionCode = res[0]["version"];
        cancelFunc(); //关闭loading

        PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
          var currentVersionCode = packageInfo.version; //获取当前的版本号
          if (UpdateApp.compareVersion(
                  currentVersionCode, serviceVersionCode) ==
              -1) {
            var downloadUrl = "https://apps.apple.com/cn/app/id1440966930";
            var confirm = await MessageBox.confirm(
                context, res[0]['releaseNotes'],
                confirmButtonText: '马上更新', cancelButtonText: '暂不更新');
            if (confirm) {
              UpdateApp.updateApp(serviceVersionCode, downloadUrl);
            }
          } else if (!silence) {
            Utils.showToast('当前版本已是最新版本!');
          }
        });
      } catch (e) {
        Utils.showToast(e.toString());
      }
    } else {
      final random = new Random();
      String randomNumber = random.nextInt(100000).toString();
      apiUrl = 'https://pic.qipeipu.com/uploadpic/crm/update2.json?v=' +
          randomNumber;
      cancelFunc = MessageBox.loading(); //显示loading
      Response response = await Dio().get(apiUrl);
      var res = response.data;
      String serviceVersionCode = res["version"];
      cancelFunc();
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
        var currentVersionCode = packageInfo.version; //获取当前的版本号
        if (UpdateApp.compareVersion(currentVersionCode, serviceVersionCode) ==
            -1) {
          var downloadUrl = res['downloadUrl'] ??
              'http://pic.qipeipu.com/uploadpic/crm/crmapp2.apk';
          var md5 = "";
          var confirm = await MessageBox.confirm(context, res['releaseNotes'],
              confirmButtonText: '马上更新', cancelButtonText: '暂不更新');
          if (confirm) {
            var progress = 0;
            MessageBox.showContentDialog(context,
                content: _StatefulBuilder(initFn: (_setState) {
                  UpdateApp.updateApp(serviceVersionCode, downloadUrl, md5: md5,
                      listener: (Map result) {
                    _setState(() {
                      progress = result['progress'];
                    });
                  });
                }, builder: (context, _setState) {
                  return Text('正在后台下载中...已下载$progress%');
                }));
          }
        } else if (!silence) {
          Utils.showToast('当前版本已是最新版本!');
        }
      });
    }
  }

  static void onDownLoadResult(Map result) {
    //下载的进度回调监听
    //{message: 下载完成, status: 3, progress: 100, file: "xxxxx"}

    if (result["status"] == UpdateApp.DOWN_FINISH) {
      file = result["file"];
    }
  }

  Future installApk(String file) async {
    if (file != null && file.length > 0) {
      UpdateApp.installApk(file);
    }
  }
}

class _StatefulBuilder extends StatefulWidget {
  const _StatefulBuilder({
    Key key,
    @required this.initFn,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  final Function(StateSetter setState) initFn;
  final StatefulWidgetBuilder builder;

  @override
  _StatefulBuilderState createState() => _StatefulBuilderState();
}

class _StatefulBuilderState extends State<_StatefulBuilder> {
  @override
  void initState() {
    super.initState();
    widget.initFn(setState);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}
