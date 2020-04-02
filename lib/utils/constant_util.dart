class ConstantUtil {
  static const List<Map<String, dynamic>> jobType = const [
    {'key': 0, 'value': '未知'},
    {'key': 1, 'value': '老板'},
    {'key': 2, 'value': '厂长'},
    {'key': 3, 'value': '采购员'},
    {'key': 4, 'value': '仓管'},
    {'key': 5, 'value': '维修工'},
    {'key': 6, 'value': '前台'},
    {'key': 7, 'value': '财务'},
  ];
  static const List<Map<String, dynamic>> age = const [
    {'key': 0, 'value': '未知'},
    {'key': 1, 'value': '30岁以下'},
    {'key': 2, 'value': '30-40岁'},
    {'key': 3, 'value': '40岁以上'},
  ];
  static const List<Map<String, dynamic>> internetAttitude = const [
    {'key': 0, 'value': '未知'},
    {'key': 1, 'value': '认可'},
    {'key': 2, 'value': '不认可'},
    {'key': 3, 'value': '说不清'},
  ];

  static const List<Map<String, dynamic>> invoiceType = const [
    // 发票类型
    {"key": 0, "value": '普通发票'},
    {"key": 1, "value": '专用发票'},
    {"key": 2, "value": '电子发票'},
  ];

  static const List<Map<String, dynamic>> invoiceOrderType = const [
    // 发票申请明细的发票类型
    {"key": 0, "value": '没冲红'},
    {"key": 1, "value": '冲红(已退款)'},
  ];

  static const List<Map<String, dynamic>> invoiceStatus = const [
    // 发票的状态
    {"key": 0, "value": '正常'},
    {"key": -1, "value": '作废'},
    {"key": 1, "value": '重开'},
  ];

  static const List<Map<String, dynamic>> isInvoice = const [
    // 开票状态
    {"key": 0, "value": '未开'},
    {"key": 1, "value": '已开'},
  ];
}
