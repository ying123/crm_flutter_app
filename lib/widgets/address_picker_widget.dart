import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/model/address/address_model.dart';
import 'package:crm_flutter_app/model/result_data_model.dart';
import 'package:crm_flutter_app/request/api.dart';
import 'package:crm_flutter_app/request/http.dart';
import 'package:crm_flutter_app/utils/globalKey_util.dart';
import 'package:crm_flutter_app/utils/utils.dart';
import 'package:crm_flutter_app/widgets/tabs_widget.dart';
import 'package:flutter/material.dart';

class AddressPicker extends StatefulWidget {
  AddressPicker({Key key}) : super(key: key);

  @override
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabs = [
    '请选择',
    '请选择',
    '请选择',
  ];
  List _provinceData = [];
  List _cityData = [];
  List _areaData = [];

  int _curProvinceId;
  int _curCityId;
  int _curAreaId;

  String _curProvinceName = '';
  String _curCityName = '';
  String _curAreaName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
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

  Widget _provinceView() {
    return ListView.builder(
      itemCount: _provinceData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            setState(() {
              _curProvinceId = _provinceData[index]['provinceID'];
              _curProvinceName = _provinceData[index]['provinceName'];
              _tabs[0] = _curProvinceName;
              _tabs[1] = '请选择';
              _tabs[2] = '请选择';
              _curCityId = null;
              _curCityName = null;
              _curAreaId = null;
              _curAreaName = null;
            });
            _tabController.animateTo(1);
            _getCityData();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CRMGaps.gap_dp16, vertical: CRMGaps.gap_dp10),
            child: Row(
              children: <Widget>[
                if (_curProvinceId == _provinceData[index]['provinceID'])
                  Icon(
                    Icons.check,
                    size: 16,
                    color: CRMColors.primary,
                  ),
                SizedBox(
                  width: CRMGaps.gap_dp4,
                ),
                Text(
                  _provinceData[index]['provinceName'],
                  style: TextStyle(
                      fontSize: CRMText.smallTextSize,
                      fontWeight:
                          _curProvinceId == _provinceData[index]['provinceID']
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          _curProvinceId == _provinceData[index]['provinceID']
                              ? CRMColors.textDark
                              : CRMColors.textNormal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cityView() {
    return ListView.builder(
      itemCount: _cityData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            setState(() {
              _curCityId = _cityData[index]['cityID'];
              _curCityName = _cityData[index]['cityName'];
              _tabs[1] = _curCityName;
              _tabs[2] = '请选择';
              _curAreaId = null;
              _curAreaName = null;
            });
            _tabController.animateTo(2);
            _getCountryData();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CRMGaps.gap_dp12, vertical: CRMGaps.gap_dp10),
            child: Row(
              children: <Widget>[
                if (_curCityId == _cityData[index]['cityID'])
                  Icon(
                    Icons.check,
                    size: 16,
                    color: CRMColors.primary,
                  ),
                SizedBox(
                  width: CRMGaps.gap_dp4,
                ),
                Text(
                  _cityData[index]['cityName'],
                  style: TextStyle(
                      fontSize: CRMText.smallTextSize,
                      fontWeight: _curCityId == _cityData[index]['cityID']
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _curCityId == _cityData[index]['cityID']
                          ? CRMColors.textDark
                          : CRMColors.textNormal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _countryView() {
    return ListView.builder(
      itemCount: _areaData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            setState(() {
              _curAreaId = _areaData[index]['countyID'];
              _curAreaName = _areaData[index]['countyName'];
              _tabs[2] = _curAreaName;
            });
            rootNavigatorState.pop(AddressModel(
                provinceId: _curProvinceId,
                provinceName: _curProvinceName,
                cityId: _curCityId,
                cityName: _curCityName,
                areaId: _curAreaId,
                areaName: _curAreaName));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CRMGaps.gap_dp12, vertical: CRMGaps.gap_dp10),
            child: Row(
              children: <Widget>[
                if (_curAreaId == _areaData[index]['countyID'])
                  Icon(
                    Icons.check,
                    size: 16,
                    color: CRMColors.primary,
                  ),
                SizedBox(
                  width: CRMGaps.gap_dp4,
                ),
                Text(
                  _areaData[index]['countyName'],
                  style: TextStyle(
                      fontSize: CRMText.smallTextSize,
                      fontWeight: _curAreaId == _areaData[index]['countyID']
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _curAreaId == _areaData[index]['countyID']
                          ? CRMColors.textDark
                          : CRMColors.textNormal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: CRMGaps.gap_dp10, horizontal: CRMGaps.gap_dp16),
              child: Text(
                '请选择地区',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CRMColors.textDark,
                    fontSize: CRMText.hugeTextSize),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                tabsWidget(_tabController, _tabs,
                    isScrollable: true,
                    labelColor: CRMColors.textDark,
                    unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: CRMText.normalTextSize),
                    unselectedLabelColor: CRMColors.textDark),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: <Widget>[_provinceView(), _cityView(), _countryView()],
            ))
          ],
        ));
  }
}
