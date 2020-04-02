import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/widgets/appbar_widget.dart';
import 'package:crm_flutter_app/widgets/circle_search_widget.dart';
import 'package:crm_flutter_app/widgets/link_cell_widget.dart';
import 'package:crm_flutter_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class FactorySearchPage extends StatefulWidget {
  FactorySearchPage({Key key}) : super(key: key);

  _FactorySearchPageState createState() => _FactorySearchPageState();
}

class _FactorySearchPageState extends State<FactorySearchPage> {
  TextEditingController _searchEditController = new TextEditingController();
  List _list = new List();

  String _keyword = '';
  bool _loading = true;

  // 搜索处理函数
  _handleSearch(text) {
    this.setState(() {
      this._keyword = text;
      this._list.length = 0;
      this._loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    this._loadData();
  }

  _loadData() async {
    ResultDataModel res = await httpGet(Apis.FactoryList,
        queryParameters: {"mfctyName": this._keyword, "status": 2});

    if (mounted) {
      setState(() {
        this._loading = false;
      });
    }

    if (res.code == 0) {
      if (mounted) {
        if (res.data != null) {
          setState(() {
            this._list = res.data;
          });
        } else {
          setState(() {
            this._list.length = 0;
          });
        }
      }
    }
  }

  Widget _buildListWidget(context) {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        return linkCellWidget(
            title: '${_list[index]['mfctyName']}',
            showRightArrow: false,
            tapCallback: () {
              Map<String, dynamic> params = {
                'id': _list[index]['mfctyId'],
                'name': _list[index]['mfctyName']
              };
              rootNavigatorState.pop(params);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppbarWidget(
          title: '汽修厂名称',
        ),
        body: Column(
          children: <Widget>[
            SearchCardWidget(
              hintText: '请输入汽修厂名称',
              textEditingController: _searchEditController,
              onSubmitted: (text) {
                this._handleSearch(text);
              },
            ),
            Expanded(
              child: this._list.length > 0 || _loading
                  ? _buildListWidget(context)
                  : NoDataWidget(),
            )
          ],
        ));
  }
}
