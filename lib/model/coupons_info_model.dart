class CouponsDetailModel {
  int ruleDetailId;
  int ruleId;
  int money;
  int quota;
  int maxNum;
  int discount;

  CouponsDetailModel(
      {this.ruleDetailId,
      this.ruleId,
      this.money,
      this.discount,
      this.maxNum,
      this.quota});

  CouponsDetailModel.fromJson(Map<String, dynamic> json)
      : ruleDetailId = json['ruleDetailId'],
        ruleId = json['ruleId'],
        money = json['money'],
        quota = json['quota'],
        maxNum = json['maxNum'],
        discount = json['discount'];

  Map<String, dynamic> toJson() => {
        "ruleDetailId": ruleDetailId,
        "ruleId": ruleId,
        "money": money,
        "discount": discount,
        "maxNum": maxNum,
        "quota": quota
      };
}

class CouponsInfoModel {
  int ruleId;
  String ruleName;
  bool usable;
  int isStop;
  int couponType;
  List detailVos;

  CouponsInfoModel(
      {this.ruleId,
      this.ruleName,
      this.usable,
      this.isStop,
      this.couponType,
      this.detailVos});

  CouponsInfoModel.fromJson(Map<String, dynamic> json)
      : ruleId = json['ruleId'],
        ruleName = json['ruleName'],
        usable = json['usable'],
        isStop = json['isStop'],
        couponType = json['couponType'],
        detailVos = json['detailVos'];

  Map<String, dynamic> toJson() => {
        "ruleId": ruleId,
        "ruleName": ruleName,
        "usable": usable,
        "isStop": isStop,
        "couponType": couponType,
        "detailVos": detailVos
      };
}
