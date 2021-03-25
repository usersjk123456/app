import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_recharge.g.dart';

@JsonSerializable()
class MemberRecharge extends Equatable {
  String id;

  String jwt;

  String rmb;

  String coin;

  String status;

  String create_at;

  String give;

  MemberRecharge({
    this.id,
    this.jwt,
    this.rmb,
    this.coin,
    this.status,
    this.create_at,
    this.give,
  });

  factory MemberRecharge.fromJson(Map<String, dynamic> json) =>
      _$MemberRechargeFromJson(json);

  Map<String, dynamic> toMap() => _$MemberRechargeToJson(this);

  @override
  List<Object> get props => [id];
}
