// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    userId: json['userId'] as int,
    loginName: json['loginName'] as String,
    mobile: json['mobile'] as String,
    encryptToken: json['encryptToken'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'loginName': instance.loginName,
      'mobile': instance.mobile,
      'encryptToken': instance.encryptToken,
    };
