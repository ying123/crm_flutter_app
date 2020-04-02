class Apis {
  /// user
  static const MessageLogin = '/ncrm/message/login'; // 发送验证码
  static const LoginMessage = '/ncrm/login/message'; //手机验证码登录
  static const Logout = '/ncrm/logout'; // 登出
  static const JudgeUser = '/ncrm/judgeUser'; // 判断是否测试账号

  static const ProvinceData = '/ncrm/team/address/province/find/all'; // 获取省份列表
  static const CityData = '/ncrm/team/address/city/find'; // 根据省份获取城市列表
  static const CountryData = '/ncrm/team/address/county/find'; //根据城市获取区县列表

  ///order
  static const OrderList = '/ncrm/order/order/page'; // 订单列表
  static const OrderInfo =
      '/lighter/trackOrder/order/orderDetailBaseInfo'; // 订单基本信息查询
  static const OrderDetail =
      '/lighter/trackOrder/order/orderDetailList'; // 订单明细
  static const OrderProgress = '/lighter/trackOrder/order/partsProgress'; //订单进度
  static const LogisticTrack =
      '/lighter/trackOrder/order/logisticTrack'; // 物流轨迹
  static const ErrorOrderList = '/ncrm/order/order/queryAbnormal'; //异常订单列表

  ///公告
  static const NoticeList = '/ncrm/biz/notice/list'; //公告列表

  ///InvitationCode
  static const TeamReferral = '/ncrm/team/referral'; // 获取用户的邀请码
  static const TeamReferralLogStatistics =
      '/ncrm/team/referral/log/statistics'; // 获取邀请码的使用情况
  static const TeamReferralLogPage =
      '/ncrm/team/referral/log/page'; // 获取邀请码的推广记录

  ///trackOrder
  static const TrackOrderInquiryList = '/ncrm/inquiry/page'; // 普通询价单 - 询价单列表
  static const TrackOrderInquiryBaseInfo = '/ncrm/inquiry/info'; // 获取询价单的基本信息
  static const TrackOrderInquiryQuoteDetail =
      '/ncrm/inquiry/detail'; // 获取询价单详情-配件报价信息
  static const Urge = '/ncrm/inquiry/urge'; // 催报价
  // static const Urge = '/lighter/trackOrder/inquiry/urge'; // 催报价
  ///customer
  static const CustomerList = '/ncrm/team/customer/page'; // 客户列表
  static const CustomerDetail = '/ncrm/team/customer'; // 客户信息
  static const CustomerInfo = '/ncrm/team/customer/statistics'; // 客户统计数据
  static const CustomerInfoByOrgId = '/ncrm/team/customer/statisticsOrg';
  static const ContractList = '/ncrm/team/customercontact/page'; //联系人列表
  static const ContractDetail = '/ncrm/team/customercontact'; // 联系人详情
  static const AddContract = '/ncrm/team/customercontact'; //添加联系人
  static const EditContract = '/ncrm/team/customercontact'; //编辑联系人

  // 发票
  static const InvoiceList = '/ncrm/biz/invoice/list'; // 查询客户的发票列表
  static const InvoiceDetail = '/ncrm/biz/invoice/detail'; // 查询客户的发票明细
  static const InvoiceRefundDetail = '/ncrm/biz/invoice/refund'; // 发票退款明细

  ///派券
  static const CouponsRuleList =
      '/ncrm/team/coupon/rule/list'; // 查询用户创建的优惠卷规则列表
  static const CreateCouponsRule = '/ncrm/team/coupon/rule'; // 创建优惠卷规则
  static const EnableCoupons = '/ncrm/team/coupon/rule/enable'; // 启用优惠券规则
  static const DisableCoupons = '/ncrm/team/coupon/rule/disable'; // 停用优惠卷规则
  static const GiveCoupons = '/ncrm/team/coupon'; // 派发优惠券
  static const FactoryList = '/ncrm/team/customer/list'; // 加载汽修厂列表
  static const CouponsTable = '/ncrm/team/coupon/rule/statistics'; // 派券报表
  static const CouponsRecords = '/ncrm/team/coupon/list'; // 派券记录
  static const WithdrawCoupons = '/ncrm/team/coupon/'; // 撤回

  ///退换货
  static const returnList = '/lighter/afterSaleCheck/returnGoods/checkList';
  static const exchangeList = '/lighter/afterSaleCheck/exchangeGoods/checkList';
  static const returnDetails = '/lighter/afterSaleCheck/returnGoods/detail';
  static const submitAudit = '/lighter/afterSaleCheck/returnGoods/submitAudit';
  static const exchangeDetails = '/lighter/afterSaleCheck/exchangeGoods/detail';
  static const submitExAudit =
      '/lighter/afterSaleCheck/exchangeGoods/submitAudit';
  static const hasAuthorization =
      '/lighter/afterSaleCheck/statistics/hasAuthorization';

  static const teamStatisticList =
      '/lighter/afterSaleCheck/statistics/queryTeamStatistic'; //所有团队统计报表
  static const orgStaticsList =
      '/lighter/afterSaleCheck/statistics/queryOrgStatistics'; // 汽修厂统计报表
  static const subteamStatisticList =
      '/lighter/afterSaleCheck/statistics/querySubTeamStatistics'; // 子团队统计报表

  ///预测佣金
  static const commission =
      '/ncrm/order/orderstatistics/commissionforecast'; // 获取预测佣金与盈利佣金
  ///成本保存
  static const saveCost = '/ncrm/team/cost/save';

  ///业绩
  static const achievement = '/ncrm/biz/achievement/detail'; //获取业绩情况
  static const achievementAppeal = '/ncrm/biz/achievement/appeal'; // 申诉
  static const achievementConfirm = '/ncrm/biz/achievement/confirm'; //确认
  static const achievementCost = '/ncrm/team/cost/get'; //支出情况
  static const achievementSubteam = '/ncrm/team/team/getSubTeam'; // 获取子团队列表

  static const tradeAmount =
      '/ncrm/order/orderstatistics/tradeAmount'; //首页交易总金额
  static const permission = '/ncrm/sys/menu/apppermissions'; //获取功能权限

  // 首页
  static const orderTaskCount = '/ncrm/order/order/count'; // 获取订单统计数量
  static const inquryTaskCount = '/ncrm/inquiry/statistics'; // 获取询价单统计详情信息
  static const statisticsCount =
      '/ncrm/team/referral/log/statistics'; // 获取邀请码的使用情况

  static const imInfo = '/ncrm/team/im';
  static const userInfo = '/ncrm/team/user/info';
  // 工单
  static const upload = '/ncrm/biz/jiaxin/file'; //上传图片
  static const workOrderAdd = '/ncrm/biz/jiaxin/order'; // 新增工单
  static const workGoupList = '/ncrm/biz/jiaxin/workGroupList'; // 客服组
  static const workOrderList = '/ncrm/biz/jiaxin/order/list'; // 工单列表
  static const workOrderDetails = '/ncrm/biz/jiaxin/order/detail'; // 工单详情
  static const workOrderRemark = '/ncrm/biz/jiaxin/order/remark'; // 工单备注
}
