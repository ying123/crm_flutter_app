// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announce_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnounceListModel _$AnnounceListModelFromJson(Map<String, dynamic> json) {
  return AnnounceListModel(
    createTime: json['createTime'] as int,
    creator: json['creator'] as String,
    id: json['id'] as int,
    publisher: json['publisher'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$AnnounceListModelToJson(AnnounceListModel instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'creator': instance.creator,
      'id': instance.id,
      'publisher': instance.publisher,
      'title': instance.title,
    };
