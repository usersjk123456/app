import 'package:flutter/material.dart';
import 'application.dart';
import 'routes.dart';
import 'fluro_convert_util.dart';

class NavigatorUtils {
  //退出登录
  static logout(BuildContext context) {
    /// Routes.home 路由地址
    /// replace：true 就是将 splash 页面给移除掉了，这点后退键的时候就不会再出现Splash页面（移除上一个页面）
    /// clearStack : true 就是将之前所有页面移除
    Application.router.navigateTo(context, Routes.root, clearStack: true);
  }

  static goHomePage(BuildContext context, [String index, String id]) {
    return Application.router.navigateTo(
        context, Routes.home + "?index=$index&id=$id",
        clearStack: true, replace: true);
  }

  static goStatePage(BuildContext context, [String index]) {
    return Application.router.navigateTo(context, Routes.state);
  }

  static goBabyInfoPage(BuildContext context, [String type, String oid]) {
    return Application.router
        .navigateTo(context, Routes.babyInfo + "?type=$type&oid=$oid");
  }

  static goBabyPage(BuildContext context, [String oid]) {
    return Application.router.navigateTo(context, Routes.baby + "?oid=$oid");
  }

  static gootherBabyPage(BuildContext context, [String index]) {
    return Application.router.navigateTo(context, Routes.otherbaby);
  }

  static addBaby(BuildContext context, [String index]) {
    return Application.router.navigateTo(context, Routes.addbaby);
  }

  static goHuaiyunPage(BuildContext context, [String index]) {
    return Application.router.navigateTo(context, Routes.huaiyun);
  }

  static goBeiyunPage(BuildContext context, [String index]) {
    return Application.router.navigateTo(context, Routes.beiyun);
  }

  static toLingQu(BuildContext context, [String index]) {
    //return Application.router.navigateTo(context, Routes.lingqu);
    //Navigator.pop(context);
  }

