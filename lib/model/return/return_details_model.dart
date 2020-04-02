class ReturnDetailsModel {
  AfterSaleCheckDetailDto afterSaleCheckDetailDto;
  FirstResponsibilityDto firstResponsibilityDto;
  ReturnGoodsAuditMoneyDto returnGoodsAuditMoneyDto;
  Null orgReverseStatisticsDto;
  int customerId;

  ReturnDetailsModel(
      {this.afterSaleCheckDetailDto,
      this.firstResponsibilityDto,
      this.returnGoodsAuditMoneyDto,
      this.orgReverseStatisticsDto,
      this.customerId});

  ReturnDetailsModel.fromJson(Map<String, dynamic> json) {
    afterSaleCheckDetailDto = json['after_sale_check_detail_dto'] != null
        ? new AfterSaleCheckDetailDto.fromJson(
            json['after_sale_check_detail_dto'])
        : null;
    firstResponsibilityDto = json['first_responsibility_dto'] != null
        ? new FirstResponsibilityDto.fromJson(json['first_responsibility_dto'])
        : null;
    returnGoodsAuditMoneyDto = json['return_goods_audit_money_dto'] != null
        ? new ReturnGoodsAuditMoneyDto.fromJson(
            json['return_goods_audit_money_dto'])
        : null;
    orgReverseStatisticsDto = json['org_reverse_statistics_dto'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.afterSaleCheckDetailDto != null) {
      data['after_sale_check_detail_dto'] =
          this.afterSaleCheckDetailDto.toJson();
    }
    if (this.firstResponsibilityDto != null) {
      data['first_responsibility_dto'] = this.firstResponsibilityDto.toJson();
    }
    if (this.returnGoodsAuditMoneyDto != null) {
      data['return_goods_audit_money_dto'] =
          this.returnGoodsAuditMoneyDto.toJson();
    }
    data['org_reverse_statistics_dto'] = this.orgReverseStatisticsDto;
    data['customer_id'] = this.customerId;
    return data;
  }
}

class AfterSaleCheckDetailDto {
  int returnId;
  String returnType;
  String returnCode;
  Null returnDetailId;
  var orgId;
  String orgName;
  String contactPerson;
  String contactMobile;
  int orderId;
  String orderNo;
  int supplierId;
  int orderDetailId;
  String payTime;
  double salePrice;
  Null unitPrice;
  double channelPayAmount;
  bool bookInfo;
  double guaranteePeriod;
  bool overGuaranteePeriod;
  String brandName;
  String carBrandName;
  String carSystem;
  String carType;
  String partsName;
  String partsCode;
  int num;
  String createTime;
  String outerPackingPic;
  String productIdentifyPic;
  String problemAreaPic;
  String applyReason;
  String remark;
  bool isPacked;
  bool isOuterPackWell;
  bool isProductIdentifyWell;
  List<String> evidencePicsList;
  Null hasOverOriginPurchasePrice;

  AfterSaleCheckDetailDto(
      {this.returnId,
      this.returnType,
      this.returnCode,
      this.returnDetailId,
      this.orgId,
      this.orgName,
      this.contactPerson,
      this.contactMobile,
      this.orderId,
      this.orderNo,
      this.supplierId,
      this.orderDetailId,
      this.payTime,
      this.salePrice,
      this.unitPrice,
      this.channelPayAmount,
      this.bookInfo,
      this.guaranteePeriod,
      this.overGuaranteePeriod,
      this.brandName,
      this.carBrandName,
      this.carSystem,
      this.carType,
      this.partsName,
      this.partsCode,
      this.num,
      this.createTime,
      this.outerPackingPic,
      this.productIdentifyPic,
      this.problemAreaPic,
      this.applyReason,
      this.remark,
      this.isPacked,
      this.isOuterPackWell,
      this.isProductIdentifyWell,
      this.evidencePicsList,
      this.hasOverOriginPurchasePrice});

