import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class NoticeIcon extends StatelessWidget {
  static const size = 15.0;
  final Widget child;
  final int count;
  String get countDiaplayName {
    return count > 99 ? '99+' : count.toString();
  }

  double get redCircleSize {
    return count > 99 ? 20.0 : size;
  }

  NoticeIcon({@required this.child, this.count = 0});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: redCircleSize,
              height: redCircleSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                color: CRMColors.danger,
              ),
              child: Center(
                child: Text(
                  countDiaplayName,
                  style: TextStyle(fontSize: 9.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
      ],
    );
  }
}
