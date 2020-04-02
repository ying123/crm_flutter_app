import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/xiaoba/xb_query_model.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/widgets/blue_panel_widget.dart';
import 'package:crm_flutter_app/widgets/button_big_radius_widget.dart';
import 'package:crm_flutter_app/widgets/message_box_widget.dart';
import 'package:crm_flutter_app/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';

class OrderDetailItemWidget extends StatefulWidget {
  final item;
  final Map _baseInfo;
  final _orderDetailTrack;
  OrderDetailItemWidget(this.item, this._baseInfo, this._orderDetailTrack);
  @override
  _OrderDetailItemWidgetState createState() => _OrderDetailItemWidgetState();
}

class _OrderDetailItemWidgetState extends State<OrderDetailItemWidget> {
  String partsInfo = '';
  List partsTaches = new List();

  Widget _buildBoldText(String title, {bool btSpace = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: btSpace ? CRMGaps.gap_dp10 : 0),
      child: Text(
        title ?? '',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 展示物流进度信息
    _showLogisticDialog(orderDetailId) {
      MessageBox.showLogisticsSheet(context, widget._orderDetailTrack);
    }

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: ScreenFit.height(10)),
      color: Colors.white,
      child: BluePanelWidget(
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: titleValueWidget(
                      title: '配件名称：',
                      value: '${widget.item['parts_name']}',
                      titleColor: CRMColors.textLight),
                ),
                Offstage(
                  offstage: false,
                  child: Text('${widget.item['status_name'] ?? ''}',
                      style: TextStyle(color: CRMColors.warning)),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: titleValueWidget(
                      title: '配件编码：',
                      value: '${widget.item['parts_code']}',
                      titleColor: CRMColors.textLight),
                ),
                Offstage(
                  offstage: !(widget.item['subscribe_day'] > 0),
                  child: Text('订货${widget.item['subscribe_day']}天',
                      style: TextStyle(color: CRMColors.success)),
                ),
              ],
            ),
            titleValueWidget(
                title: '品质：',
                value: '${widget.item['brand_name']}',
                titleColor: CRMColors.textLight),
            CRMBorder.dividerDp1Dark,
            SizedBox(
              height: 10,
            ),
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: titleValueWidget(
                      title: '质保期：',
                      value: '${widget.item['warranty']}个月',
                      titleColor: CRMColors.textLight),
                ),
                Expanded(
                  flex: 1,
                  child: titleValueWidget(
                      title: '',
                      value:
                          '${widget.item['not_shipped_on_day_off_supplier'] ?? ''}',
                      titleColor: CRMColors.textLight),
                ),
              ],
            ),
            titleValueWidget(
                title: '发票类型：',
                value: '${widget.item['invoice_type_name']}',
                titleColor: CRMColors.textLight),
            titleValueWidget(
                title: '预估时间：',
                value: '${widget.item['estimated_arrival_time'] ?? ''}',
                titleColor: CRMColors.textLight),
            titleValueWidget(
                title: '备注：',
                value: '${widget.item['remark'] ?? ''}',
                titleColor: CRMColors.textLight),
            CRMBorder.dividerDp1Dark,
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildBoldText('数量：x${widget.item['count']}'),
                      _buildBoldText('单价：￥${widget.item['price']}'),
                      _buildBoldText('总价：￥${widget.item['total_amount']}'),
                    ],
                  ),
                ),
                ButtonBigRadiusWidget(
                  title: '配件进度',
                  width: 140,
                  color: CRMColors.warning,
                  onPressed: () {
                    // MessageBox.showLogisticsSheet(context);
                    _showLogisticDialog(widget.item['order_detail_id']);
                    // _loadPartsProgress(widget.item['order_detail_id']);
                  },
                ),
              ],
            ),
          ],
        ),
        onXiaobaTap: () {
          XiaobaQueryModel xiaoba = XiaobaQueryModel(
              orderDetailId: widget.item['order_detail_id'],
              supplierId: widget.item['supplier_id'],
              orderType: 1,
              targetType: 1,
              distributeTo: widget._baseInfo['abnormal'] == true
                  ? 'service'
                  : 'supplier');
          CRMNavigator.goXiaobaPage(xiaoba);
        },
      ),
    );
  }
}
