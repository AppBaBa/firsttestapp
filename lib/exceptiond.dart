class AppException implements Exception {
  final message;
  final prefix;

  AppException({this.message, this.prefix});

  @override
  String toString() {
    return '$message$prefix';
  }
}

class FetchException extends AppException {
  FetchException([String? message]) : super(message: 'fetch data error');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message: 'bad request error');
}

class UnAuthException extends AppException {
  UnAuthException([String? message]) : super(message: 'Un Auth error');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message: 'Invalid Data exception error');
}
