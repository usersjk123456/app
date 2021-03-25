import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class StoreServer {
  //首页
  Future getHome(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_HOME_URL,
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

  Future getXieYi(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_XIEYI_URL,
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

  Future getStoreType(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_TYPE_URL,
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

  Future applyStore(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        Api.STORE_APPLY_URL + '?jwt=$jwt',
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

  Future setStoreName(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_STORE_NAME_URL,
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

  Future setStorDesc(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_STORE_DESC_URL,
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

  Future setStorHead(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_STORE_HEAD_URL,
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

  Future setStorImg(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_STORE_IMG_URL,
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

  Future getStoreMoney(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_MONEY_URL,
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

  Future storePay(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_PAY_URL,
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

  Future getStoreOrderList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_ORDER_LIST_URL,
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

  Future getStorGoodsTypeList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_GOODS_TYPE_LIST_URL,
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

  Future addFreightTempalte(Map<String, dynamic> parameters, id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id == "null"
            ? Api.ADD_FREIGHT_TEMPLATE_URL + '?jwt=$jwt'
            : Api.EDIT_FREIGHT_TEMPLATE_URL + '?jwt=$jwt',
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

  Future getFreightTempalteList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.FREIGHT_TEMPLATE_LIST_URL,
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

  Future delFreightTempalteList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_FREIGHT_TEMPLATE_URL,
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

  Future getFreightTempalteDetails(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.FREIGHT_TEMPLATE_DETAILS_URL,
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

  Future addFreeShipping(Map<String, dynamic> parameters, id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id == "null"
            ? Api.ADD_FREE_SHIPPING_URL + '?jwt=$jwt'
            : Api.EDIT_FREE_SHIPPING_URL + '?jwt=$jwt',
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

  Future getFreeShippingList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_FREE_SHIPPING_LIST_URL,
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

  Future delFreeShippingList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_FREE_SHIPPING_URL,
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

  Future getFreeShippingDetails(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.FREE_SHIPPING_DETAILS_URL,
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

  Future getShippingHourseList(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SHIPPING_HOURSE_LIST_URL,
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

  Future addShippingHourse(Map<String, dynamic> parameters, id,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id == "null"
            ? Api.ADD_SHIPPING_HOURSE_URL + '?jwt=$jwt'
            : Api.EDIT_SHIPPING_HOURSE_URL + '?jwt=$jwt',
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

  Future delShippingHourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_SHIPPING_HOURSE_URL,
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

  Future createshop(Map<String, dynamic> parameters, id, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        id.toString() == "null"
            ? Api.STORE_CREATE_SHOP_URL + '?jwt=$jwt'
            : Api.EDIT_STORE_SHOP_URL + '?jwt=$jwt',
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

  Future getShopList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_SHOP_LIST_URL,
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

  Future upShopList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.UP_SHOP_URL,
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

  Future delShopList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DEL_SHOP_LIST_URL,
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

  Future getShopDetails(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_SHOP_DETAIL_URL,
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

  Future getCouponList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_COUPON_LIST_URL,
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

  Future addCoupon(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        Api.CREATE_COUPON_URL + '?jwt=$jwt',
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

  Future addCouponNum(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ADD_COUPON_NUM_URL,
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

  Future sendShop(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_SEND_SHOP_URL,
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

  Future getExpressList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.EXPRESS_LIST_URL,
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

  Future getStoreAfterList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_AFTER_LIST_URL,
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

  Future getStoreAfterDetails(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_AFTER_DETAILS_URL,
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

  Future configAfterHandle(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_AFTER_HANDLE_URL,
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

  // 推广订单列表
  Future getExtendOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.EXTEND_ORDER,
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

  // 橙子宝宝学院
  Future getHelp(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.GET_HELP,
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

  // 素材管理
  Future materialManage(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.MATERIAL_MANAGE,
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

  // 访客管理
  Future guestManage(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.GUEST_MANAGE,
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

  Future getDiomondList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DIAMOND_URL,
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

  Future getFansList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_FANS_LIST_URL,
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

  Future getStoreMassage(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_MESSAGE_URL,
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

  Future sendMaterial(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_SEND_MATERIAL_URL,
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

  Future storeChoice(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_CHOICE_URL,
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

  Future storeDelUpGoods(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_DEL_UP_GOODS_URL,
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

  Future getStoreAll(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.STORE_ALL_URL,
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

  Future getGiftList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.GIFT_LIST,
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
