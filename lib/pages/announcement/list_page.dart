import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/providers/notices_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnouncementListPage extends StatefulWidget {
  @override
  _AnnouncementListPageState createState() => _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getData() async {
    ResultDataModel res = await httpGet(Apis.NoticeList, showLoading: false);
    if (res.code == 0) {
      if (mounted) {
        final noticesModel = Provider.of<NoticesModel>(context);
        noticesModel.notices = res.data;
      }
    } else {
      Utils.showToast(res.msg);
    }
  }

  ///构建公告item
  Widget _buildAnnouncementItem(int index, String title, String img, int read,
      String noticeId, NoticesModel noticesModel) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 0, horizontal: ScreenFit.width(26)),
      child: InkWell(
        onTap: () {
          noticesModel.setNoticeRead(index);
          // 1 已读 ，0 未读
          CRMNavigator.goAnnouncementDetailsPage(read, noticeId);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
              color: read == 0 ? CRMColors.blueLight : CRMColors.commonBg,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          margin: EdgeInsets.only(top: 11),
          child: ListTile(
            leading: Opacity(
              opacity: read == 0 ? 1 : 0.4,
              child: CachedNetworkImage(
                width: ScreenFit.width(90),
                height: ScreenFit.height(90),
                imageUrl: img ?? '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/notice.png'),
              ),
            ),
            title: Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: read == 0
                  ? CRMText.normalText
                  : TextStyle(
                      color: CRMColors.textLighter,
                      fontSize: CRMText.normalTextSize),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noticesModel = Provider.of<NoticesModel>(context);
    final notices = noticesModel.notices;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarWidget(
          title: '公告列表',
        ),
        body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: CRMColors.primary,
            onRefresh: _getData,
            child: ListView.builder(
              itemCount: notices.isNotEmpty ? notices.length : 1,
              itemBuilder: (BuildContext context, int index) {
                return notices.isNotEmpty
                    ? _buildAnnouncementItem(
                        index,
                        notices[index]['title'],
                        notices[index]['popPic'],
                        notices[index]['read'],
                        notices[index]['noticeId'],
                        noticesModel)
                    : NoDataWidget();
              },
            )));
  }
}
