import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/config/env.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/bottom_button_widget.dart';
import 'package:crm_flutter_app/widgets/link_cell_widget.dart';
import 'package:crm_flutter_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class EnvSelectPage extends StatefulWidget {
  @override
  _EnvSelectPageState createState() => _EnvSelectPageState();
}

class _EnvSelectPageState extends State<EnvSelectPage> {
  static var selectedIndex =
      envs.indexWhere((env) => env.name == currentEnv.name);
  final TextEditingController _controllerEnv = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _controllerEnv.text = Http.proxy;
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
    // setNumToZero();
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
        onTap: () {
          rootNavigatorState.pop(i);
          setState(() {});
        },
        selected: selected,
      ));
    }
    return listTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: '环境选择',
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              linkCellWidget(
                title: envs[selectedIndex].name ?? '选择环境',
                tapCallback: openDialog,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(CRMGaps.gap_dp10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('抓包代理IP（选填）：'),
                    TextFieldWidget(
                      controller: _controllerEnv,
                      hintText: '如：192.168.16.245:8888',
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomButtonWidget(
        text: '确定',
        onPressed: () {
          // Http.setProxy(_controllerEnv.text);
          rootNavigatorKey.currentState.pop();
        },
      ),
    );
  }
}
