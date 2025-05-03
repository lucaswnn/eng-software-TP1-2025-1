// Useful exceptions for dealing with API responses

// 400 status code
class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);

  @override
  String toString() => 'BadRequestException: $message';
}

// 401 status code
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

// 403 status code
class ForbiddenException implements Exception {
  final String message;

  ForbiddenException(this.message);

  @override
  String toString() => 'ForbiddenException: $message';
}

// 404 status code
class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}
