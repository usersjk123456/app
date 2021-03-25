import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vip_recharge.g.dart';

@JsonSerializable()
class VipRecharge extends Equatable{

  String jwt;

  String money;

  String time;

  String level;

  String title;

  String priceTypeName;

  String discountPrice;

  VipRecharge({
    this.jwt,
    this.time,
    this.level,
    this.money,
    this.title,
    this.priceTypeName,
    this.discountPrice,
  });

  String get total => discountPrice;

  factory VipRecharge.fromJson(Map<String,dynamic> json) => _$VipRechargeFromJson(json);

  Map<String,dynamic> toMap() => _$VipRechargeToJson(this);

  @override
  List<Object> get props => [level];
}
