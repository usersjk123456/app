class Api {
  // static const String BASE_URL = 'http://192.168.3.107:19999';
  // https://yunzhonghulu.cn
  static const String BASE_URL = 'http://api.jxhc-net.com';
  static const String BIND_SHANGJI =
      BASE_URL + '/server/login/bindshangji'; //绑定上级
  static const String WX_LOGIN_URL = BASE_URL + '/server/login/wxlogin'; //微信登录
  static const String LOGIN_URL = BASE_URL + '/server/login/login'; //手机号登录
  static const String SHORT_MESSAGE_URL =
      BASE_URL + '/server/login/sendsms'; //短信
  static const String SET_LOCATION_URL =
      BASE_URL + '/server/login/location'; //定位
  static const String PAY_STATUS_URL = BASE_URL + '/server/notify/pay'; //支付轮询
  static const String PAY_CWTS_URL = BASE_URL + '/server/notify/pay'; //成为推手
  static const String USER_FOLLOW_URL =
      BASE_URL + '/server/baby/userfollow'; //  关注
  static const String USER_FANS_URL = BASE_URL + '/server/baby/userfans'; // 粉丝
  static const String GET_OSS_INFO_URL =
      BASE_URL + '/server/img/uploadtoken'; //OSS图片直传
  static const String HOME_URL = BASE_URL + '/server/index/index'; //首页
  static const String WEEK_URL = BASE_URL + '/server/baby/getweek'; //首页
  static const String BANNER_IMAGES = BASE_URL + '/server/live/classBanner';
  static const String BABY_URL =
      BASE_URL + '/server/baby/getonebabyinfo'; //获取宝宝信息
  static const String BABYCHANGE_URL =
      BASE_URL + '/server/baby/getbabychange'; //获取宝宝信息
  static const String CLASS_URL = BASE_URL + '/server/baby/getclasslist'; //橙子教室
  static const String ORANGELIST_URL =
      BASE_URL + '/server/index/category'; //橙子教室分类
  static const String HOME_RECOMMEND =
      BASE_URL + '/server/index/tuijianlist'; //推荐列表
  static const String Home_SALE_LIST_URL =
      BASE_URL + '/server/index/sale-goods'; //特卖列表
  static const String FENLEI_LIST_URL =
      BASE_URL + '/server/index/category'; //一级分类
  static const String ORANGEFENLEI_LIST_URL =
      BASE_URL + '/server/baby/getclasslist'; //橙子教室一级分类
  static const String GOODS_LIST_URL =
      BASE_URL + '/server/index/cate-goods-list'; //商品列表
  static const String SC_LIST_URL =
      BASE_URL + '/server/baby/mycollection'; //我的收藏
  static const String UP_GOODS_URL = BASE_URL + '/server/index/up'; //首页商品上下架
  static const String GET_KEYWORDS_URL =
      BASE_URL + '/server/index/get-keywords'; //获取搜索关键字
  static const String SEARCH_URL = BASE_URL + '/server/index/search'; //获取搜索关键字
  static const String YUNSEARCH_URL =
      BASE_URL + '/server/baby/getalbuminfo'; //获取搜索关键字
  static const String SEARCH_LIVE_URL =
      BASE_URL + '/server/live/livesearch'; //获取搜索关键字
  static const String LIVE_LIST =
      BASE_URL + '/server/index/livelist'; //获取首页直播列表
  static const String SEND_PLANT_URL = BASE_URL + '/server/plant/send'; //发布种草
  static const String GROUP_DETAILS_URL =
      BASE_URL + '/server/plant/topic'; //种草小组
  static const String GET_PLANT_URL = BASE_URL + '/server/plant/index'; //种草首页
  static const String GOODS_DETAIL_URL =
      BASE_URL + '/server/goods/detail'; //商品详情
  static const String HKGOODS_DETAIL_URL =
      BASE_URL + '/server/baby/getclassdetail'; //好课推荐商品详情
  static const String GET_COMMENT =
      BASE_URL + '/server/goods/getgoodscomment'; //评价列表
  static const String RECOMMEND_LIST_URL =
      BASE_URL + '/server/goods/recommend-list'; //推荐商品列表
  static const String GET_ORDER_URL =
      BASE_URL + '/server/goods/get-order'; //获取订单列表
  static const String PAY_ORDER_URL =
      BASE_URL + '/server/goods/create-order2'; //获取提交订单
  static const String BUYCLASS_URL = BASE_URL + '/server/baby/buyclass'; //购买课程
  static const String TEACHER_URL = BASE_URL + '/server/baby/teacher'; //老师二维码
  static const String ADD_CART_URL =
      BASE_URL + '/server/goods/add-cart'; //加入购物车
  static const String CART_LIST_URL = BASE_URL + '/server/index/cart'; //购物车列表
  static const String CART_CHANGE_URL =
      BASE_URL + '/server/goods/save-cart'; //修改购物车数量
  static const String CART_DEL_URL =
      BASE_URL + '/server/goods/del-cart'; //删除购物车
  static const String SHARE_GOODS_URL =
      BASE_URL + '/server/goods/sharegoods'; //分享
  static const String CONTACT_SERVICE_URL =
      BASE_URL + '/server/goods/kefu-weixin'; //获取客服微信
  static const String GET_ROOM_COUPON =
      BASE_URL + '/server/store/get-room-coupon'; //获取直播间优惠券列表
  static const String SEND_COUPON =
      BASE_URL + '/server/store/send-coupon'; //发送直播间优惠券
  static const String LUNXUN = BASE_URL + '/server/store/lunxun'; //优惠券轮训
  static const String ROB_COUPON = BASE_URL + '/server/store/rob'; //用户领取优惠券
  static const String USER_RUL = BASE_URL + '/server/per/index'; //用户信息
  static const String VIP_RUL = BASE_URL + '/server/baby/getvip'; //获取VIP金额
  static const String ORDER_LIST_URL =
      BASE_URL + '/server/per/order-list'; //用户订单
  static const String DEL_ORDER_URL = BASE_URL + '/server/per/del-order'; //删除订单
  static const String CANCEL_ORDER_URL =
      BASE_URL + '/server/per/cancel-order'; //取消订单
  static const String CONFIG_ORDER_URL =
      BASE_URL + '/server/per/confirm-receipt'; //确认收货
  static const String ADDRESS_URL =
      BASE_URL + '/server/per/address-list'; //用户地址列表
  static const String INOCU_URL =
      BASE_URL + '/server/baby/inoculation'; //添加疫苗列表
  static const String ADDALBUM_URL = BASE_URL + '/server/baby/addalbum'; //添加云相册

  static const String YM_URL = BASE_URL + '/server/baby/vaccineslist'; //疫苗列表
  static const String BUYLIST_URL = BASE_URL + '/server/baby/userclass'; //已购课程
  static const String SWITCH_URL = BASE_URL + '/server/index/switch'; //全程显示开关
  
  static const String BUYVIP_URL = BASE_URL + '/server/baby/buyvip'; //已购vip
  static const String YUN_URL = BASE_URL + '/server/baby/getalbumcount'; //获取云相册
  static const String SHENGZHANG_URL =
      BASE_URL + '/server/baby/growthRecord'; //生长记录列表
  static const String EVENTLIST_URL =
      BASE_URL + '/server/baby/eventlist'; //大事记列表
  static const String BABY_LIST = BASE_URL + '/server/baby/getinfo'; //宝宝列表
  static const String DEL_ADDRESS_URL =
      BASE_URL + '/server/per/del-address'; //删除用户地址
  static const String DEL_GROWTHRECORD_URL =
      BASE_URL + '/server/baby/delGrowthRecord'; //删除成长记录
  static const String ADDRESS_DETAILS_URL =
      BASE_URL + '/server/per/del-address'; //获取地址详情
  static const String ADD_ADDRESS_URL =
      BASE_URL + '/server/per/add-address'; //添加地址
  static const String EDIT_ADDRESS_URL =
      BASE_URL + '/server/per/edit-address'; //编辑地址
  static const String EXCHANGE_COUPON_URL =
      BASE_URL + '/server/per/exchange-coupon'; //兑换优惠券
  static const String COUPON_LIST_URL =
      BASE_URL + '/server/per/coupon-list'; //优惠券列表
  static const String COUPON_RULE_URL =
      BASE_URL + '/server/per/coupon-coin'; //优惠券规则
  static const String COIN_LIST_URL = BASE_URL + '/server/per/coin-list'; //蜂币列表
  static const String REALNAME_LIST_URL =
      BASE_URL + '/server/per/realname-list'; //实名列表
  static const String ADD_REALNAME_URL =
      BASE_URL + '/server/per/add-realname'; //添加实名
  static const String BABY_INFO = BASE_URL + '/server/baby/setinfo'; //宝宝详情
  static const String GROWTH_RECORD =
      BASE_URL + '/server/baby/addGrowthRecord'; //编辑增加生长记录
  static const String EDIT_REALNAME_URL =
      BASE_URL + '/server/per/edit-realname'; //编辑实名
  static const String DEL_REALNAME_URL =
      BASE_URL + '/server/per/del-realname'; //删除实名
  static const String APPLY_AFTER_URL =
      BASE_URL + '/server/per/apply-after'; //申请售后
  static const String AFTER_LIST_URL =
      BASE_URL + '/server/per/after-list'; //申请售后
  static const String SHOP_RETURN_URL =
      BASE_URL + '/server/per/return-goods'; //商品退回
  static const String ORDER_TOPAY = BASE_URL + '/server/per/to-pay'; //订单去支付
  static const String LOGISTICS = BASE_URL + '/server/per/kd-info'; //物流信息
  static const String SEND_COMMENT =
      BASE_URL + '/server/per/goodscomment'; //发表评论
  static const String BAMAI_INDEX_URL = BASE_URL + '/server/new/index'; //拼团列表
  static const String STORE_HOME_URL =
      BASE_URL + '/server/store/index'; //供货商店铺首页
  static const String STORE_XIEYI_URL =
      BASE_URL + '/server/per/apply'; //供货商入驻协议
  static const String STORE_APPLY_URL =
      BASE_URL + '/server/store/submit'; //供货商申请
  static const String STORE_TYPE_URL =
      BASE_URL + '/server/store/get-type'; //店铺分类
  static const String SET_STORE_NAME_URL =
      BASE_URL + '/server/store/save-store-name'; //店铺名称
  static const String SET_STORE_DESC_URL =
      BASE_URL + '/server/store/save-store-desc'; //店铺描述
  static const String SET_STORE_HEAD_URL =
      BASE_URL + '/server/store/save-store-head'; //店铺头像
  static const String SET_STORE_IMG_URL =
      BASE_URL + '/server/store/save-store-img'; //店铺店招
  static const String STORE_MONEY_URL =
      BASE_URL + '/server/store/get-amount'; //店铺保证金
  static const String STORE_PAY_URL =
      BASE_URL + '/server/store/apply-pay'; //缴纳店铺保证金
  static const String STORE_ORDER_LIST_URL =
      BASE_URL + '/server/store/order-list'; //供货商订单列表
  static const String STORE_SEND_SHOP_URL =
      BASE_URL + '/server/store/deliver-goods'; //供货商发货
  static const String EXPRESS_LIST_URL =
      BASE_URL + '/server/store/get-express'; //快递公司列表
  static const String STORE_AFTER_LIST_URL =
      BASE_URL + '/server/store/after-list'; //售后列表
  static const String STORE_AFTER_DETAILS_URL =
      BASE_URL + '/server/store/after-detail'; //售后详情
  static const String STORE_AFTER_HANDLE_URL =
      BASE_URL + '/server/store/after-handle'; //售后操作
  static const String STORE_GOODS_TYPE_LIST_URL =
      BASE_URL + '/server/store/goods-type'; //供货商商品分类
  static const String ADD_FREIGHT_TEMPLATE_URL =
      BASE_URL + '/server/store/create-template'; //添加运费模板
  static const String EDIT_FREIGHT_TEMPLATE_URL =
      BASE_URL + '/server/store/edit-template'; //编辑运费模板列表
  static const String FREIGHT_TEMPLATE_DETAILS_URL =
      BASE_URL + '/server/store/template-detail'; //运费模板详情
  static const String FREIGHT_TEMPLATE_LIST_URL =
      BASE_URL + '/server/store/template-list'; //运费模板列表
  static const String DEL_FREIGHT_TEMPLATE_URL =
      BASE_URL + '/server/store/del-template'; //删除运费模板
  static const String STORE_FREE_SHIPPING_LIST_URL =
      BASE_URL + '/server/store/full-list'; //满包邮列表
  static const String ADD_FREE_SHIPPING_URL =
      BASE_URL + '/server/store/create-full'; //创建满包邮
  static const String EDIT_FREE_SHIPPING_URL =
      BASE_URL + '/server/store/edit-full'; //编辑满包邮
  static const String FREE_SHIPPING_DETAILS_URL =
      BASE_URL + '/server/store/full-detail'; //满包邮详情
  static const String DEL_FREE_SHIPPING_URL =
      BASE_URL + '/server/store/del-full'; //满包邮详情
  static const String SHIPPING_HOURSE_LIST_URL =
      BASE_URL + '/server/store/house-list'; //发货仓列表
  static const String ADD_SHIPPING_HOURSE_URL =
      BASE_URL + '/server/store/create-house'; //创建发货仓
  static const String EDIT_SHIPPING_HOURSE_URL =
      BASE_URL + '/server/store/edit-house'; //编辑发货仓
  static const String DEL_SHIPPING_HOURSE_URL =
      BASE_URL + '/server/store/del-house'; //删除发货仓
  static const String STORE_CREATE_SHOP_URL =
      BASE_URL + '/server/store/create-goods'; //上架商品
  static const String EDIT_STORE_SHOP_URL =
      BASE_URL + '/server/store/edit-goods'; //编辑上架商品
  static const String STORE_SHOP_LIST_URL =
      BASE_URL + '/server/store/goods-list'; //上架商品列表
  static const String STORE_SHOP_DETAIL_URL =
      BASE_URL + '/server/store/edit-goods-detail'; //上架商品详情
  static const String DEL_SHOP_LIST_URL =
      BASE_URL + '/server/store/del-goods'; //删除上架商品列表
  static const String UP_SHOP_URL = BASE_URL + '/server/store/up-goods'; //上架商品
  static const String CREATE_COUPON_URL =
      BASE_URL + '/server/store/create-coupon'; //增加优惠券
  static const String ADD_COUPON_NUM_URL =
      BASE_URL + '/server/store/add-coupon'; //增加优惠券数量
  static const String STORE_COUPON_LIST_URL =
      BASE_URL + '/server/store/coupon-list'; //优惠券列表
  static const String STORE_FANS_LIST_URL =
      BASE_URL + '/server/store/fanslist'; //粉丝数
  static const String STORE_MESSAGE_URL =
      BASE_URL + '/server/store/my-store'; //店铺管理
  static const String STORE_SEND_MATERIAL_URL =
      BASE_URL + '/server/store/send-material'; //店铺管理发布素材
  static const String STORE_CHOICE_URL =
      BASE_URL + '/server/store/storejingxuan'; //店铺管理店铺精选
  static const String STORE_DEL_UP_GOODS_URL =
      BASE_URL + '/server/store/del-up-goods'; //店铺管理店铺删除上架商品

  static const String STORE_ALL_URL =
      BASE_URL + '/server/store/storejingxuanall'; //店铺精选

  static const String UPLOAD_IMG_URL = BASE_URL + '/server/img/upload'; //上传图片

  static const String NEWS_LIST = BASE_URL + '/server/index/news'; //消息中心
  static const String NEWS_DETAIL =
      BASE_URL + '/server/index/news-detail'; //消息详情
  static const String PERSONAL_DATA =
      BASE_URL + '/server/login/loaduser'; //个人资料
  static const String SET_WXIMG =
      BASE_URL + '/server/per/set-wxqrcode'; //修改微信名片
  static const String SET_AVATAR =
      BASE_URL + '/server/per/set-headimgurl'; //修改头像
  static const String CHANGE_WX = BASE_URL + '/server/per/bind-wechat'; //更换绑定微信
  static const String CHANGE_PHONE =
      BASE_URL + '/server/per/bind-phone'; //更换绑定手机号
  static const String CHECK_PHONE = BASE_URL + '/server/login/checkmsm'; //验证手机号

  static const String LOG_OFF = BASE_URL + '/server/per/clear-account'; //注销账号
  static const String ABOUT = BASE_URL + '/server/per/about'; //关于我们
  static const String SET_NICKNAME_URL =
      BASE_URL + '/server/per/set-nickname'; //修改昵称
  static const String OPEN_LIVE = BASE_URL + '/server/per/open-anchor'; //开通直播权限
  static const String GET_LIVE_TYPE =
      BASE_URL + '/server/store/get-live-type'; //直播分类
  static const String GET_USER_GOODS =
      BASE_URL + '/server/store/get-user-goods'; //获取直播带货商品
  static const String CREATE_LIVE =
      BASE_URL + '/server/store/create-live'; //创建直播
  static const String START_LIVE =
      BASE_URL + '/server/store/start-live'; //开始直播推流
  static const String CLOSE_LIVE = BASE_URL + '/server/store/end-live'; //结束直播推流
  static const String CREATE_NOTICE =
      BASE_URL + '/server/store/create-notice'; //创建预告
  static const String EXTEND_ORDER =
      BASE_URL + '/server/store/tuiguangorder'; //推广订单
  static const String GET_HELP = BASE_URL + '/server/store/help'; //易匠学院
  static const String MATERIAL_MANAGE =
      BASE_URL + '/server/store/material'; //素材管理
  static const String GUEST_MANAGE = BASE_URL + '/server/store/guest'; //访客管理
  static const String DIAMOND_URL = BASE_URL + '/server/store/diamond'; //钻石转向
  static const String CREATE_KF = BASE_URL + '/server/store/create-kf'; //创建客服
//直播
  static const String LIVE_RECOMMEND =
      BASE_URL + '/server/live/tuijianlist'; //推荐列表
  static const String GET_LIVE_LIST = BASE_URL + '/server/live/index'; //直播列表
  // static const String CLICK_SHARE = BASE_URL + '/server/live/share'; //直播点击分享
  static const String CLICK_SHARE =
      BASE_URL + '/server/live/sharelive'; //直播点击分享(生成二维码)
  static const String SHARE_NUM = BASE_URL + '/server/live/share'; //统计分享次数
  static const String CLICK_SHOP =
      BASE_URL + '/server/live/click'; // //统计直播间点击物品次数
  static const String MINE_BALANCE_URL =
      BASE_URL + '/server/per/balance'; //消费记录1
  static const String MINE_BONUS_URL =
      BASE_URL + '/server/new/jifenlist'; //奖金记录1
  static const String TO_CASH_URL = BASE_URL + '/server/per/to-cash'; //申请提现
  static const String CASH_LOG_URL = BASE_URL + '/server/per/cash-log'; //申请记录
  static const String DELE_LIVE = BASE_URL + '/server/store/del-live'; //删除直播
  static const String MY_LIVE = BASE_URL + '/server/store/live-list'; //我的直播列表
  static const String DELE_NOTICE =
      BASE_URL + '/server/store/del-notice'; //删除预告
  static const String MY_NOTICE =
      BASE_URL + '/server/store/notice-list'; //我的预告列表
  static const String SHARE_LIVE_URL =
      BASE_URL + '/server/live/sharelive'; //分享直播间
  static const String CREATE_RULE = BASE_URL + '/server/live/zhiborule'; //创建规则
  static const String LIVE_STORE_RULE = BASE_URL + '/server/live/store'; //直播商品
  static const String LIVE_GIFT_RULE = BASE_URL + '/server/live/gift'; //直播礼物列表
  static const String LIVE_ANCHOR_RULE =
      BASE_URL + '/server/live/anchor'; //获取主播信息
  static const String LIVE_FOLLOW_RULE = BASE_URL + '/server/live/follow'; //关注
  static const String LIVE_BANNER_RULE =
      BASE_URL + '/server/live/banner'; //直播banner
  static const String LIVE_HOT_LIST_RULE =
      BASE_URL + '/server/live/hot-list'; //直播热销商品
  static const String LIVE_CATE_RULE = BASE_URL + '/server/live/cate'; //直播分类
  static const String LIVE_IN_ROOM_RULE =
      BASE_URL + '/server/live/in-room'; //进入直播房间,获取推流地址
  static const String LIVE_THE_LIST_RULE =
      BASE_URL + '/server/live/the-list'; //送礼列表
  static const String LIVE_GOODS =
      BASE_URL + '/server/store/live-goods'; //主播商品列表
  static const String LIVE_GOODS_DO =
      BASE_URL + '/server/store/live-goods-do'; //主播商品上下架
  static const String LIVE_SHOP_BAG =
      BASE_URL + '/server/live/shop-bag'; //用户端商品展示
  static const String VIDEO_HISTORY_URL =
      BASE_URL + '/server/store/huifanglist'; //主播直播回放列表
  static const String ROOM_DETAILS_URL =
      BASE_URL + '/server/live/liveroomdetail'; //直播间详情
  static const String LIVE_REPORT_URL =
      BASE_URL + '/server/live/report'; //直播间举报
  static const String LIVE_FOLLOW_URL = BASE_URL + '/server/live/follow'; //关注
  static const String VIDEO_LIKE_URL = BASE_URL + '/server/video/like'; //点赞
  static const String VIDEO_COMMENT_URL =
      BASE_URL + '/server/video/comment'; //评论
  static const String VIDEO_COMMENT_LIST_URL =
      BASE_URL + '/server/video/comment-list'; //评论
  static const String NOTICE_LIVE_URL =
      BASE_URL + '/server/live/noticelive'; //预约直播间
  static const String BEGIN_LIVE_URL =
      BASE_URL + '/server/store/start-live'; //预约开始直播
  static const String OFFLINE = BASE_URL + '/server/live/xiaonline'; //观众离开直播间
  static const String REPLAY_DETAILS_URL =
      BASE_URL + '/server/store/live-detail'; //回访详情

  static const String PLANT_SHARE_URL = BASE_URL + '/server/plant/share'; //种草分享
  static const String VIDEO_TYPE_RULE =
      BASE_URL + '/server/video/get-type'; //短视频分类
  static const String VIDEO_TYPE =
      BASE_URL + '/server/video/get-createtype'; //上传短视频分类
  static const String VIDEO_LIST_RULE =
      BASE_URL + '/server/video/index'; //短视频列表
  static const String VIDEO_LIST =
      BASE_URL + '/server/video/getvideo'; //短视频滑动列表
  static const String GET_TOKEN_RULE =
      BASE_URL + '/server/video/gettoken'; //获取token
  static const String CREATE_SHORT_VIDEO =
      BASE_URL + '/server/video/createVideo'; //创建短视频
  static const String MY_VIDEO_LIST =
      BASE_URL + '/server/video/videoList'; //我的短视频
  static const String DEL_MY_VIDEO =
      BASE_URL + '/server/video/delVideo'; //删除短视频
  static const String CHECK_BALANCE =
      BASE_URL + '/server/live/checkbalance'; //发送礼物检查余额
  static const String RECHARGE = BASE_URL + '/server/goods/rechargeRuleList'; //充值列表
  static const String TO_RECHARGE = BASE_URL + '/server/live/toRechargeBalance'; //充值
  static const String GIFT_LIST = BASE_URL + '/server/live/giftlist'; //礼物列表

  // 工匠端
  static const String GET_PROCLASS_LIST_RULE =
      BASE_URL + '/server/gongjiang/proclasslist'; //维修类型列表
  static const String WX_ORDER_RULE =
      BASE_URL + '/server/gongjiang/wxorder'; //维修下单
  static const String AZ_ORDER_RULE =
      BASE_URL + '/server/gongjiang/azorder'; //安装下单
  static const String JIEDAN_LIST_RULE =
      BASE_URL + '/server/gongjiang/jiedanlist'; //接单列表
  static const String SEND_ORDER_LIST =
      BASE_URL + '/server/gongjiang/fadanlist'; //已发维修
  static const String APPLY_WX_RULE =
      BASE_URL + '/server/gongjiang/addweixiuren'; //申请维修人
  static const String JIEDAN_CONFIG_RULE =
      BASE_URL + '/server/gongjiang/azjiedan'; //接单
  static const String GET_ORDER_LIST =
      BASE_URL + '/server/gongjiang/jiedanlists'; //接单（维修、安装）
  static const String APPLY_REFOUND_URL =
      BASE_URL + '/server/gongjiang/tkapply'; //申请退款
  static const String REFOUND_DETAILS_URL =
      BASE_URL + '/server/gongjiang/tkinfo'; //退款详情
  static const String GET_MISS_ORDER_URL =
      BASE_URL + '/server/gongjiang/cuoguo'; //错过订单
  static const String QUESTGION_LIST_RULE =
      BASE_URL + '/server/gongjiang/aqlist'; //常见问题
  static const String CHANGE_STATUS =
      BASE_URL + '/server/gongjiang/orderstate'; //修改订单状态
  static const String BAMAIPAY_URL =
      BASE_URL + '/server/new/createbamai'; //拼团支付
  static const String BAMAI_DETAILS_URL =
      BASE_URL + '/server/new/bamaidetail'; //拼团详情
  static const String BAMAIORDER_URL =
      BASE_URL + '/server/new/bamaiorder'; //拼团下单
  static const String TEAM_URL = BASE_URL + '/server/new/myteam'; //我的团队
  static const String SHENGJI_HEHUOREN_URL =
      BASE_URL + '/server/new/shengjihehuoren'; //升级播商服务商
  static const String TEAM_LIST_URL =
      BASE_URL + '/server/new/myteamlist'; //我的团队列表
  static const String ZENGSONG_LIST_URL =
      BASE_URL + '/server/new/zengsonglist'; //赠送权限列表
  static const String APPLY_HEHUOREN_URL =
      BASE_URL + '/server/new/shenqinghehuoren'; //申请播商服务商
  static const String ZENGSONG_URL =
      BASE_URL + '/server/new/zengsongzhubo'; //赠送权限
  static const String INTERGRAL_LIST_URL =
      BASE_URL + '/server/new/jifenlist'; //积分列表
  static const String LUNXUN_URL = BASE_URL + '/server/new/lunxun'; //首页中奖轮训

  static const String BAMAI_LIST_URL =
      BASE_URL + '/server/per/bamai-order-list'; //拼团记录

  static const String FOODXZS_LIST_URL =
      BASE_URL + '/server/per/bamai-order-list'; //辅食小知识
  static const String FOODSP_URL = BASE_URL + '/server/baby/foodtype'; //辅食食谱分类
  static const String FOODSP_LIST_URL =
      BASE_URL + '/server/baby/foodknowledge'; //辅食食谱分类子列表
  static const String FOODCD_List_URL =
      BASE_URL + '/server/baby/foodlist'; //辅食食谱列表

  static const String GET_BABY_URL =
      BASE_URL + '/server/baby/getonebabyinfo'; // 获取宝宝信息

  static const String FOODDETAILS_URL =
      BASE_URL + '/server/baby/fooddetails'; // 食谱详情

  static const String FOODKONW_URL =
      BASE_URL + '/server/baby/onefoodknowledge'; // 小知识详情

  static const String VISITSFOOD_URL =
      BASE_URL + '/server/baby/visitsfood'; // 食谱统计

  static const String FKVISITS_URL =
      BASE_URL + '/server/baby/fkvisits'; // 小知识统计

  static const String LIKE_URL =
      BASE_URL + '/server/baby/likefoodknowledge'; // 点赞

  static const String COLLECTION_URL =
      BASE_URL + '/server/baby/fkcollection'; // 收藏

  static const String BABY_FS_URL =
      BASE_URL + '/server/baby/explainlist'; // 宝贝辅食说明

  static const String BAIKE_URL =
      BASE_URL + '/server/baby/getetypeone'; // 百科二级三级列表

  static const String BOOK_TJ_URL =
      BASE_URL + '/server/baby/gettuijian'; // 推荐阅读列表

  static const String BOOK_LIST_URL =
      BASE_URL + '/server/baby/getetypethree'; // 书籍列表

  static const String TJBOOK_DETAILS_URL =
      BASE_URL + '/server/baby/gettuijiandetaile'; // 推荐书籍列表内容

  static const String BOOK_DETAILS_URL =
      BASE_URL + '/server/baby/getencyclopedia'; // 书籍内容

  static const String GET_MUSIC_URL =
      BASE_URL + '/server/baby/getmusic'; // 获取音乐分类及音乐

  static const String GET_BOOKSEARCH_URL =
      BASE_URL + '/server/baby/souchencyclopedia'; // 百科搜索

  static const String GET_QUESTION_URL =
      BASE_URL + '/server/baby/problemlist'; // 话题列表
  static const String GET_ANSWERLIST_URL =
      BASE_URL + '/server/baby/answerlist'; //评论话题列表

  static const String GET_MY_QUESTION_URL =
      BASE_URL + '/server/baby/myproblemlist'; //我的话题列表

  static const String GET_MY_ANSWER_URL =
      BASE_URL + '/server/baby/myanswerlist'; //我的问题列表

  static const String ANSWER_URL = BASE_URL + '/server/baby/answer'; //评论点赞问题

  static const String SEND_PROBLEM_URL =
      BASE_URL + '/server/baby/sendproblem'; //发布问题

  static const String DEL_QUESTION_URL =
      BASE_URL + '/server/baby/delproblem'; //删除我的问题

  static const String GET_LABEL_URL =
      BASE_URL + '/server/baby/getlabel'; //获取大事记标签

  static const String ADD_BABYEVENT_URL =
      BASE_URL + '/server/baby/addevent'; //添加大事记

  static const String GET_BABY_LIST_URL =
      BASE_URL + '/server/baby/eventlist'; //获取大事记列表(和详情)

  static const String DEL_BABYEVENT_URL =
      BASE_URL + '/server/baby/delevent'; //删除大事记

  static const String PL_BABYEVENT_URL =
      BASE_URL + '/server/baby/commentevent'; //评论大事记

  static const String DEL_PL_BABYEVENT_URL =
      BASE_URL + '/server/baby/delcommentevent'; //删除评论大事记

  static const String ROON_DETAILS_URL =
      BASE_URL + '/server/live/room-detail'; //直播预告详情
}
