import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/address/address_model.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key key}) : super(key: key);

  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List _provinceData = [];
  List _cityData = [];
  List _areaData = [];

  int _curProvinceId;
  int _curCityId;
  int _curAreaId;

  String _curProvinceName = '';
  String _curCityName = '';
  String _curAreaName = '';

  int _curPage = 0; // 当前页是省份列表页
  @override
  void initState() {
    super.initState();
    _getProvinceData();
  }

  Future _getProvinceData() async {
    ResultDataModel res = await httpGet(Apis.ProvinceData);
    if (res.code == 0 && mounted) {
      setState(() {
        _provinceData = res.data;
      });
    }
  }

  Future _getCityData() async {
    ResultDataModel res = await httpGet(Apis.CityData + '/$_curProvinceId');
    if (res.code == 0 && mounted) {
      setState(() {
        _cityData = res.data;
      });
    } else {
      Utils.showToast(res.msg);
    }
  }

  Future _getCountryData() async {
    ResultDataModel res = await httpGet(Apis.CountryData + '/$_curCityId');
    if (res.code == 0 && mounted) {
      setState(() {
        _areaData = res.data;
      });
    } else {
      Utils.showToast(res.msg);
    }
  }

  Widget provinceView() {
    return ListView.separated(
      itemCount: _provinceData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            setState(() {
              _curProvinceId = _provinceData[index]['provinceID'];
              _curProvinceName = _provinceData[index]['provinceName'];
            });
            await _getCityData();
            setState(() {
              _curPage = 1; //显示城市列表
            });
          },
          child: ListTile(
            leading: Text(_provinceData[index]['provinceName']),
            trailing: _curProvinceId == _provinceData[index]['provinceID']
                ? Icon(
                    Icons.check,
                    color: CRMColors.primary,
                  )
                : null,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          CRMBorder.dividerDp1,
    );
  }

  Widget cityView() {
    return ListView.separated(
      itemCount: _cityData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            setState(() {
              _curCityId = _cityData[index]['cityID'];
              _curCityName = _cityData[index]['cityName'];
            });
            await _getCountryData();
            setState(() {
              _curPage = 2; //显示区域列表
            });
          },
          child: ListTile(
            leading: Text(_cityData[index]['cityName']),
            trailing: _curCityId == _cityData[index]['cityID']
                ? Icon(
                    Icons.check,
                    color: CRMColors.primary,
                  )
                : null,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          CRMBorder.dividerDp1,
    );
  }

  Widget areaView() {
    return ListView.separated(
      itemCount: _areaData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            setState(() {
              _curAreaId = _areaData[index]['countyID'];
              _curAreaName = _areaData[index]['countyName'];
            });
            rootNavigatorState.pop(AddressModel(
                provinceId: _curProvinceId,
                provinceName: _curProvinceName,
                cityId: _curCityId,
                cityName: _curCityName,
                areaId: _curAreaId,
                areaName: _curAreaName));
          },
          child: ListTile(
            leading: Text(_areaData[index]['countyName']),
            trailing: _curAreaId == _areaData[index]['countyID']
                ? Icon(
                    Icons.check,
                    color: CRMColors.primary,
                  )
                : null,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          CRMBorder.dividerDp1,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget curView;
    String title;
    if (_curPage == 1) {
      curView = cityView();
      title = '请选择城市';
    } else if (_curPage == 2) {
      curView = areaView();
      title = '请选择区县';
    } else {
      curView = provinceView();
      title = '请选择省份';
    }
    return Container(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            if (_curPage == 0) {
              rootNavigatorState.pop();
            }
            if (_curPage == 1) {
              setState(() {
                _curPage = 0;
              });
            }
            if (_curPage == 2) {
              setState(() {
                _curPage = 1;
              });
            }
          },
          icon: Icon(
            CupertinoIcons.left_chevron,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: curView,
    ));
  }
}
