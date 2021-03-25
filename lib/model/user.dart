import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {

  String jwt;
  String orderOne;
  String orderTwo;
  String orderThree;
  String headimgurl;
  String nickname;
  num fans;
  String kfToken;
  num id;
  String follow;
  dynamic phone;
  num vip;
  num shangjilive;
  String status;
  num is_store;

  User({
    this.jwt,
    this.orderOne,
    this.orderTwo,
    this.orderThree,
    this.headimgurl,
    this.nickname,
    this.fans,
    this.kfToken,
    this.id,
    this.follow,
    this.phone,
    this.vip,
    this.shangjilive,
    this.is_store,
    this.status,
  });

  bool get isStore => is_store == 0 ? false : true;

  num get state => num.tryParse(status ?? '-1');

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);

  Map<String,dynamic> toMap() => _$UserToJson(this);

  @override
  List<Object> get props => [id];
}
