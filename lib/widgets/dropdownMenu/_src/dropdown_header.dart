import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import './dropdown_common.dart';

typedef void DropdownMenuHeadTapCallback(int index);

typedef String GetItemLabel(dynamic data);

String defaultGetItemLabel(dynamic data) {
  if (data is String) return data;
  return data["title"];
}

class DropdownHeader extends DropdownWidget {
  final List<dynamic> titles;
  final Widget otherAction;
  final Color unselectedColor;
  final double textSize;
  final int activeIndex;
  final DropdownMenuHeadTapCallback onTap;

  /// height of menu
  final double height;

  /// get label callback
  final GetItemLabel getItemLabel;

  DropdownHeader(
      {@required this.titles,
      this.otherAction,
      this.unselectedColor,
      this.textSize,
      this.activeIndex,
      DropdownMenuController controller,
      this.onTap,
      Key key,
      this.height: 46.0,
      GetItemLabel getItemLabel})
      : getItemLabel = getItemLabel ?? defaultGetItemLabel,
        assert(titles != null && titles.length > 0),
        super(key: key, controller: controller);

  @override
  DropdownState<DropdownWidget> createState() {
    return new _DropdownHeaderState();
  }
}

class _DropdownHeaderState extends DropdownState<DropdownHeader> {
  Widget buildItem(
      BuildContext context, dynamic title, bool selected, int index) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final GetItemLabel getItemLabel = widget.getItemLabel;

    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Padding(
        padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Center(
            child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Text(
            getItemLabel(title),
            style: new TextStyle(
              color: selected ? primaryColor : widget.unselectedColor,
              fontSize: widget.textSize,
            ),
          ),
          new Icon(
            selected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: selected ? primaryColor : widget.unselectedColor,
          )
        ])),
      ),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(index);

          return;
        }
        if (controller != null) {
          if (_activeIndex == index) {
            controller.hide();
            setState(() {
              _activeIndex = null;
            });
          } else {
            controller.show(index);
          }
        }
        //widget.onTap(index);
      },
    );
  }

  int _activeIndex;
  List<dynamic> _titles;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    final int activeIndex = _activeIndex;
    final List<dynamic> titles = _titles;
    final double height = widget.height;

    for (int i = 0, c = widget.titles.length; i < c; ++i) {
      list.add(buildItem(context, titles[i], i == activeIndex, i));
    }

    list = list.map((Widget widget) {
      return new Expanded(
        child: widget,
      );
    }).toList();

    final Decoration decoration = new BoxDecoration(
      border: new Border(
        bottom: Divider.createBorderSide(context),
      ),
    );

    return new DecoratedBox(
      decoration: decoration,
      child: new SizedBox(
          child: new Row(
            children: [
              ...list,
              widget.otherAction != null
                  ? Expanded(
                      child: widget.otherAction,
                    )
                  : Container()
            ],
          ),
          height: height),
    );
  }

  @override
  void initState() {
    _titles = widget.titles;
    super.initState();
  }

  @override
  void onEvent(DropdownEvent event) {
    switch (event) {
      case DropdownEvent.SELECT:
        {
          if (_activeIndex == null) return;

          setState(() {
            _activeIndex = null;
            String label = widget.getItemLabel(controller.data);
            _titles[controller.menuIndex] = label;
          });
        }
        break;
      case DropdownEvent.HIDE:
        {
          if (_activeIndex == null) return;
          setState(() {
            _activeIndex = null;
          });
        }
        break;
      case DropdownEvent.ACTIVE:
        {
          if (_activeIndex == controller.menuIndex) return;
          setState(() {
            _activeIndex = controller.menuIndex;
          });
        }
        break;
    }
  }
}
