/// 校验异常
class ValidatorException implements Exception {
  final String message;
  ValidatorException(this.message)
      : assert(message != null),
        super();
  @override
  String toString() {
    return message;
  }
}
