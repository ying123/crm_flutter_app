import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';

/// 展开收缩动画组件
import 'package:flutter/material.dart';

class AnimateContainerWidget extends StatefulWidget {
  final Duration duration;
  final double initialHeight;
  final double endHeight;
  final Widget child;
  final String title;
  final String subTitle;
  final bool isCollapse;
  AnimateContainerWidget(
      {Key key,
      @required this.duration,
      this.title,
      this.subTitle,
      this.initialHeight = 48,
      this.endHeight = 0,
      this.isCollapse = true,
      @required this.child})
      : super(key: key);

  @override
  _AnimateContainerWidgetState createState() => _AnimateContainerWidgetState();
}

class _AnimateContainerWidgetState extends State<AnimateContainerWidget>
    with TickerProviderStateMixin {
  bool _isCollapse = true; // 默认收起
  double _toggleHeight;
  GlobalKey _bluePanelKey = GlobalKey();
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween(begin: 0.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_isCollapse) {
        _toggleHeight = widget.endHeight + widget.initialHeight;
      } else {
        _toggleHeight = widget.initialHeight;
      }
      _isCollapse = !_isCollapse;
      _isCollapse ? _controller.reverse() : _controller.forward();
      if (!widget.isCollapse) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCollapse) {
      // 判断是否应该默认展开
      setState(() {
        if (_isCollapse) {
          _toggleHeight = widget.endHeight + widget.initialHeight;
          _controller.forward();
        } else {
          _toggleHeight = widget.initialHeight;
        }
      });
    }

    return AnimatedContainer(
      duration: widget.duration,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: ScreenFit.onepx(), color: CRMColors.borderLight))),
      height: _toggleHeight ?? widget.initialHeight,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          InkWell(
            onTap: _toggle,
            child: Container(
              height: widget.initialHeight,
              padding: EdgeInsets.only(right: CRMGaps.gap_dp16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(widget.title ?? ''),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(widget.subTitle ?? ''),
                      RotationTransition(
                          turns: _animation,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: CRMGaps.gap_dp8,
                                  right: CRMGaps.gap_dp8),
                              child: Icon(
                                CRMIcons.down_arrow,
                                color: CRMColors.textNormal,
                                size: 6,
                              ))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: widget.initialHeight,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.only(right: 32),
                child: Container(
                  key: _bluePanelKey,
                  padding: EdgeInsets.all(CRMGaps.gap_dp10),
                  decoration: BoxDecoration(
                      color: CRMColors.blueLight,
                      borderRadius: BorderRadius.circular(CRMRadius.radius8)),
                  child: widget.child,
                ),
              ))
        ],
      ),
    );
  }
}
