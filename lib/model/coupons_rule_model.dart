import 'package:json_annotation/json_annotation.dart';

part 'coupons_rule_model.g.dart';

@JsonSerializable()
class CouponsItemModel {
  String title;
  bool isSelected;
  int id;

  CouponsItemModel({
    this.title,
    this.isSelected,
    this.id,
  });

  factory CouponsItemModel.fromJson(Map<String, dynamic> json) =>
      _$CouponsItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponsItemModelToJson(this);
}
