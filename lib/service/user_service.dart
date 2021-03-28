import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class UserServer {
  Future getPayStatus(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.PAY_STATUS_URL,
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

  Future getEnableVxLogin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.getEnableVXLogin,
        parameters: parameters,
      );
      if (response['isShowWxLogin'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }


  Future cwts(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.PAY_CWTS_URL,
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

  Future getMessage(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.SHORT_MESSAGE_URL,
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

  Future setLocation(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_LOCATION_URL,
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

  Future wxLogin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.WX_LOGIN_URL,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future login(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.LOGIN_URL,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getUserInfo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.USER_RUL,
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
    Future getvip(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.VIP_RUL,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['vip']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getAddressList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ADDRESS_URL,
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

  Future getinoculationList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.INOCU_URL,
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
    Future addalbum(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ADDALBUM_URL,
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
  
  Future getYmList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.YM_URL,
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

    Future getlookList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.USER_FOLLOW_URL,
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
    Future getfansList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.USER_FANS_URL,
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

  
  Future getbuyList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.BUYLIST_URL,
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
  Future getswitch(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SWITCH_URL,
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

  Future getyunList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.YUN_URL,
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

  Future getShengzhangList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SHENGZHANG_URL,
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
  Future eventlist(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.EVENTLIST_URL,
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

  Future getbabyList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.BABY_LIST,
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

  Future delAddress(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_ADDRESS_URL,
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
  Future delGrowthRecord(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_GROWTHRECORD_URL,
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
  Future getAddressDetails(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ADDRESS_DETAILS_URL,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['res']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future addAddress(Map<String, dynamic> parameters, String id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id == ''
            ? Api.ADD_ADDRESS_URL + '?jwt=$jwt'
            : Api.EDIT_ADDRESS_URL + '?jwt=$jwt',
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

  Future orderList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ORDER_LIST_URL,
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

  Future delOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_ORDER_URL,
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

  Future cancelOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CANCEL_ORDER_URL,
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

  Future configOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CONFIG_ORDER_URL,
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

  Future exchangeCoupon(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.EXCHANGE_COUPON_URL,
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

  Future couponList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COUPON_LIST_URL,
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

  Future couponRule(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COUPON_RULE_URL,
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

  Future coinList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COIN_LIST_URL,
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

  Future realNameList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.REALNAME_LIST_URL,
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

  Future addRealname(Map<String, dynamic> parameters, String id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id == ''
            ? Api.ADD_REALNAME_URL + '?jwt=$jwt'
            : Api.EDIT_REALNAME_URL + '?jwt=$jwt',
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

    Future addGrowthRecord(Map<String, dynamic> parameters, String id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
     var response = await HttpUtil.instance.get(

            Api.GROWTH_RECORD + '?jwt=$jwt',
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


    Future babyInfo(Map<String, dynamic> parameters, String id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(

            Api.BABY_INFO + '?jwt=$jwt',
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

  Future delRealname(Map<String, dynamic> parameters, String id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_REALNAME_URL,
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

  Future applyAfter(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        Api.APPLY_AFTER_URL + "?jwt=$jwt",
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

  Future getAfterList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.AFTER_LIST_URL,
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

  // 图片
  Future uploadImg(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.post(
        Api.UPLOAD_IMG_URL,
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

  // 消息中心
  Future getNewsList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.NEWS_LIST,
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

  // 消息详情
  Future getNewsDetail(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.NEWS_DETAIL,
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

  // 个人资料
  Future getPersonalData(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.PERSONAL_DATA,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 修改微信名片
  Future setWxImg(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_WXIMG,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 修改头像
  Future setAvatar(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_AVATAR,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 修改绑定微信
  Future changeWx(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHANGE_WX,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 修改绑定手机号
  Future changePhone(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHANGE_PHONE,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 验证手机
  Future checkPhone(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHECK_PHONE,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 注销登录
  Future logOff(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LOG_OFF,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 关于
  Future getAbout(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ABOUT,
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

  // 开通直播权限
  Future openLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.OPEN_LIVE,
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

  // 创建客服
  Future createKf(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CREATE_KF,
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

  // 余额记录
  Future getMyBalance(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.MINE_BALANCE_URL,
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

  // 奖金记录
  Future getBonusBalance(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.MINE_BONUS_URL,
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
  // 提现
  Future toCash(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.TO_CASH_URL,
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

  // 提现
  Future getCashLog(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CASH_LOG_URL,
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

  // 提现
  Future setNickname(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_NICKNAME_URL,
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

  Future returnGoods(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SHOP_RETURN_URL,
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

  Future bindshangji(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.BIND_SHANGJI,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future bmorderList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.BAMAI_LIST_URL,
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
