import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final bool colorful;
  final double height;
  final String title;
  NoDataWidget({this.colorful = true, this.height = 200, this.title = '暂无数据哦'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (colorful)
            SizedBox(
              height: ScreenFit.height(height),
            ),
          colorful
              ? Image.asset(
                  Utils.getImgPath('no_data_full'),
                  width: ScreenFit.width(300),
                )
              : Image.asset(
                  Utils.getImgPath('no_data'),
                  width: ScreenFit.width(224),
                ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: CRMGaps.gap_dp10, minWidth: 0.0 //最小高度为50像素
                ),
          ),
          Text(
            title,
            style: TextStyle(
                color: CRMColors.textLighter, fontSize: CRMText.normalTextSize),
          )
        ],
      ),
    );
  }
}
