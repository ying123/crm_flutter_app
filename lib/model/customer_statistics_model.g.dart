// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerStatisticsModel _$CustomerStatisticsModelFromJson(
    Map<String, dynamic> json) {
  return CustomerStatisticsModel(
    contactNum: json['contactNum'] as int,
    returnGoodNum: json['returnGoodNum'] as int,
    exchangeGoodNum: json['exchangeGoodNum'] as int,
    orderNum: json['orderNum'] as int,
    invoiceNum: json['invoiceNum'] as int,
    inquiryNum: json['inquiryNum'] as int,
    customerId: json['customerId'] as String,
    customerName: json['customerName'] as String,
    functionaryTeam: json['functionaryTeam'] as String,
    functionaryStart: json['functionaryStart'] as String,
  );
}

Map<String, dynamic> _$CustomerStatisticsModelToJson(
        CustomerStatisticsModel instance) =>
    <String, dynamic>{
      'contactNum': instance.contactNum,
      'returnGoodNum': instance.returnGoodNum,
      'exchangeGoodNum': instance.exchangeGoodNum,
      'orderNum': instance.orderNum,
      'invoiceNum': instance.invoiceNum,
      'inquiryNum': instance.inquiryNum,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'functionaryTeam': instance.functionaryTeam,
      'functionaryStart': instance.functionaryStart,
    };
