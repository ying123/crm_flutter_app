import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';

import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/link_cell_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class CustomerInfoPage extends StatefulWidget {
  final String customerId;
  final int orgId; // 当前客户所属组织ID
  CustomerInfoPage(this.customerId, this.orgId);

  @override
  _CustomerInfoPageState createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  var statisticsModel = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 30), () => {_loadStatistics()});
  }

  // 获取客户的统计信息
  _loadStatistics() async {
    if (mounted) {
      setState(() {
        this.statisticsModel = {};
      });
    }
    ResultDataModel res = await httpGet(
        Apis.CustomerInfo + '/${widget.customerId}',
        showLoading: true);

    if (res.code == 0) {
      if (res.data != null) {
        setState(() {
          statisticsModel = res.data;
        });
      }
    }
  }

  //构建单元格
  Widget _buildGridItem(String title, int value,
      {bool noRightBorder = false, GestureTapCallback onTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Container(
          decoration: !noRightBorder
              ? BoxDecoration(
                  border: Border(
                      right:
                          BorderSide(color: CRMColors.borderLight, width: 1)))
              : null,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: CRMColors.primary,
                        fontSize: CRMText.normalTextSize),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: CRMGaps.gap_dp8),
                child: Text(
                  '$value',
                  style: TextStyle(
                      color: CRMColors.primary,
                      fontSize: CRMText.normalTextSize),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppbarWidget(
        title: '客户信息',
      ),
      body: statisticsModel == null
          ? NoDataWidget(height: 0)
          : Column(
              children: <Widget>[
                CRMBorder.dividerDp1,
                linkCellWidget(
                    title: '${statisticsModel['customerName']}',
                    tapCallback: () {
                      CRMNavigator.goCustomerDetailPage(
                          statisticsModel['customerId']);
                    }),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '维护：${statisticsModel['functionaryTeam'] ?? '未知'}',
                        style: CRMText.normalText,
                      ),
                      SizedBox(
                        height: CRMGaps.gap_dp8,
                      ),
                      Text(
                        '${statisticsModel['functionaryStart'] ?? '未知'}',
                        style: CRMText.smallText,
                      ),
                    ],
                  ),
                ),
                CRMBorder.dividerDp1,
                Row(
                  children: <Widget>[
                    _buildGridItem('询价单', statisticsModel['inquiryNum'] ?? 0,
                        onTap: () => CRMNavigator.goInquiryListPage(
                            orgId: widget.orgId)),
                    _buildGridItem('订单', statisticsModel['orderNum'] ?? 0,
                        onTap: () => CRMNavigator.goOrderListPage(1,
                            orgId: widget.orgId)),
                    _buildGridItem('退货', statisticsModel['returnGoodNum'] ?? 0,
                        noRightBorder: true,
                        onTap: () => CRMNavigator.goReturnExchangeListPage(
                            orgId: widget.orgId,
                            curTopTab: 1,
                            curBottomTab: 1,
                            isSelectCustomer: true)),
                  ],
                ),
                CRMBorder.dividerDp1,
                Row(
                  children: <Widget>[
                    _buildGridItem('换货', statisticsModel['exchangeGoodNum'],
                        onTap: () => CRMNavigator.goReturnExchangeListPage(
                            orgId: widget.orgId,
                            curTopTab: 2,
                            curBottomTab: 1,
                            isSelectCustomer: true)),
                    _buildGridItem('联系人', statisticsModel['contactNum'],
                        onTap: () => CRMNavigator.goContactListPage(
                            statisticsModel['customerId'])),
                    _buildGridItem('发票管理', statisticsModel['invoiceNum'],
                        noRightBorder: true,
                        onTap: () => CRMNavigator.goInvoiceListPage(
                            widget.orgId,
                            activeTab: null)),
                  ],
                )
              ],
            ),
    );
  }
}