  static goSetPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.sets);
  }

  static goFenleiPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.fenlei);
  }

  static goBabyFenleiPage(
    BuildContext context, [
    String oid,
    String name,
    String type,
  ]) {
    String names = FluroConvertUtils.fluroCnParamsEncode(name);
    return Application.router.navigateTo(
        context, Routes.babyfenlei + "?oid=$oid&name=$names&type=$type");
  }

  static goSearchPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.search);
  }

  static goYunSearchPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.yunsearch);
  }

  static toTimePhoto(BuildContext context) {
    return Application.router.navigateTo(context, Routes.timephoto);
  }

  static toAllPhoto(BuildContext context) {
    return Application.router.navigateTo(context, Routes.allphoto);
  }

  static goSearchZbPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.searchZb);
  }

  static goFishCurrencyPage(BuildContext context, [String coinStr]) {
    return Application.router
        .navigateTo(context, Routes.fish + "?coinStr=$coinStr");
  }

  static goNewsPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.news);
  }

  static goCouponPage(BuildContext context, [String couponStr]) {
    return Application.router
        .navigateTo(context, Routes.coupon + "?couponStr=$couponStr");
  }

  static goHarvestAddressPage(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.harvestAddress + "?type=$type");
  }

  static goRealAuthenticationPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.real);
  }

  static goMyOrderPage(BuildContext context, String type, [int status]) {
    if (status == 1) {
      return Application.router
          .navigateTo(context, Routes.checkAll + "?type=$type", replace: true);
    } else {
      return Application.router
          .navigateTo(context, Routes.checkAll + "?type=$type");
    }
  }

  static goMyStoreOrderPage(BuildContext context, String type, [int status]) {
    return Application.router
        .navigateTo(context, Routes.myStoreOrderPage + "?type=$type");
  }

  static goCustomerServicePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.customerService);
  }

  static goAccountSafePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.accountSafe);
  }

  static goPersonalDataPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.personalData);
  }

  static goAddBigonePage(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.addBigone + '?type=$type');
  }

  static goAddBigtwoPage(BuildContext context, [String type, String oid]) {
    return Application.router
        .navigateTo(context, Routes.addBigtwo + '?type=$type&oid=$oid');
  }

  static goRelationWechatPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.relationWechat);
  }

  static goReplacePhonePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.replacePhone);
  }

  static goBindPhonePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.bindPhone);
  }

  static goLogoutAccountPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.logoutAccount);
  }

  static goLogoutConfirmPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.logoutConfirm);
  }

  static goNicknamePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.nickname);
  }

  static goApplicationPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.application);
  }

  static goShopInforPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shopInfor);
  }

  static toShopManagePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shopManage);
  }

  static goCurrentBalancePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.currentBalance);
  }

  static goCurrentJJPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.currentJJ);
  }

  static goCollectMine(BuildContext context) {
    return Application.router.navigateTo(context, Routes.collectMine);
  }

  static goFansNumsPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.fansNums);
  }

  static goOpeningZbPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.openingZb);
  }

  static goInvitationFsPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.invitationFs);
  }

  static toExtensionPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.extensionPage);
  }

  static toCumulativeFwPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.cumulativeFw);
  }

  static toMaterialGlPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.materialGl);
  }

  static toMuyuCollegePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.muyuCollege);
  }

  static toDiamondsZxPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.diamondsZx);
  }

  static toDiamondsJxPage(BuildContext context, String type) {
    return Application.router
        .navigateTo(context, Routes.diamondsJx + '?type=$type');
  }

  static toCreateZhiboPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.createZhibo);
  }

  static toMyYgPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.myYg);
  }

  static goAddSZPage(BuildContext context,
      [String title,
      String old,
      String weight,
      String height,
      String head,
      String desc]) {
    String titles = FluroConvertUtils.object2string(title);
    String descs = FluroConvertUtils.object2string(desc);
    return Application.router.navigateTo(
        context,
        Routes.addSz +
            "?title=$titles&old=$old&weight=$weight&height=$height&head=$head&desc=$descs");
  }

  static toMyZbPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.myZb);
  }

  static toShortVideoPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shortVideo);
  }

  static goShortVideoDetailsPage(BuildContext context, String typeId, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router.navigateTo(
        context, Routes.shortVideoDetailsPage + "?typeId=$typeId&objs=$objs");
  }

  static goMyVideoDetail(BuildContext context, String typeId, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router.navigateTo(
        context, Routes.myVideoDetail + "?typeId=$typeId&objs=$objs");
  }

  static toInforCardPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.inforCard);
  }

  static toAnchorQyPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.anchorQy);
  }

  static toZbXieyiPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.zbXieyi + "?objs=$objs");
  }

  static toAuthenticationOnePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.authenticationOne);
  }

  static toAuthenticationTwoPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.authenticationTwo + "?objs=$objs");
  }

  static goAuthenticationThreePage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.authenticationThree + "?objs=$objs");
  }

  static toAuthenticationFourPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.authenticationFour + "?objs=$objs");
  }

  static goAuthenticationWaitingPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.authenticationWaiting);
  }

  static toAuthenticationPayPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.authenticationPay);
  }

  static toShoppingCart(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shoppingcart);
  }

  static toTijiaoDingdan(BuildContext context, [Map obj, String roomId]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router.navigateTo(
        context, Routes.tijiaodingdan + "?objs=$objs&roomId=$roomId");
  }

  static toChooseGoodsPage(BuildContext context, [String type, Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    print('--------');
    print(objs);
    return Application.router
        .navigateTo(context, Routes.chooseGoods + "?type=$type&objs=$objs");
  }

  static toTixianPagePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.tixianPage);
  }

  static toNewBulidPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.newBulid);
  }

  static toManageBjPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.manageBj);
  }

  static toManageYlPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.manageYl + "?objs=$objs");
  }

  static toRecordVideoPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.recordVideo);
  }

  static toTixianAlipayPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.tixianAlipay);
  }

  static toTixianBankPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.tixianBank);
  }

  static toTixianRecordPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.tixianRecord);
  }

  static toShouHouPage(BuildContext context, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.shouhou + "?objs=$objs");
  }

  static toTipoffPage(BuildContext context, oid) {
    return Application.router.navigateTo(context, Routes.tipoff + "?oid=$oid");
  }

  static toBabytipoffPage(BuildContext context, oid) {
    return Application.router
        .navigateTo(context, Routes.babytipoff + "?oid=$oid");
  }

  static toXiangQing(BuildContext context,
      [String oid, String shipId, String roomId]) {
    return Application.router.navigateTo(
        context, Routes.xiangqing + "?oid=$oid&shipId=$shipId&roomId=$roomId");
  }

  static todetailInfo(BuildContext context,
      [String oid, String shipId, String roomId]) {
    return Application.router.navigateTo(
        context, Routes.detailInfo + "?oid=$oid&shipId=$shipId&roomId=$roomId");
  }

  static goYmInfo(BuildContext context,
      [String oid, String title, String desc]) {
    String titles = FluroConvertUtils.fluroCnParamsEncode(title);

    String descs = FluroConvertUtils.fluroCnParamsEncode(desc);

    return Application.router.navigateTo(
        context, Routes.ymInfo + "?oid=$oid&title=$titles&desc=$descs");
  }

  static toBabyList(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.babyList);
  }

  static toBig(BuildContext context, id) {
    return Application.router.navigateTo(context, Routes.big + "?id=$id");
  }

  static togoodClassList(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.goodClass);
  }

  static look(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.mylook);
  }

  static fensi(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.myfensi);
  }

  static goRecommendFansPage(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.recommendFansPage);
  }

  static goVip(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.myvip);
  }

  static goBuyClassPage(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.buyclass);
  }

  static goTyClassPage(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.tyclass);
  }

  static gobabyXiangqing(BuildContext context, [String oid, String type]) {
    return Application.router
        .navigateTo(context, Routes.babyxiangqing + "?oid=$oid&type=$type");
  }

  static toaffair(BuildContext context, String oid) {
    return Application.router.navigateTo(context, Routes.affair + "?oid=$oid");
  }

  static goYmDetail(BuildContext context,
      [String oid, String name, String time, String desc]) {
    String names = FluroConvertUtils.fluroCnParamsEncode(name);
    String times = FluroConvertUtils.fluroCnParamsEncode(time);
    String descs = FluroConvertUtils.fluroCnParamsEncode(desc);
    return Application.router.navigateTo(context,
        Routes.ymxiangqing + "?oid=$oid&name=$names&time=$times&desc=$descs");
  }

  static goAddYmPage(
    BuildContext context,
  ) {
    return Application.router.navigateTo(context, Routes.addym);
  }

  static togoodClassDetailList(
    BuildContext context, [
    String oid,
    String type,
  ]) {
    return Application.router
        .navigateTo(context, Routes.goodsxiangqing + "?oid=$oid&type=$type");
  }

  static toMoreList(BuildContext context, String oid) {
    return Application.router
        .navigateTo(context, Routes.moreList + "?oid=$oid");
  }

  static toMoredetailList(BuildContext context, String oid) {
    return Application.router
        .navigateTo(context, Routes.moredetailList + "?oid=$oid");
  }

  static toShopListPage(
      BuildContext context, String oid, String name, String type) {
    String names = FluroConvertUtils.fluroCnParamsEncode(name);
    return Application.router.navigateTo(
        context, Routes.shopList + "?oid=$oid&name=$names&type=$type");
  }

  static goFreeShippingPage(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.freeShipping + '?type=$type');
  }

  static goShippingHoursePage(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.shippingHourse + '?type=$type');
  }

  static goAddShippingHoursePage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.addShippingHourse + '?objs=$objs');
  }

  static goShangpinguanliPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shangpinguanli);
  }

  static toMyZjPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.zjgl);
  }

  static goTianjiashangpinPage(BuildContext context, [String oid]) {
    return Application.router
        .navigateTo(context, Routes.tianjiashangpin + "?oid=$oid");
  }

  static goAddFreeShippingPage(BuildContext context, [type, id]) {
    return Application.router
        .navigateTo(context, Routes.addFreeShipping + "?type=$type&oid=$id");
  }

  static goYunfeimobanPage(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.yunfeimoban + "?type=$type");
  }

  static goAddAddressPage(BuildContext context, [Map addr]) {
    String addrs = FluroConvertUtils.object2string(addr);
    return Application.router
        .navigateTo(context, Routes.adress + "?addr=$addrs");
  }

  static goNewsDetailPage(BuildContext context, String id) {
    return Application.router
        .navigateTo(context, Routes.newsDetail + "?id=$id");
  }

  static toRealDetailPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.realDetail + "?objs=$objs");
  }

  static toOrderDetail(BuildContext context, [Map obj, String type]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.orderDetail + "?objs=$objs&type=$type");
  }

  static goLogistics(BuildContext context, String orderId) {
    return Application.router
        .navigateTo(context, Routes.logistics + "?orderId=$orderId");
  }

  static goComment(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.comment + "?objs=$objs");
  }

  static goAllComment(BuildContext context, String goodsId) {
    return Application.router
        .navigateTo(context, Routes.allComment + "?goodsId=$goodsId");
  }

  static goCouponRulePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.couponRule);
  }

  static goSetStoreName(BuildContext context, [String name]) {
    String names = FluroConvertUtils.fluroCnParamsEncode(name);
    return Application.router
        .navigateTo(context, Routes.setStoreName + '?name=$names');
  }

  static goSetStoreDesc(BuildContext context, [String desc]) {
    String descs = FluroConvertUtils.fluroCnParamsEncode(desc);
    return Application.router
        .navigateTo(context, Routes.setStoreDesc + '?desc=$descs');
  }

  static goAddShopDetails(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.addShopDetails + "?objs=$objs");
  }

  static goAddShopFormate(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.addShopFormate + "?objs=$objs");
  }

  static goAddFreight(BuildContext context, [String id]) {
    return Application.router
        .navigateTo(context, Routes.addFreight + "?id=$id");
  }

  static goAboutUs(BuildContext context) {
    return Application.router.navigateTo(context, Routes.aboutUs);
  }

  static goAgreement(BuildContext context, [String type]) {
    return Application.router
        .navigateTo(context, Routes.agreement + "?type=$type");
  }

  static goOpenZhibo(BuildContext context,
      [Map live, Map liveUrl, bool replace]) {
    String lives = FluroConvertUtils.object2string(live);
    String liveUrls = FluroConvertUtils.object2string(liveUrl);
    Application.router.navigateTo(
        context, Routes.openZhibo + "?lives=$lives&liveUrls=$liveUrls",
        replace: replace != null ? true : false);
  }

  static goLookZhibo(BuildContext context, [oid, Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.lookZhibo + "?oid=$oid&objs=$objs");
  }

  static goStoreCouponPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.storeCouponPage);
  }

  static goAddCouponPage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.addCouponPage);
  }

  static goMyChooseGoodsPage(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.myGoods + "?objs=$objs");
  }

  static goSendShopPage(BuildContext context, id) {
    return Application.router.navigateTo(context, Routes.sendShop + "?oid=$id");
  }

  static goStoreCustomerServicePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.storeCustomerService);
  }

  static goStoreCustomerDetailsPage(BuildContext context, String oid) {
    return Application.router
        .navigateTo(context, Routes.storeCustomerDetails + '?oid=$oid');
  }

  static goSendBackPage(BuildContext context, String oid) {
    return Application.router
        .navigateTo(context, Routes.sendBackPage + '?oid=$oid');
  }

  static goLiveDetails(BuildContext context, String oid) {
    return Application.router
        .navigateTo(context, Routes.liveDetails + "?oid=$oid");
  }

  static goLiveOverPage(BuildContext context, oid, [type]) {
    return Application.router
        .navigateTo(context, Routes.liveOver + "?oid=$oid&type=$type");
  }

  static toYunPage(BuildContext context, id) {
    return Application.router.navigateTo(context, Routes.yunPage + "?id=$id");
  }

  static toShengZhangPage(BuildContext context, id) {
    return Application.router
        .navigateTo(context, Routes.shengzhang + "?id=$id");
  }

  static toYimiaoPage(BuildContext context, id) {
    return Application.router.navigateTo(context, Routes.yimiao + "?id=$id");
  }

  static goInformationLivePage(BuildContext context, oid, type) {
    return Application.router.navigateTo(
        context, Routes.informationLivePage + "?oid=$oid&type=$type");
  }

  static goDetailOrdersPage(BuildContext context, Map obj, String type) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.orderDetails + "?objs=$objs&type=$type");
  }

  static goQuestionDetails(BuildContext context, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.questionsDetails + "?objs=$objs");
  }

  static goLiveStore(BuildContext context, oid) {
    return Application.router
        .navigateTo(context, Routes.liveStore + "?oid=$oid");
  }

  static goService(BuildContext context, token) {
    return Application.router
        .navigateTo(context, Routes.service + "?token=$token");
  }

  static goGift(BuildContext context, roomId) {
    return Application.router
        .navigateTo(context, Routes.gift + '?roomId=$roomId');
  }

  static goReplayDetails(BuildContext context, oid) {
    return Application.router
        .navigateTo(context, Routes.replayDetails + "?oid=$oid");
  }

  static goBamaiList(BuildContext context) {
    return Application.router.navigateTo(context, Routes.baimaiList);
  }

  static goBamaiOrderList(BuildContext context) {
    return Application.router.navigateTo(context, Routes.baimaOrderiList);
  }

