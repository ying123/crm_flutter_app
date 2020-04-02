import 'package:xiaobaim/xiaobaim.dart';

class Env {
  String name;
  String apiAddr;
  String imAddr;
  String anounceDetailsAddr;
  XiaobaHost xiaobaHost;
  Env(this.name, this.apiAddr, this.anounceDetailsAddr, this.xiaobaHost);
}

Env _genEnvObj(String name, String prefix, {bool isPublic = false}) {
  var protocol = isPublic ? 'https' : 'http';
  var subEnv = prefix.isNotEmpty ? '$prefix-' : '';
  var topDomain = isPublic ? 'com' : 'net';
  var baseAddr = '$protocol://${subEnv}crm.qipeipu.$topDomain';
  var apiAddr = baseAddr;
  // 公告详情
  var anounceDetailsAddr = '$baseAddr/new_mcrm/#/anounceDetails';
  var xiaobaHost = _getXiaobaHost(name);
  return Env(name, apiAddr, anounceDetailsAddr, xiaobaHost);
}

final _production = _genEnvObj('生产环境', '', isPublic: true);
final _pre = _genEnvObj('预发环境', 'pre', isPublic: true);
final _pre42 = _genEnvObj('42预发环境', 'pre42', isPublic: true);
final _test0 = _genEnvObj('test0', 'test');
final _test2 = _genEnvObj('test2', 'test2');
final _test10 = _genEnvObj('test10', 'dockertest');
final _docker10 = _genEnvObj('docker10', 'docker10');
final _docker30 = _genEnvObj('docker30', 'docker30');
final _docker31 = _genEnvObj('docker31', 'docker31');
final _docker32 = _genEnvObj('docker32', 'docker32');
final _docker33 = _genEnvObj('docker33', 'docker33');
final _docker34 = _genEnvObj('docker34', 'docker34');
final _docker35 = _genEnvObj('docker35', 'docker35');
final _docker36 = _genEnvObj('docker36', 'docker36');
final _docker37 = _genEnvObj('docker37', 'docker37');
final _docker38 = _genEnvObj('docker38', 'docker38');
final _docker39 = _genEnvObj('docker39', 'docker39');
//TODO 上线前需改为_production
var currentEnv = _production;

final List<Env> envs = [
  _production,
  _pre,
  _pre42,
  _test0,
  _test2,
  _test10,
  _docker10,
  _docker30,
  _docker31,
  _docker32,
  _docker33,
  _docker34,
  _docker35,
  _docker36,
  _docker37,
  _docker38,
  _docker39,
];

bool get isProduction {
  return currentEnv == _production;
}

XiaobaHost _getXiaobaHost(String name) {
  if (name == '生产环境') {
    return XiaobaHost.BTLXiaoBaIMHostOnline;
  } else if (name == '预发环境') {
    return XiaobaHost.BTLXiaoBaIMHostPre;
  } else if (name == '42预发环境') {
    return XiaobaHost.BTLXiaoBaIMHostPre42;
  } else {
    // 其他环境用docker33
    return XiaobaHost.BTLXiaoBaIMHostDocker33;
  }
}
