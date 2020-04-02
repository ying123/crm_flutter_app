// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) {
  return OrderListModel(
    orderId: json['order_id'] as int,
    orderNo: json['order_no'] as String,
    orgId: json['orgId'] as int,
    orgName: json['org_name'] as String,
    state: json['state'] as int,
    stateName: json['stateName'] as String,
    payState: json['payState'] as int,
    payTime: json['payTime'] as String,
    totalAmount: (json['total_amount'] as num)?.toDouble(),
    actualAmount: (json['actual_amount'] as num)?.toDouble(),
    createTime: json['create_time'] as String,
  );
}

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_no': instance.orderNo,
      'orgId': instance.orgId,
      'org_name': instance.orgName,
      'state': instance.state,
      'stateName': instance.stateName,
      'payState': instance.payState,
      'payTime': instance.payTime,
      'total_amount': instance.totalAmount,
      'actual_amount': instance.actualAmount,
      'create_time': instance.createTime,
    };
