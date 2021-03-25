import 'package:client/utils/string_util.dart';
import 'package:client/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';


class Global {
  static const String NO_LOGIN = '请先登录';
  static bool logined = true;
  static  bool isShow = false;
  // 身份证号格式化
  static String formatIdCard(String phone) {
    return phone.length == 18
        ? phone.substring(0, 4) +
            '****' +
            phone.substring(phone.length - 4, phone.length)
        : phone;
  }

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) + "" + formatTime(minute) + "" + formatTime(second);
  }

  static String addNums(int n) {
    if (n < 10) {
      return "0" + n.toString();
    } else {
      return n.toString();
    }
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  // 手机号格式化
  static String formatPhone(String phone) {
    if (StringUtils.isEmpty(phone)) {
      return '';
    }
    return phone.length == 11
        ? phone.substring(0, 3) +
            '****' +
            phone.substring(phone.length - 4, phone.length)
        : phone;
  }

  static final List city = [
    // {"name":"北京市"},
    // {"name":"天津市"},
    // {"name":"河北省"},
    // {"name":"山西省"},
    // {"name":"内蒙古自治区"},
    // {"name":"辽宁省"},
    // {"name":"吉林省"},
    // {"name":"黑龙江省"},
    // {"name":"上海市"},
    // {"name":"江苏省"},
    // {"name":"浙江省"},
    // {"name":"安徽省"},
    // {"name":"福建省"},
    // {"name":"江西省"},
    // {"name":"山东省"},
    // {"name":"河南省"},
    // {"name":"湖北省"},
    // {"name":"湖南省"},
    // {"name":"广东省"},
    // {"name":"广西壮族自治区"},
    // {"name":"海南省"},
    // {"name":"重庆市"},
    // {"name":"四川省"},
    // {"name":"贵州省"},
    // {"name":"云南省"},
    // {"name":"西藏自治区"},
    // {"name":"陕西省"},
    // {"name":"甘肃省"},
    // {"name":"青海省"},
    // {"name":"宁夏回族自治区"},
    // {"name":"新疆维吾尔自治区"},
    // {"name":"台湾省"},
    // {"name":"香港特别行政区"},
    // {"name":"澳门特别行政区"},

    {"flag": false, "isSelect": false, "name": "北京市"},
    {"flag": false, "isSelect": false, "name": "天津市"},
    {"flag": false, "isSelect": false, "name": "河北省"},
    {"flag": false, "isSelect": false, "name": "山西省"},
    {"flag": false, "isSelect": false, "name": "内蒙古自治区"},
    {"flag": false, "isSelect": false, "name": "辽宁省"},
    {"flag": false, "isSelect": false, "name": "吉林省"},
    {"flag": false, "isSelect": false, "name": "黑龙江省"},
    {"flag": false, "isSelect": false, "name": "上海市"},
    {"flag": false, "isSelect": false, "name": "江苏省"},
    {"flag": false, "isSelect": false, "name": "浙江省"},
    {"flag": false, "isSelect": false, "name": "安徽省"},
    {"flag": false, "isSelect": false, "name": "福建省"},
    {"flag": false, "isSelect": false, "name": "江西省"},
    {"flag": false, "isSelect": false, "name": "山东省"},
    {"flag": false, "isSelect": false, "name": "河南省"},
    {"flag": false, "isSelect": false, "name": "湖北省"},
    {"flag": false, "isSelect": false, "name": "湖南省"},
    {"flag": false, "isSelect": false, "name": "广东省"},
    {"flag": false, "isSelect": false, "name": "广西壮族自治区"},
    {"flag": false, "isSelect": false, "name": "海南省"},
    {"flag": false, "isSelect": false, "name": "重庆市"},
    {"flag": false, "isSelect": false, "name": "四川省"},
    {"flag": false, "isSelect": false, "name": "贵州省"},
    {"flag": false, "isSelect": false, "name": "云南省"},
    {"flag": false, "isSelect": false, "name": "西藏自治区"},
    {"flag": false, "isSelect": false, "name": "陕西省"},
    {"flag": false, "isSelect": false, "name": "甘肃省"},
    {"flag": false, "isSelect": false, "name": "青海省"},
    {"flag": false, "isSelect": false, "name": "宁夏回族自治区"},
    {"flag": false, "isSelect": false, "name": "新疆维吾尔自治区"},
    {"flag": false, "isSelect": false, "name": "台湾省"},
    {"flag": false, "isSelect": false, "name": "香港特别行政区"},
    {"flag": false, "isSelect": false, "name": "澳门特别行政区"},
  ];

  // 获取当前时间时间戳（秒）
  static int currentTimeMillis() {
    return ((new DateTime.now().millisecondsSinceEpoch) ~/ 1000).toInt();
  }

  static String djsTime(time) {
    // print('time====$time');
    int day = time ~/ (3600 * 24);
    int hour = time % (3600 * 24) ~/ 3600;
    int minute = time % 3600 ~/ 60;
    int second = time % 60;
    if (day != 0) {
      return day.toString() +
          "d " +
          formatTime(hour) +
          ':' +
          formatTime(minute);
    } else if (hour != 0) {
      return formatTime(hour) +
          ":" +
          formatTime(minute) +
          ":" +
          formatTime(second);
    } else if (minute != 0) {
      return formatTime(minute) + ":" + formatTime(second);
    } else {
      return '00:' + formatTime(second);
    }
  }

  // 订单状态
  static String getStatus(status) {
    if (status == '0') {
      return '待付款';
    } else if (status == '1') {
      return '待发货';
    } else if (status == '2') {
      return '待收货';
    } else if (status == '3') {
      return '已完成';
    } else if (status == '4') {
      return '已取消';
    } else {
      return '已评价';
    }
  }

  static handleCameraAndMic() async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    //校验权限
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      ToastUtil.showToast('相机权限获取失败');
      return false;
    }
    if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
      ToastUtil.showToast('麦克风权限获取失败');
      return false;
    }
    return true;
  }
}