  AfterSaleCheckDetailDto.fromJson(Map<String, dynamic> json) {
    returnId = json['return_id'];
    returnType = json['return_type'];
    returnCode = json['return_code'];
    returnDetailId = json['return_detail_id'];
    orgId = json['org_id'];
    orgName = json['org_name'];
    contactPerson = json['contact_person'];
    contactMobile = json['contact_mobile'];
    orderId = json['order_id'];
    orderNo = json['order_no'];
    supplierId = json['supplier_id'];
    orderDetailId = json['order_detail_id'];
    payTime = json['pay_time'];
    salePrice = json['sale_price'];
    unitPrice = json['unit_price'];
    channelPayAmount = json['channel_pay_amount'];
    bookInfo = json['book_info'];
    guaranteePeriod = json['guarantee_period'];
    overGuaranteePeriod = json['over_guarantee_period'];
    brandName = json['brand_name'];
    carBrandName = json['car_brand_name'];
    carSystem = json['car_system'];
    carType = json['car_type'];
    partsName = json['parts_name'];
    partsCode = json['parts_code'];
    num = json['num'];
    createTime = json['create_time'];
    outerPackingPic = json['outer_packing_pic'];
    productIdentifyPic = json['product_identify_pic'];
    problemAreaPic = json['problem_area_pic'];
    applyReason = json['apply_reason'];
    remark = json['remark'];
    isPacked = json['is_packed'];
    isOuterPackWell = json['is_outer_pack_well'];
    isProductIdentifyWell = json['is_product_identify_well'];
    if (json['evidence_pics_list'] != null) {
      evidencePicsList = new List<String>();
      json['evidence_pics_list'].forEach((v) {
        evidencePicsList.add(v);
      });
    }
    hasOverOriginPurchasePrice = json['has_over_origin_purchase_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_id'] = this.returnId;
    data['return_type'] = this.returnType;
    data['return_code'] = this.returnCode;
    data['return_detail_id'] = this.returnDetailId;
    data['org_id'] = this.orgId;
    data['org_name'] = this.orgName;
    data['contact_person'] = this.contactPerson;
    data['contact_mobile'] = this.contactMobile;
    data['order_id'] = this.orderId;
    data['order_no'] = this.orderNo;
    data['supplier_id'] = this.supplierId;
    data['order_detail_id'] = this.orderDetailId;
    data['pay_time'] = this.payTime;
    data['sale_price'] = this.salePrice;
    data['unit_price'] = this.unitPrice;
    data['channel_pay_amount'] = this.channelPayAmount;
    data['book_info'] = this.bookInfo;
    data['guarantee_period'] = this.guaranteePeriod;
    data['over_guarantee_period'] = this.overGuaranteePeriod;
    data['brand_name'] = this.brandName;
    data['car_brand_name'] = this.carBrandName;
    data['car_system'] = this.carSystem;
    data['car_type'] = this.carType;
    data['parts_name'] = this.partsName;
    data['parts_code'] = this.partsCode;
    data['num'] = this.num;
    data['create_time'] = this.createTime;
    data['outer_packing_pic'] = this.outerPackingPic;
    data['product_identify_pic'] = this.productIdentifyPic;
    data['problem_area_pic'] = this.problemAreaPic;
    data['apply_reason'] = this.applyReason;
    data['remark'] = this.remark;
    data['is_packed'] = this.isPacked;
    data['is_outer_pack_well'] = this.isOuterPackWell;
    data['is_product_identify_well'] = this.isProductIdentifyWell;
    data['evidence_pics_list'] = this.evidencePicsList;
    data['has_over_origin_purchase_price'] = this.hasOverOriginPurchasePrice;
    return data;
  }
}

class FirstResponsibilityDto {
  String dealAdvise;
  bool advise;
  bool conformRules;
  String outPackage;
  String innerPackage;
  String label;
  Null realThing;
  String remarkToPartner;

  FirstResponsibilityDto(
      {this.dealAdvise,
      this.advise,
      this.conformRules,
      this.outPackage,
      this.innerPackage,
      this.label,
      this.realThing,
      this.remarkToPartner});

  FirstResponsibilityDto.fromJson(Map<String, dynamic> json) {
    dealAdvise = json['deal_advise'];
    advise = json['advise'];
    conformRules = json['conform_rules'];
    outPackage = json['out_package'];
    innerPackage = json['inner_package'];
    label = json['label'];
    realThing = json['real_thing'];
    remarkToPartner = json['remark_to_partner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deal_advise'] = this.dealAdvise;
    data['advise'] = this.advise;
    data['conform_rules'] = this.conformRules;
    data['out_package'] = this.outPackage;
    data['inner_package'] = this.innerPackage;
    data['label'] = this.label;
    data['real_thing'] = this.realThing;
    data['remark_to_partner'] = this.remarkToPartner;
    return data;
  }
}

class ReturnGoodsAuditMoneyDto {
  double damageRate;
  double damageAmount;
  double unitPrice;
  double reverseFreight;
  Null positiveFreight;
  Null compensation;
  double refundAmount;
  String remark;
  int auditResult;

  ReturnGoodsAuditMoneyDto(
      {this.damageRate,
      this.damageAmount,
      this.unitPrice,
      this.reverseFreight,
      this.positiveFreight,
      this.compensation,
      this.refundAmount,
      this.remark,
      this.auditResult});

  ReturnGoodsAuditMoneyDto.fromJson(Map<String, dynamic> json) {
    damageRate = json['damage_rate'];
    damageAmount = json['damage_amount'];
    unitPrice = json['unit_price'];
    reverseFreight = json['reverse_freight'];
    positiveFreight = json['positive_freight'];
    compensation = json['compensation'];
    refundAmount = json['refund_amount'];
    remark = json['remark'];
    auditResult = json['audit_result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['damage_rate'] = this.damageRate;
    data['damage_amount'] = this.damageAmount;
    data['unit_price'] = this.unitPrice;
    data['reverse_freight'] = this.reverseFreight;
    data['positive_freight'] = this.positiveFreight;
    data['compensation'] = this.compensation;
    data['refund_amount'] = this.refundAmount;
    data['remark'] = this.remark;
    data['audit_result'] = this.auditResult;
    return data;
  }
}
