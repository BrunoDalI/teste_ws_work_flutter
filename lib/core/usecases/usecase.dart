import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

/// Base class for all use cases
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case that doesn't require parameters
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}