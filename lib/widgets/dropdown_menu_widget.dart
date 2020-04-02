import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/dropdownMenu/dropdown_menu.dart';
import 'package:flutter/material.dart';

const List<Map<String, dynamic>> ORDERS = [
  {"title": "综合排序"},
  {"title": "失效时间正序"},
  {"title": "均价正序"},
];

const int ORDER_INDEX = 0;

const List<Map<String, dynamic>> TYPES = [
  {"title": "普通订单", "id": 0},
  {"title": "保险订单", "id": 1},
];

const int TYPE_INDEX = 0;

class DropdownMenuWidget extends StatelessWidget {
  final Widget scrollWidget;
  DropdownMenuWidget(this.scrollWidget);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultDropdownMenuController(
            onSelected: (
                {int menuIndex, int index, int subIndex, dynamic data}) {
              print(
                  "menuIndex:$menuIndex index:$index subIndex:$subIndex data:$data");
            },
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: buildDropdownHeader(),
                ),
                Expanded(
                    child: Stack(
                  children: <Widget>[scrollWidget, buildDropdownMenu()],
                ))
              ],
            )));
  }

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return DropdownHeader(
      unselectedColor: CRMColors.textLight,
      textSize: CRMText.largeTextSize,
      onTap: onTap,
      titles: [TYPES[TYPE_INDEX], ORDERS[ORDER_INDEX]],
      otherAction: Center(
        child: InkWell(
          child: Text(
            '筛选',
            style: TextStyle(
                fontSize: CRMText.largeTextSize, color: CRMColors.textLight),
          ),
        ),
      ),
    );
  }
}

DropdownMenu buildDropdownMenu() {
  return DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10,
      //  activeIndex: activeIndex,
      menus: [
        DropdownMenuBuilder(
            builder: (BuildContext context) {
              return DropdownListMenu(
                selectedIndex: TYPE_INDEX,
                data: TYPES,
                itemBuilder: buildCheckItem,
              );
            },
            height: kDropdownMenuItemHeight * TYPES.length),
        DropdownMenuBuilder(
            builder: (BuildContext context) {
              return DropdownListMenu(
                selectedIndex: ORDER_INDEX,
                data: ORDERS,
                itemBuilder: buildCheckItem,
              );
            },
            height: kDropdownMenuItemHeight * ORDERS.length),
      ]);
}
