import 'http_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class Service {
  Future sget(url, Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        url,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future lxget(url, Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        url,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else if (response['errcode'] == 10001) {
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future spost(url, Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['edition'] = 1; //创建订单是不是最新版
    var jwt = prefs.getString('jwt');
    try {
      print(parameters['edition']);
      print(parameters);
      print("~~~~~~~~~~~~~~~~~");
      var response = await HttpUtil.instance.post(
        url + '?jwt=' + jwt,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }
}
