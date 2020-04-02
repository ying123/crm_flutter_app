// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerInfoMode _$CustomerInfoModeFromJson(Map<String, dynamic> json) {
  return CustomerInfoMode(
    json['customer_id'] as int,
    json['company'] as String,
    json['customer_type'] as String,
    json['signin_type'] as String,
    json['name'] as String,
    json['pic'] as String,
    json['card_id'] as String,
    json['card_pic'] as String,
    json['area'] as String,
    json['address'] as String,
    json['phone'] as String,
    json['isSku'] as bool,
    json['is4s'] as bool,
  );
}

Map<String, dynamic> _$CustomerInfoModeToJson(CustomerInfoMode instance) =>
    <String, dynamic>{
      'customer_id': instance.customerId,
      'company': instance.company,
      'customer_type': instance.customerType,
      'signin_type': instance.signinType,
      'name': instance.name,
      'pic': instance.pic,
      'card_id': instance.cardId,
      'card_pic': instance.cardPic,
      'area': instance.area,
      'address': instance.address,
      'phone': instance.phone,
      'isSku': instance.isSku,
      'is4s': instance.is4s,
    };
