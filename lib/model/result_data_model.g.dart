// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultDataModel _$ResultDataModelFromJson(Map<String, dynamic> json) {
  return ResultDataModel(
    data: json['data'],
    model: json['model'],
    success: json['success'] as bool,
    code: json['code'] as int,
    msg: json['msg'] as String,
    errorMsg: json['errorMsg'] as String,
    state: json['state'] as String,
  );
}

Map<String, dynamic> _$ResultDataModelToJson(ResultDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'model': instance.model,
      'success': instance.success,
      'code': instance.code,
      'msg': instance.msg,
      'errorMsg': instance.errorMsg,
      'state': instance.state
    };
