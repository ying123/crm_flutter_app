import 'package:json_annotation/json_annotation.dart';
part 'result_data_model.g.dart';

@JsonSerializable()
class ResultDataModel {
  dynamic data;
  dynamic model;
  bool success;
  int code;
  String msg;
  String errorMsg;
  String state;

  ResultDataModel(
      {this.data,
      this.model,
      this.success,
      this.code,
      this.msg,
      this.errorMsg,
      this.state});

  factory ResultDataModel.fromJson(Map<String, dynamic> json) =>
      _$ResultDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDataModelToJson(this);
}
