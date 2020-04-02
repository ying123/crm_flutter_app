import 'package:json_annotation/json_annotation.dart';
part 'announce_list_model.g.dart';

@JsonSerializable()
class AnnounceListModel {
  int createTime;
  String creator;
  int id;
  String publisher;
  String title;

  AnnounceListModel(
      {this.createTime, this.creator, this.id, this.publisher, this.title});

  factory AnnounceListModel.fromJson(Map<String, dynamic> json) =>
      _$AnnounceListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnounceListModelToJson(this);
}
