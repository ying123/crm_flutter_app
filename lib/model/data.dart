import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class Data {
  final String name;
  final int age;
  @JsonKey(nullable: false)
  Data({this.name, this.age});
  //反序列化
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
//序列化
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
