// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_recharge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VipRecharge _$VipRechargeFromJson(Map<String, dynamic> json) {
  return VipRecharge(
      jwt: json['jwt'] as String,
      time: json['time'] as String,
      level: json['level'] as String,
      money: json['money'] as String,
      title: json['title'] as String,
      priceTypeName: json['priceTypeName'] as String,
      discountPrice: json['discountPrice'] as String);
}

Map<String, dynamic> _$VipRechargeToJson(VipRecharge instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'money': instance.money,
      'time': instance.time,
      'level': instance.level,
      'title': instance.title,
      'priceTypeName': instance.priceTypeName,
      'discountPrice': instance.discountPrice
    };
