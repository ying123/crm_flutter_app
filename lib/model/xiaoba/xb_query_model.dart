class XiaobaQueryModel {
  int supplierId;
  int orderDetailId;
  int orderId;
  int inquiryId;
  int orderType;
  int targetType;
  String groupId;
  String reqPage;
  String toPage;
  int inquiryDetailId;
  int exchangeGoodsDetailId;
  int returnGoodsDetailId;
  int quoteDetailId;
  int exchangeGoodsId;
  int returnGoodsId;
  int cartId;
  int refundId;
  String distributeTo;
  XiaobaQueryModel(
      {this.supplierId,
      this.orderDetailId,
      this.orderId,
      this.inquiryId,
      this.inquiryDetailId,
      this.orderType,
      this.targetType,
      this.groupId,
      this.toPage,
      this.exchangeGoodsDetailId,
      this.returnGoodsDetailId,
      this.cartId,
      this.refundId,
      this.exchangeGoodsId,
      this.quoteDetailId,
      this.reqPage,
      this.returnGoodsId,
      this.distributeTo});
  Map<String, dynamic> toJson() => <String, dynamic>{
        if (supplierId != null) "supplierId": supplierId.toString(),
        if (orderDetailId != null) "orderDetailId": orderDetailId.toString(),
        if (orderId != null) "orderId": orderId.toString(),
        if (inquiryId != null) "inquiryId": inquiryId.toString(),
        if (orderType != null) "orderType": orderType.toString(),
        if (targetType != null) "targetType": targetType.toString(),
        if (groupId != null) "groupId": groupId.toString(),
        if (reqPage != null && reqPage != '') "req_page": reqPage.toString(),
        if (toPage != null && reqPage != '') "toPage": toPage.toString(),
        if (inquiryDetailId != null)
          "inquiryDetailId": inquiryDetailId.toString(),
        if (exchangeGoodsDetailId != null)
          "exchangeGoodsDetailId": exchangeGoodsDetailId.toString(),
        if (returnGoodsDetailId != null)
          "returnGoodsDetailId": returnGoodsDetailId.toString(),
        if (quoteDetailId != null) "quoteDetailId": quoteDetailId.toString(),
        if (exchangeGoodsId != null)
          "exchangeGoodsId": exchangeGoodsId.toString(),
        if (returnGoodsId != null) "returnGoodsId": returnGoodsId.toString(),
        if (cartId != null) "cartId": cartId.toString(),
        if (refundId != null) "refundId": refundId.toString(),
        if (distributeTo != null && distributeTo != '')
          "distributeTo": distributeTo.toString()
      };
}
