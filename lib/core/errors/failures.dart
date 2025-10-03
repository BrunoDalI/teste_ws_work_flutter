import 'package:equatable/equatable.dart';

/// Abstract base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Failure that occurs when there's a server error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure that occurs when there's a cache error
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure that occurs when there's a network error
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure that occurs when data validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}