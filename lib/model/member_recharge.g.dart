// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_recharge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRecharge _$MemberRechargeFromJson(Map<String, dynamic> json) {
  return MemberRecharge(
      id: json['id'] as String,
      jwt: json['jwt'] as String,
      rmb: json['rmb'] as String,
      coin: json['coin'] as String,
      status: json['status'] as String,
      create_at: json['create_at'] as String,
      give: json['give'] as String);
}

Map<String, dynamic> _$MemberRechargeToJson(MemberRecharge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jwt': instance.jwt,
      'rmb': instance.rmb,
      'coin': instance.coin,
      'status': instance.status,
      'create_at': instance.create_at,
      'give': instance.give
    };
