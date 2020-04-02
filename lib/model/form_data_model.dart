import 'package:json_annotation/json_annotation.dart';
part 'form_data_model.g.dart';

@JsonSerializable()
class FormDataModel {
  final String title;
  final String field;
  final String value;

  FormDataModel({this.title, this.field, this.value});

  // 序列化
  factory FormDataModel.fromJson(Map<String, dynamic> json) =>
      _$FormDataModelFromJson(json);

  // 反序列
  Map<String, dynamic> toJson() => _$FormDataModelToJson(this);
}
