import 'package:client/baby/baby_music.dart';
import 'package:client/baby/baby_my.dart';
import 'package:client/baby/baby_my_fabu.dart';
import 'package:client/baby/baby_my_question.dart';
import 'package:client/baby/baby_tip.dart';
import 'package:client/baby/book_search.dart';
import 'package:client/baby/food_all.dart';
import 'package:client/baby/food_class.dart';
import 'package:client/baby/food_list.dart';
import 'package:client/baby/food_yuanze.dart';
import 'package:client/baby/food_search.dart';
import 'package:client/baby/foot_yzdetails.dart';
import 'package:client/baby/food_details.dart';
import 'package:client/baby/wik_list.dart';
import 'package:client/baby/wiki.dart';
import 'package:client/baby/wiki_details.dart';
import 'package:client/baby/wiki_listall.dart';
import 'package:client/baby/wili_tjdetails.dart';
import 'package:client/login/xieyi.dart';
import 'package:client/mine/bamai_list.dart';
import 'package:client/mine/member_recharge_page.dart';
import 'package:client/set/contact_us_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../login/login.dart';
import '../tabbar.dart';
import '../mine/set.dart';
import '../mine/fish_currency.dart';
import '../mine/news.dart';
import '../mine/coupon.dart';
import '../mine/harvest_address.dart';
import '../mine/add_address.dart';
import '../mine/my_order.dart';
import '../mine/customer_service.dart';
import '../mine/coupon_rule.dart';
import '../mine/send_back.dart';
import '../set/account_safe.dart';
import '../set/personal_data.dart';
import '../set/relation_wechat.dart';
import '../set/replace_phone.dart';
import '../set/bind_phone.dart';
import '../set/logout_account.dart';
import '../set/logout_confirm.dart';
import '../set/nickname.dart';
import '../set/about_us.dart';
import '../set/agreement.dart';
import '../shop/application.dart';
import '../shop/shop_infor.dart';
import '../shop/shop_manage.dart';
import '../shop/current_balance.dart';
import '../shop/fans_nums.dart';
import '../shop/opening_zb.dart';
import '../shop/invitation_fs.dart';
import '../shop/extension_page.dart';
import '../shop/cumulative_fw.dart';
import '../shop/material_gl.dart';
import '../shop/muyu_college.dart';
import '../shop/diamonds_jx.dart';
import '../shop/diamonds_zx.dart';
import '../shop/create_zhibo.dart';
import '../shop/my_yg.dart';
import '../shop/my_zb.dart';
import '../shop/short_video.dart';
import '../shop/my_video_detail.dart';
import '../shop/infor_card.dart';
import '../shop/anchor_qy.dart';
import '../shop/zb_xieyi.dart';
import '../shop/authentication_one.dart';
import '../shop/authentication_two.dart';
import '../shop/authentication_four.dart';
import '../shop/authentication_three.dart';
import '../shop/authentication_waiting.dart';
import '../shop/authentication_pay.dart';
import '../home/shoppingcart.dart';
import '../home/tijiaodingdan.dart';
import '../shop/choose_goods.dart';
import '../shop/tixian_page.dart';
import '../shop/new_bulid.dart';
import '../shop/manage_bj.dart';
import '../shop/manage_yl.dart';
import '../shop/record_video.dart';
import '../shop/tixian_record.dart';
import '../shop/tixian_alipay.dart';
import '../shop/tixian_bank.dart';
import '../shop/set_store_name.dart';
import '../shop/set_store_desc.dart';
import '../home/order_detail.dart';
import '../home/logistics.dart';
import '../mine/comment.dart';
import '../home/all_comment.dart';
import '../home/shouhou.dart';
import '../zhibo/tip-off.dart';
import '../mine/real_authentication.dart';
import '../home/xiangqing.dart';
import '../my_store/my_store_order.dart';
import '../my_store/shop_list.dart';
import '../my_store/add_shop.dart';
import '../my_store/freight_template.dart';
import '../my_store/add_shop_detail.dart';
import '../my_store/add_shop_formate.dart';
import '../my_store/add_freight_template.dart';
import '../my_store/free_shipping.dart';
import '../my_store/add_free_shipping.dart';
import '../my_store/shipping_hourse.dart';
import '../my_store/add_shipping_hourse.dart';
import '../zhibo/open_zhibo.dart';
import '../zhibo/look_zhibo.dart';
import '../my_store/coupon_list.dart';
import '../my_store/add_coupon.dart';
import '../my_store/choose_goods.dart';
import '../my_store/send_shop.dart';
import '../my_store/store_customer_service.dart';
import '../my_store/customer_detail.dart';
import '../zhibo/liveover.dart';
import '../zhibo/zhiboshop.dart';
import '../shop/live_details.dart';
import '../video/video.dart';
import '../shop/gift_list.dart';
import '../shop/replay_details.dart';
import '../home/bamaixiangqing.dart';
import '../home/bamaiOrder.dart';
import '../home/bamai_list.dart';
import '../home/bamai_order_list.dart';

