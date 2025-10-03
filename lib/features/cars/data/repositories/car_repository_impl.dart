import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_data_source.dart';
import '../datasources/car_remote_data_source.dart';
import '../models/car_model.dart';

/// Implementation of [CarRepository]
class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;
  final CarLocalDataSource localDataSource;

  CarRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Car>>> getCars() async {
    try {
      final remoteCars = await remoteDataSource.getCars();
      await localDataSource.cacheCars(remoteCars);
      return Right(remoteCars.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      try {
        final localCars = await localDataSource.getLastCars();
        return Right(localCars.map((model) => model.toEntity()).toList());
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheCars(List<Car> cars) async {
    try {
      final carModels = cars.map((car) => CarModel.fromEntity(car)).toList();
      await localDataSource.cacheCars(carModels);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Car>>> getCachedCars() async {
    try {
      final localCars = await localDataSource.getLastCars();
      return Right(localCars.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}