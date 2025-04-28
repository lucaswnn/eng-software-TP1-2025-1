class AlreadyExistsException implements Exception {
  final String message;

  AlreadyExistsException(this.message);

  @override
  String toString() => 'AlreadyExistsException: $message';
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);

  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
} 