import '../mine/team.dart';

/// 跳转到首页Splash
import '../home/fenlei.dart';
import '../home/search.dart';
import '../home/service.dart';
import '../zhibo/search_zb.dart';
import '../home/morelist.dart';
import '../home/shopList.dart';
import '../news/news_detail.dart';
import '../mine/real_detail.dart';
import '../zhibo/informationLive.dart';
import '../index.dart';
import '../mine/boshang.dart';
import '../mine/quanxian.dart';
import '../mine/payhhr.dart';
import '../mine/shengjihhr.dart';
import '../mine/integral.dart';
import '../grass/groupDetails.dart';
import '../grass/add_grass.dart';
import '../grass/add_grass_video.dart';
import '../login/state_breed.dart';
import '../login/state_baby.dart';
import '../login/state_way.dart';

import '../login/baby_info.dart';
import '../home/add_baby.dart';
import '../baby/baby_detail.dart';
import '../baby/baby_list.dart';
import '../baby/baby_goodsclass.dart';
import '../baby/baby_classdetail.dart';
import '../baby/baby_fenlei.dart';
import '../baby/baby_listdetail.dart';
import '../baby/detail_info.dart';
import '../baby/baby_lingqu.dart';
import '../baby/baby_yun.dart';
import '../baby/baby_shengzhang.dart';
import '../baby/baby_addsz.dart';
import '../baby/baby_ym.dart';
import '../baby/ym_detail.dart';
import '../baby/add_ym.dart';
import '../baby/ym_info.dart';
import '../baby/baby_big.dart';
import '../baby/add_bigone.dart';
import '../baby/add_bigtwo.dart';
import '../baby/big_affair.dart';
import '../baby/buy_class.dart';
import '../baby/ty_class.dart';
import '../mine/collect_mine.dart';
import '../mine/mine_fensi.dart';
import '../mine/mine_look.dart';
import '../mine/mine_vip.dart';
import '../shop/current_jj.dart';
import '../shop/zj_guanli.dart';
import '../mine/recommend_fans.dart';
import '../baby/yun_search.dart';
import '../baby/yun_time.dart';
import '../baby/all_photo.dart';
import '../baby/other_baby.dart';

/// 跳转到首页Splash
var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginPage(type: '0');
});

/// 注册协议
var xieYiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params["type"]?.first;
  return new XieYiPage(type: type);
});

/// 判断jwt
var indexHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new IndexPage();
});

// 跳转到主页
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String index = params['index']?.first;

  return Tabbar(index: index);
});

var stateHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StatePage();
});

var babyInfoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  String oid = params['oid']?.first;
  return BabyInfoPage(type: type, oid: oid);
});

var babyHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;

  return BabyPage(oid: oid);
});

var otherbabyHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OtherBabyPage();
});
var addbabyHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddBabyPage();
});

var huaiyunHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WayPage();
});

var lingquHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LingQuPage();
});
var fenleiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FenLei();
});

var babyfenleiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('9999999999999======');
  String oid = params['oid']?.first;
  String name = params['name']?.first;
  String type = params['type']?.first;
  print('name===$name');
  return BabyFenLei(oid: oid, name: name, type: type);
});

var searchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Search();
});
var yunsearchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return YunSearch();
});
var searchZbHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SearchZb();
});

var setHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SetPage();
});

var fishHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String coinStr = params['coinStr']?.first;
  return FishCurrencyPage(coinStr: coinStr);
});

var newsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NewsPage();
});

var couponRuleHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CouponRulePage();
});

var couponHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String couponStr = params['couponStr']?.first;
  return CouponPage(couponStr: couponStr);
});
var adressHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String addr = params['addr']?.first;
  return AddAddressPage(addr: addr);
});

var realHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RealAuthenticationPage();
});

var checkAllHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return MyOrderPage(type);
});

var myStoreOrderPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return MyStoreOrderPage(type);
});
var customerServiceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CustomerServicePage();
});

var accountSafeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AccountSafePage();
});
var personalDataHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PersonalDataPage();
});

var addBigoneHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return AddBigOnePage(type: type);
});
var addBigtwoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  String oid = params['oid']?.first;
  return AddBigTwoPage(type: type, oid: oid);
});
var relationWechatHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RelationWechatPage(type: '1');
});

var replacePhoneHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReplacePhonePage();
});

var bindPhoneHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BindPhonePage();
});

var logoutAccountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LogoutAccountPage();
});

var logoutConfirmHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LogoutConfirmPage();
});

var nicknameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NicknamePage();
});

var applicationHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ApplicationPage();
});

var shopInforHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ShopInforPage();
});
var shopManageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ShopManagePage();
});

var currentBalanceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CurrentBalancePage();
});

var currentJJHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CurrentJJPage();
});

var collectMineHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CollectPage();
});
var fansNumsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FansNumsPage();
});

var openingZbHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OpeningZbPage();
});

var invitationFsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return InvitationFsPage();
});

var extensionPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ExtensionPage();
});

var cumulativeFwHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CumulativeFwPage();
});

var materialGlHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MaterialGlPage();
});

var muyuCollegeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MuyuCollegePage();
});

var diamondsZxHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DiamondsZxPage();
});

var diamondsJxHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return DiamondsJxPage(type: type);
});

var createZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateZhiboPage();
});

var myYgHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MyYgPage();
});

var addSzHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params['title']?.first;
  print(title);
  String old = params['old']?.first;
  String weight = params['weight']?.first;
  String height = params['height']?.first;
  String head = params['head']?.first;
  String desc = params['desc']?.first;
  return AddSZPage(
      title: title,
      old: old,
      weight: weight,
      height: height,
      head: head,
      desc: desc);
});
var myZbHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MyZbPage();
});

var shortVideoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ShortVideoPage();
});

var shortVideoDetailsPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String typeId = params['typeId']?.first;
  String objs = params['objs']?.first;
  return VideoPage(typeId: typeId, objs: objs);
});

var myVideoDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String typeId = params['typeId']?.first;
  String objs = params['objs']?.first;
  return MyVideoDetail(typeId: typeId, objs: objs);
});

var inforCardHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return InforCardPage();
});
var anchorQyHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AnchorQyPage();
});

var zbXieyiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return ZbXieyiPage(objs: objs);
});

var authenticationOneHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AuthenticationOnePage();
});

var authenticationTwoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AuthenticationTwoPage(objs: objs);
});

var authenticationThreeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AuthenticationThreePage(objs: objs);
});

var authenticationFourHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AuthenticationFourPage(objs: objs);
});

var authenticationWaitingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AuthenticationWaitingPage();
});

var authenticationPayHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AuthenticationPayPage();
});

var shoppingcartHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ShoppingCart();
});

var tijiaodingdanHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String roomId = params['roomId']?.first;
  String objs = params['objs']?.first;
  return TijiaoDingdan(objs: objs, roomId: roomId);
});

var chooseGoodsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  String objs = params['objs']?.first;
  return ChooseGoodsPage(type: type, objs: objs);
});

var tixianPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TixianPagePage();
});

var newBulidHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NewBulidPage();
});

var manageBjHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ManageBjPage();
});

var manageYlHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return ManageYlPage(objs: objs);
});

var recordVideoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RecordVideoPage();
});
var tixianRecordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TixianRecordPage();
});
var tixianAlipayHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TixianAlipayPage();
});
var tixianBankHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TixianBankPage();
});

var myfensiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MineFensiPage();
});
var recommendFansPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RecommendFansPage();
});
var myvipHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MineVipPage();
});

var mylookHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MineLookPage();
});

var shouhouHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return ShouHouPage(objs: objs);
});

var tipoffHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return TipPage(oid: oid);
});
var babytipoffHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return BabyTipPage(oid: oid);
});

var harvestAddressHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return HarvestAddressPage(type: type);
});
var addymHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return AddYmPage();
});
var xiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String shipId = params['shipId']?.first;
  String roomId = params['roomId']?.first;
  return XiangQingPage(oid: oid, shipId: shipId, roomId: roomId);
});

var ymInfoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String title = params['title']?.first;
  String desc = params['desc']?.first;
  return YMInfoPage(oid: oid, title: title, desc: desc);
});

var detailInfoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String shipId = params['shipId']?.first;
  String roomId = params['roomId']?.first;
  return DetailInfoPage(oid: oid, shipId: shipId, roomId: roomId);
});

var babyxiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String type = params['type']?.first;
  print(oid);
  return BabyXiangQingPage(oid: oid, type: type);
});

var affairHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return AffairPage(oid: oid);
});
var ymxiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String name = params['name']?.first;
  String time = params['time']?.first;
  String desc = params['desc']?.first;
  return YMXiangQingPage(oid: oid, name: name, time: time, desc: desc);
});

var goodsxiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String shipId = params['shipId']?.first;
  String roomId = params['roomId']?.first;
  String type = params['type']?.first;
  return GoodsXiangQingPage(
      oid: oid, shipId: shipId, roomId: roomId, type: type);
});

var babyListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BabyListPage();
});
var bigHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BigPage();
});

var goodClassHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return GoodsClassPage();
});
var buylassHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BuyClassPage();
});
var tyclassHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TyClassPage();
});
var timephotoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TimePhotoPage();
});
var allphotoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AllPhotoPage();
});

var freeShippingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return FreeShippingPage(type: type);
});

var shippingHourseHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return ShippingHoursePage(type: type);
});
var addShippingHourseHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AddShippingHoursePage(objs: objs);
});

var shangpinguanliHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ShangpinguanliPage();
});

var zjglHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ZjGuanliPage();
});

var tianjiashangpinHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return TianjiashangpinPage(oid: oid);
});

var addFreeShippingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String type = params['type']?.first;
  return AddFreeShippingPage(type: type, oid: oid);
});

var yunfeimobanHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return YunfeimobanPage(type: type);
});

var moreListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return MoreList(oid: oid);
});

var moredetailListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return MoreDetailList(oid: oid);
});
var shopListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('9999999999999======');
  String oid = params['oid']?.first;
  String name = params['name']?.first;
  String type = params['type']?.first;
  print('name===$name');
  return ShopList(oid: oid, name: name, type: type);
});

var newsDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return NewsDetailPage(id);
});
var realDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return RealDetailPage(objs);
});

var orderDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  String type = params['type']?.first;
  return OrderDetailPage(objs: objs, type: type);
});

var logisticsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String orderId = params['orderId']?.first;
  return Logistics(orderId: orderId);
});

var commentHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return Comment(objs: objs);
});

var allCommentHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String goodsId = params['goodsId']?.first;
  return AllComment(goodsId: goodsId);
});

var setStoreNameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('params');
  String name = params['name']?.first;
  return SetStoreNamePage(name: name);
});

var setStoreDescHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String desc = params['desc']?.first;
  return SetStoreDescPage(desc: desc);
});

var addShopDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AddShopDetailsPage(objs: objs);
});

var addShopFormateHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AddShopFormatePage(objs: objs);
});

var addFreightHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return AddFreightPage(id: id);
});

var aboutUsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AboutUs();
});

var agreementHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return Agreement(type: type);
});

var openZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String lives = params['lives']?.first;
  String liveUrls = params['liveUrls']?.first;
  return OpenZhibo(live: lives, liveUrl: liveUrls);
});

var lookZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String objs = params['objs']?.first;
  return ZhiboPage(oid: oid, objs: objs);
});

var storeCouponHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CouponListPage();
});

var addCouponPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddCouponPage();
});

var myGoodsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return MyChooseGoodsPage(obj: objs);
});

var sendShopHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return SendShopPage(oid: oid);
});

var storeCustomerServiceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StoreCustomerServicePage();
});
var storeCustomerDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return StoreCustomerDetailsPage(oid: oid);
});

var sendBackPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return SendBackPage(oid: oid);
});

var liveOverHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String type = params['type']?.first;
  return LiveOverPage(oid: oid, type: type);
});

var yunPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return YunPage(id: id);
});

var shengzhangHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return ShengZhangPage(id: id);
});

var informationLiveHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String type = params['type']?.first;
  return InformationLive(oid: oid, type: type);
});

var liveStoreHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return LiveStore(oid: oid);
});

var liveDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return LiveDetails(oid: oid);
});

var serviceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String token = params['token']?.first;
  return WebViewExample(token: token);
});

var giftHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String roomId = params['roomId']?.first;
  print('1242');
  return GiftList(roomId: roomId);
});

var replayDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return ReplayDetails(oid: oid);
});

var baimaiListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BaiMaiList();
});

var baimaOrderiListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BaiMaiOrderList();
});

var bmOrderHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return BamaiOrder(objs: objs);
});

var bmxiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  String type = params['type']?.first;
  return BaiMaiXiangQing(oid: oid, type: type);
});

var teamHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TeamPage();
});

var boshangHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  String nums = params['nums']?.first;
  return Boshang(type: type, nums: nums);
});

var quanxianHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Quanxian();
});

var payhhrHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Payhhr();
});

var shengjihhrHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Shengjihhr();
});

var integralHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Integral();
});

var groupDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return GroupDetails(oid: oid);
});

var addGrassHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AddGrass(objs: objs);
});

var addGrassVideoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return AddGrassVideo(objs: objs);
});

var bmlistHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return BmOrderPage();
});

var foodClassHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return FoodClass();
});

var foodDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String foodId = params['foodId']?.first;
  return FoodDetails(foodId: foodId);
});

var yimiaoHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return YiMiaoPage(id: id);
});

var foodSearchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FoodSearch();
});

var booksearchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BookSearch();
});

var foodYuanzeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String babyId = params['babyId']?.first;
  return FoodYz(babyId: babyId);
});

var foodYuanzeDetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String knowId = params['knowId']?.first;
  return FoodYzDetails(knowId: knowId);
});

var foodAllHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FoodAll();
});

var foodListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String foodId = params['foodId']?.first;
  return FoodList(foodId: foodId);
});

var wikiHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WikiClass();
});

var wikilistHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String bookId = params['bookId']?.first;
  return Wikilist(bookId: bookId);
});

var wikidetailsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String bookId = params['bookId']?.first;
  return Wikidetails(bookId: bookId);
});

var wikiallHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WikiAll();
});

var musicHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MusicClass();
});

var babyMyHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BabyMy();
});

var babyMyQuestionHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return BabyMyQuestion(oid: oid);
});

var babyMyFbHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BabyMyFb();
});

var wikitjHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String bookId = params['bookId']?.first;
  return WikiTjDetails(bookId: bookId);
});

var memberRechargePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MemberRechargePage();
});

/// 虽然这么写可以实现，但是始终认为这是一种智障写法
var contactUSPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      var param = params["phoneNumber"].first;
      return ContactUSPage(phoneNumber: param,);
});