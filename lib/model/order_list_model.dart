import 'package:json_annotation/json_annotation.dart';
part 'order_list_model.g.dart';

@JsonSerializable()
class OrderListModel {
  @JsonKey(name: "order_id")
  int orderId;
  @JsonKey(name: "order_no")
  String orderNo;
  var orgId;
  @JsonKey(name: "org_name")
  String orgName;
  int state;
  String stateName;
  int payState;
  String payTime;
  @JsonKey(name: "total_amount")
  double totalAmount;
  @JsonKey(name: "actual_amount")
  double actualAmount;
  @JsonKey(name: "create_time")
  String createTime;

  OrderListModel(
      {this.orderId,
      this.orderNo,
      this.orgId,
      this.orgName,
      this.state,
      this.stateName,
      this.payState,
      this.payTime,
      this.totalAmount,
      this.actualAmount,
      this.createTime});

  factory OrderListModel.fromJson(Map<String, dynamic> json) =>
      _$OrderListModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
}