// 种草
  static goAddGrassPage(BuildContext context, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.addGrass + "?objs=$objs");
  }

  static goAddGrassVideo(BuildContext context, Map obj) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.addGrassVideo + "?objs=$objs");
  }

  static goGroupDetailsPage(BuildContext context, oid) {
    return Application.router
        .navigateTo(context, Routes.groupDetails + "?oid=$oid");
  }

  static toBaMaiXiangQing(BuildContext context, [String oid, String type]) {
    return Application.router
        .navigateTo(context, Routes.bmxiangqing + "?oid=$oid&type=$type");
  }

  static goBmOrder(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router
        .navigateTo(context, Routes.bmOrder + "?objs=$objs");
  }

  static goTeam(BuildContext context) {
    return Application.router.navigateTo(context, Routes.team);
  }

  static goBoshang(BuildContext context, String type, String nums) {
    return Application.router
        .navigateTo(context, Routes.boshang + "?type=$type&nums=$nums");
  }

  static goQuanxian(BuildContext context) {
    return Application.router.navigateTo(context, Routes.quanxian);
  }

  static goPayhhr(BuildContext context) {
    return Application.router.navigateTo(context, Routes.payhhr);
  }

  static goShengjihhr(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shengjihhr);
  }

  static goIntegral(BuildContext context) {
    return Application.router.navigateTo(context, Routes.integral);
  }

  static gobmlist(BuildContext context) {
    return Application.router.navigateTo(context, Routes.bmlist);
  }

  static goFoodclass(BuildContext context) {
    return Application.router.navigateTo(context, Routes.foodclass);
  }

  static goFoodDetails(BuildContext context, String foodId) {
    return Application.router
        .navigateTo(context, Routes.fooddetails + "?foodId=$foodId");
  }

  static goFoodsearch(BuildContext context) {
    return Application.router.navigateTo(context, Routes.foodsearch);
  }

  static goBooksearch(BuildContext context) {
    return Application.router.navigateTo(context, Routes.booksearch);
  }

  static goFoodyuanze(BuildContext context, String babyId) {
    return Application.router
        .navigateTo(context, Routes.foodyuanze + "?babyId=$babyId");
  }

  static goFoodyuanzedetails(BuildContext context, String knowId) {
    return Application.router
        .navigateTo(context, Routes.foodyuanzedetails + "?knowId=$knowId");
  }

  static goFoodAll(BuildContext context) {
    return Application.router.navigateTo(context, Routes.foodall);
  }

  static goFoodList(BuildContext context, String foodId) {
    return Application.router
        .navigateTo(context, Routes.foodlist + "?foodId=$foodId");
  }

  static goWiki(BuildContext context) {
    return Application.router.navigateTo(context, Routes.wiki);
  }

  static goWikilist(BuildContext context, String bookId) {
    return Application.router
        .navigateTo(context, Routes.wikilist + "?bookId=$bookId");
  }

  static goWikidetails(BuildContext context, bookId) {
    return Application.router
        .navigateTo(context, Routes.wikidetails + "?bookId=$bookId");
  }

  static goWikiall(BuildContext context) {
    return Application.router.navigateTo(context, Routes.wikiall);
  }

  static goBabymusic(BuildContext context) {
    return Application.router.navigateTo(context, Routes.music);
  }

  static goBabyMy(BuildContext context) {
    return Application.router.navigateTo(context, Routes.babyMy);
  }

  static goBabyMyQuestion(BuildContext context, oid) {
    return Application.router
        .navigateTo(context, Routes.babyMyQuestion + "?oid=$oid");
  }

  static goBabyMyFb(BuildContext context) {
    return Application.router.navigateTo(context, Routes.babyMyFb);
  }

  static goWikiTj(BuildContext context, String bookId) {
    return Application.router
        .navigateTo(context, Routes.wikitj + "?bookId=$bookId");
  }

  static goXieYiPage(BuildContext context, String type) {
    /// Routes.home 路由地址
    /// replace：true 就是将 splash 页面给移除掉了，这点后退键的时候就不会再出现Splash页面
    Application.router.navigateTo(context, Routes.xieYi + "?type=$type");
  }

  static void goMemberRechargePage(BuildContext context) {
    Application.router.navigateTo(context, Routes.memberRechargePage);
  }
}
