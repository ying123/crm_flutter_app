// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupons_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponsItemModel _$CouponsItemModelFromJson(Map<String, dynamic> json) {
  return CouponsItemModel(
    title: json['title'] as String,
    isSelected: json['isSelected'] as bool,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$CouponsItemModelToJson(CouponsItemModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isSelected': instance.isSelected,
      'id': instance.id,
    };
