// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormDataModel _$FormDataModelFromJson(Map<String, dynamic> json) {
  return FormDataModel(
    title: json['title'] as String,
    field: json['field'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$FormDataModelToJson(FormDataModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'field': instance.field,
      'value': instance.value,
    };
