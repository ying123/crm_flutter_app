import 'package:json_annotation/json_annotation.dart';
part 'customer_info_model.g.dart';

@JsonSerializable()
class CustomerInfoMode {
  @JsonKey(name: 'customer_id')
  int customerId;
  String company;
  @JsonKey(name: 'customer_type')
  String customerType;
  @JsonKey(name: 'signin_type')
  String signinType;
  String name;
  String pic;
  @JsonKey(name: 'card_id')
  String cardId;
  @JsonKey(name: 'card_pic')
  String cardPic;
  String area;
  String address;
  String phone;
  bool isSku;
  bool is4s;

  CustomerInfoMode(
      this.customerId,
      this.company,
      this.customerType,
      this.signinType,
      this.name,
      this.pic,
      this.cardId,
      this.cardPic,
      this.area,
      this.address,
      this.phone,
      this.isSku,
      this.is4s);

  factory CustomerInfoMode.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerInfoModeToJson(this);
}
