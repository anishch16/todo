class ServerException implements Exception {}

class CacheException implements Exception {}

class InputException implements Exception {
  final String message;
  InputException(this.message);
}