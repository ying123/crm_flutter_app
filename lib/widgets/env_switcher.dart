import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/env.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:flutter/material.dart';

class EnvSwitcher extends StatefulWidget {
  @override
  _EnvSwitcherState createState() => _EnvSwitcherState();
}

class _EnvSwitcherState extends State<EnvSwitcher> {
  static var openDialogNum = 7;
  static var selectedIndex =
      envs.indexWhere((env) => env.name == currentEnv.name);

  int num = 0;
  void setNumToZero() {
    num = 0;
  }

  Future openDialog() async {
    var _selectedIndex = await showDialog<int>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('请选择环境'),
            children: _options,
          );
        });
    setNumToZero();
    // 没选返回`null`
    if (_selectedIndex != null) {
      currentEnv = envs[_selectedIndex];
      Http.setApiAddr(currentEnv);
      selectedIndex = _selectedIndex;
    }
  }

  List<Widget> get _options {
    List<Widget> listTiles = [];
    for (var i = 0; i < envs.length; i++) {
      var selected = i == selectedIndex;
      listTiles.add(ListTile(
        trailing: selected ? const Icon(CRMIcons.checked) : null,
        title: Text(envs[i].name),
        onTap: () => rootNavigatorState.pop(i),
        selected: selected,
      ));
    }
    return listTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: 80.0,
      child: GestureDetector(
        onTap: () {
          num++;
          if (num == openDialogNum) {
            openDialog();
          }
        },
      ),
    );
  }
}
