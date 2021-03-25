// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      jwt: json['jwt'] as String,
      orderOne: json['orderOne'] as String,
      orderTwo: json['orderTwo'] as String,
      orderThree: json['orderThree'] as String,
      headimgurl: json['headimgurl'] as String,
      nickname: json['nickname'] as String,
      fans: json['fans'] as num,
      kfToken: json['kfToken'] as String,
      id: json['id'] as num,
      follow: json['follow'] as String,
      phone: json['phone'],
      vip: json['vip'] as num,
      shangjilive: json['shangjilive'] as num,
      is_store: json['is_store'] as num,
      status: json['status'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'jwt': instance.jwt,
      'orderOne': instance.orderOne,
      'orderTwo': instance.orderTwo,
      'orderThree': instance.orderThree,
      'headimgurl': instance.headimgurl,
      'nickname': instance.nickname,
      'fans': instance.fans,
      'kfToken': instance.kfToken,
      'id': instance.id,
      'follow': instance.follow,
      'phone': instance.phone,
      'vip': instance.vip,
      'shangjilive': instance.shangjilive,
      'status': instance.status,
      'is_store': instance.is_store
    };
