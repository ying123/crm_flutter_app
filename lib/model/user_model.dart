import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int userId;
  String loginName;
  String mobile;
  String encryptToken;
  @JsonKey(nullable: false)
  UserModel({this.userId, this.loginName, this.mobile, this.encryptToken});

  //反序列化
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
//序列化
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
