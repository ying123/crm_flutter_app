import 'package:crm_flutter_app/config/crm_style.dart';
// import 'package:crm_flutter_app/config/status.dart';
import 'package:crm_flutter_app/routes/crm_navigator.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';

// import 'package:crm_flutter_app/widgets/dark_title_widget.dart';
// import 'package:crm_flutter_app/widgets/ellipsis_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InquiryDTOModel {
  final String inquiryNo; // 询价单编号
  final String inquiryId; // 询价单Id
  final int quoteStatus; // 报价状态 -1: 无法报价 0: 待报价 1：部分报价 2：报价完成
  final int inquiryStatus; // 询价单状态： -3：客服打回 -2：客服失效 -1：删除 0：保存 1：发布 2：过期
  final String lastPublishTime; // 询价单发布时间
  final String orgName; // 汽修厂名称
  final String carTypeInfo; // 车型名称
  final double averagePrice; // 均价
  final int inquiryDetailCount; // 询价单数量
  final int quoteCount; // 已报价数量
  final int customerType; // 客户类型

  InquiryDTOModel({
    this.inquiryNo,
    this.inquiryId,
    this.quoteStatus,
    this.inquiryStatus,
    this.lastPublishTime,
    this.orgName,
    this.carTypeInfo,
    this.inquiryDetailCount,
    this.quoteCount,
    this.averagePrice,
    this.customerType,
  });
}

class InquryItemWidget extends StatelessWidget {
  final InquiryDTOModel inquryDTO;
  InquryItemWidget(this.inquryDTO);

  @override
  Widget build(BuildContext context) {
    String status = inquryDTO.inquiryStatus == -3
        ? '客服打回'
        : inquryDTO.inquiryStatus == -2
            ? '客服失效'
            : inquryDTO.inquiryStatus == -1
                ? '已删除'
                : inquryDTO.inquiryStatus == 2
                    ? '已过期'
                    : inquryDTO.inquiryStatus == 0
                        ? '已保存'
                        : inquryDTO.quoteStatus == 2
                            ? '已报价'
                            : inquryDTO.quoteStatus == 1
                                ? '部分报价'
                                : inquryDTO.quoteStatus == 0 ? '待报价' : '无法报价';
    return InkWell(
      onTap: () {
        Utils.trackEvent('inquiry_details');
        CRMNavigator.goInquryDetailPage(inquryDTO.inquiryId);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(ScreenFit.width(25),
                  ScreenFit.width(14), ScreenFit.width(25), ScreenFit.width(2)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: InkWell(
                    onLongPress: () {
                      Clipboard.setData(
                          ClipboardData(text: '${inquryDTO.inquiryNo}'));
                      Utils.showToast('已复制');
                    },
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/doc_icon.png',
                            width: ScreenFit.width(35),
                            height: ScreenFit.width(35)),
                        SizedBox(width: 5),
                        Text('${inquryDTO.inquiryNo}')
                      ],
                    ),
                  )),
                  Container(
                    padding: EdgeInsets.all(2),
                    color: CRMColors.warningLightApla,
                    child: Text(
                      status,
                      style: TextStyle(color: CRMColors.warning),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: CRMColors.commonBg,
              child: Image.asset(
                'assets/images/divide_line.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(ScreenFit.width(32),
                  ScreenFit.width(5), ScreenFit.width(32), ScreenFit.width(2)),
              child: Row(
                children: <Widget>[
                  if (inquryDTO.customerType == 3)
                    Padding(
                      padding: EdgeInsets.only(right: CRMGaps.gap_dp8),
                      child: Image.asset(
                        'assets/images/insurance.png',
                        width: ScreenFit.width(35),
                      ),
                    ),
                  if (inquryDTO.customerType == 2)
                    Padding(
                      padding: EdgeInsets.only(right: CRMGaps.gap_dp8),
                      child: Image.asset(
                        'assets/images/group.png',
                        width: ScreenFit.width(50),
                      ),
                    ),
                  Expanded(
                    child: InkWell(
                      onLongPress: () {
                        Clipboard.setData(
                            ClipboardData(text: '${inquryDTO.orgName}'));
                        Utils.showToast('已复制');
                      },
                      child: Text(
                        '${inquryDTO.orgName}',
                        overflow: TextOverflow.ellipsis,
                        style: CRMText.mainTitleText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    ScreenFit.width(32),
                    ScreenFit.width(0),
                    ScreenFit.width(32),
                    ScreenFit.width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${inquryDTO.carTypeInfo}',
                      style: TextStyle(color: CRMColors.textLight, height: 2),
                    ),
                    Text(
                      '${inquryDTO.lastPublishTime}',
                      style: TextStyle(color: CRMColors.textLight, height: 2),
                    ),
                    SizedBox(height: 8),
                    CRMBorder.dividerDp1,
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                              text: '询/报配件数:',
                              style: TextStyle(color: CRMColors.textNormal),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${inquryDTO.inquiryDetailCount}/${inquryDTO.quoteCount}',
                                    style: TextStyle(
                                        color: CRMColors.primary,
                                        fontWeight: FontWeight.bold))
                              ]),
                        )),
                        RichText(
                          text: TextSpan(
                              text: '参考均价:',
                              style: TextStyle(color: CRMColors.textNormal),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '¥${inquryDTO.averagePrice?.toString()}',
                                    style: TextStyle(
                                        color: CRMColors.primary,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
