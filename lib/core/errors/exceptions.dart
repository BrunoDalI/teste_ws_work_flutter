/// Exception thrown when there's a server-related error
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// Exception thrown when there's a cache-related error
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Exception thrown when there's a network-related error
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

/// Exception thrown when data validation fails
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}