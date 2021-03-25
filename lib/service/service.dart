import '../utils/http_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class Service {
  // get方式
  Future get(Map<String, dynamic> parameters, api, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        api,
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

  // get方式
  Future getData(Map<String, dynamic> parameters, api, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        api,
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

  // post方式
  Future post(Map<String, dynamic> parameters, api, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var response = await HttpUtil.instance.post(
        api + '?jwt=' + prefs.getString('jwt'),
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
