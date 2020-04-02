import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/blue_title_card_widget.dart';
import 'package:crm_flutter_app/widgets/hero_photo_view_wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WorkOrderDetailsPage extends StatefulWidget {
  final String orderNo;
  WorkOrderDetailsPage(this.orderNo, {Key key}) : super(key: key);

  _WorkOrderDetailsPageState createState() => _WorkOrderDetailsPageState();
}

class _WorkOrderDetailsPageState extends State<WorkOrderDetailsPage> {
  Map<String, dynamic> _details = {};
  List _remarkList = [];
  Map<int, String> _statusMap = const {2: '待受理', 3: '受理中', 4: '已解决', 5: '已关闭'};
  Map<int, Color> _colorMap = const {
    2: CRMColors.warning,
    3: CRMColors.primary,
    4: CRMColors.success,
    5: CRMColors.danger
  };
  @override
  void initState() {
    super.initState();
    _getData();
    _getRemark();
  }

  Future _getData() async {
    ResultDataModel res = await httpGet(Apis.workOrderDetails,
        queryParameters: {"orderNo": widget.orderNo}, showLoading: true);
    if (res.code == 0) {
      setState(() {
        _details = res.data['order'];
      });
    }
  }

  Future<void> _getRemark() async {
    ResultDataModel res = await httpGet(Apis.workOrderRemark,
        queryParameters: {"orderNo": widget.orderNo}, showLoading: true);
    if (res.code == 0) {
      setState(() {
        _remarkList = res.data['archives'];
      });
    }
  }

  ///工单item
  Widget _buildOrderItem(
      {String title,
      String trailing,
      Color trailingColor,
      bool divider = true}) {
    return Column(
      children: <Widget>[
        Container(
          height: 48,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                      color: CRMColors.textNormal, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                trailing ?? '',
                style: TextStyle(color: trailingColor ?? CRMColors.textLight),
              ),
              SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
        if (divider) CRMBorder.dividerDp1
      ],
    );
  }

  Widget _buildPicturesGrid() {
    // 图片列表
    List<Widget> pictures = [];
    if (_details['files'] is List) {
      for (var item in _details['files']) {
        pictures.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroPhotoViewWrapper(
                    imageProvider: NetworkImage(item['attachURL']),
                  ),
                ));
          },
          child: Hero(
            tag: item['id'] ?? '',
            child: CachedNetworkImage(
                width: ScreenFit.width(120),
                height: ScreenFit.width(120),
                fit: BoxFit.cover,
                imageUrl: item['attachURL'],
                placeholder: (context, url) => SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                errorWidget: (context, url, error) {
                  return Image.asset('assets/images/image_error.png',
                      width: ScreenFit.width(120),
                      height: ScreenFit.width(120));
                }),
          ),
        ));
      }
    }
    return Wrap(
      spacing: ScreenFit.width(20), // gap between adjacent chips
      runSpacing: 4.0, //
      children: pictures,
    );
  }

  Widget _buildRemark() {
    List<Widget> remark = [];
    for (var item in _remarkList) {
      remark.add(blueTitleCard(
          '${item["workgroupName"] ?? ''}/${item["operator"] ?? ''}',
          border: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: CRMGaps.gap_dp10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('添加备注：'),
                HtmlWidget(
                  item['operateContent'] ?? '',
                ),
              ],
            ),
          )));
    }
    return Container(
      margin: EdgeInsets.only(top: CRMGaps.gap_dp10, bottom: CRMGaps.gap_dp10),
      child: Column(
        children: remark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '工单详情',
        actions: <Widget>[
          if (_details['status'] == 2 || _details['status'] == 3)
            IconButton(
                onPressed: () async {
                  var res = await CRMNavigator.goWorkOrderAddPage(
                      orderNo: _details["subject"] ?? '',
                      details: _details,
                      workOrderNo: _details['orderNo']);
                  if (res != null) {
                    _getData();
                  }
                },
                icon: Icon(CRMIcons.edit))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
            child: Column(
              children: <Widget>[
                _buildOrderItem(
                    title: '工单号：${_details["orderNo"] ?? ""}',
                    trailing: _statusMap[_details['status']],
                    trailingColor: _colorMap[_details['status']]),
                _buildOrderItem(
                  title: '主题',
                  trailing: _details["subject"] ?? '',
                ),
                _buildOrderItem(
                    title: '受理客服',
                    trailing:
                        '${_details["workgroupName"] ?? ''}/${_details["agentName"] ?? ''}'),
                Padding(
                    padding: EdgeInsets.only(
                        top: CRMGaps.gap_dp10,
                        bottom: CRMGaps.gap_dp10,
                        right: CRMGaps.gap_dp16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: '内容      ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CRMColors.textNormal),
                                    children: [
                                      TextSpan(
                                          text: _details['description'] ?? '',
                                          style: TextStyle(
                                              color: CRMColors.textLight,
                                              fontWeight: FontWeight.normal,
                                              height: 1.5))
                                    ]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: CRMGaps.gap_dp10,
                        ),
                        _buildPicturesGrid()
                      ],
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: CRMGaps.gap_dp10),
            color: Colors.white,
            padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
            child: Column(
              children: <Widget>[
                _buildOrderItem(
                  title: '创建时间',
                  trailing: _details["createTime"] ?? '',
                ),
                _buildOrderItem(
                    title: '最后更新',
                    trailing: _details["updateTime"] ?? '',
                    divider: false),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: CRMGaps.gap_dp16),
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                _buildOrderItem(
                  title: '处理意见（${_remarkList.length}）',
                ),
                Padding(
                  padding: EdgeInsets.only(right: CRMGaps.gap_dp16),
                  child: _buildRemark(),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
