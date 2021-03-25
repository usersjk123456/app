//验证用户名
class RegExpTest {
  static RegExp checknum = RegExp(r'^[0-9]{6}$');
  static RegExp checkformate = RegExp(r"[\u4e00-\u9fa5|;|A-Z|a-z|0-9]+");
  // 正则匹配手机号
  static RegExp checkPhone = RegExp(r'^1[3456789]\d{9}$');
  // 邮箱
  static RegExp checkEmail =
      RegExp("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$");
  //身份证号码
  static RegExp checkCard = RegExp(
      r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
}
