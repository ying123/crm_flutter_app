import 'package:json_annotation/json_annotation.dart';
part 'customer_detail_model.g.dart';

@JsonSerializable()
class CustomerDetailModel {
  String address; // 地址
  String busiLicenceNo; // 营业执照号
  String busiLicenceUrl; // 营业执照图
  String cactTel; // 业务电话
  String cityId; // 城市id
  String cityName; // 城市名称
  String contactName; // 联系人
  String contactTel; // 联系电话
  String countyId; // 国家Id
  String countyName; // 国家名称
  String createDate; // 创建日期
  String customerType; // 客户类型 0：未知  1：普通客户 2：集团客户 3：保险客户
  String functionary; // 所属负责人Id
  String functionaryName; // 所属负责人
  String id; // 客户ID
  String legalName; // 法人姓名
  String mfctyId; // 注册组织ID
  String mfctyName; // 企业名称
  String provinceId; // 省份ID
  String provinceName; // 省份名称
  String regionId; // 分区ID
  String regionPath; // 分区全路径
  String remark; // 备注
  String status; // 状态
  String teamId;
  String teamName;
  String townId; // 镇ID
  String townName; // 镇名称

  CustomerDetailModel(
      {this.address,
      this.busiLicenceNo,
      this.busiLicenceUrl,
      this.cactTel,
      this.cityId,
      this.cityName,
      this.contactName,
      this.contactTel,
      this.countyId,
      this.countyName,
      this.createDate,
      this.customerType,
      this.functionary,
      this.functionaryName,
      this.id,
      this.legalName,
      this.mfctyId,
      this.mfctyName,
      this.provinceId,
      this.provinceName,
      this.regionId,
      this.regionPath,
      this.remark,
      this.status,
      this.teamId,
      this.teamName,
      this.townId,
      this.townName});

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDetailModelToJson(this);
}
