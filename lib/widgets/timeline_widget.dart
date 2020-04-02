import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:flutter/material.dart';

class LeftLineWidget extends StatelessWidget {
  final bool showTop;
  final bool showBottom;
  final bool isLight;

  const LeftLineWidget(this.showTop, this.showBottom, this.isLight);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: 16,
      child: CustomPaint(
        painter: LeftLinePainter(showTop, showBottom, isLight),
      ),
    );
  }
}

class LeftLinePainter extends CustomPainter {
  static const double _topHeight = 16;
  static const Color _lightColor = CRMColors.primary;
  static const Color _normalColor = CRMColors.borderDark;

  final bool showTop;
  final bool showBottom;
  final bool isLight;

  const LeftLinePainter(this.showTop, this.showBottom, this.isLight);

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 2; // 线的宽度
    double centerX = size.width / 4; // 半径

    Paint linePain = Paint();
    linePain.color = showTop ? CRMColors.borderDark : Colors.transparent;
    linePain.strokeWidth = lineWidth;
    linePain.strokeCap = StrokeCap.square;

    // 上面的线
    canvas.drawLine(
        Offset(centerX, 0), Offset(centerX, _topHeight - centerX), linePain);

    Paint circlePaint = Paint();
    circlePaint.color = isLight ? _lightColor : _normalColor;
    circlePaint.strokeWidth = lineWidth;
    circlePaint.style = PaintingStyle.stroke;
    linePain.color = showBottom ? CRMColors.borderDark : Colors.transparent;

    // 下面的线
    canvas.drawLine(Offset(centerX, _topHeight + centerX),
        Offset(centerX, size.height), linePain);

    // 圆
    canvas.drawCircle(Offset(centerX, _topHeight), centerX, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget buildTimelineItem(String title, String content, bool showTop,
    bool showBottom, bool isActive) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // 圆和线
            height: 32,
            child: LeftLineWidget(showTop, showBottom, isActive),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      isActive ? CRMColors.textNormal : CRMColors.borderDark),
              overflow: TextOverflow.ellipsis,
            ),
          ))
        ],
      ),
      Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(width: 2, color: CRMColors.borderDark))),
        margin: EdgeInsets.only(left: 19),
        padding: EdgeInsets.fromLTRB(22, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(content,
                style: TextStyle(color: CRMColors.borderDark, fontSize: 14)),
          ],
        ),
      )
    ],
  );
}
