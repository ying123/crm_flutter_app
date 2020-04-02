import 'package:json_annotation/json_annotation.dart';
part 'customer_statistics_model.g.dart';

@JsonSerializable()
class CustomerStatisticsModel {
  int contactNum;
  int returnGoodNum;
  int exchangeGoodNum;
  int orderNum;
  int invoiceNum;
  int inquiryNum;
  String customerId;
  String customerName;
  String functionaryTeam;
  String functionaryStart;

  CustomerStatisticsModel({
    this.contactNum,
    this.returnGoodNum,
    this.exchangeGoodNum,
    this.orderNum,
    this.invoiceNum,
    this.inquiryNum,
    this.customerId,
    this.customerName,
    this.functionaryTeam,
    this.functionaryStart,
  });

  factory CustomerStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerStatisticsModelToJson(this);
}
