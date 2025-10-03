import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/car.dart';

/// Abstract repository for car-related operations
abstract class CarRepository {
  /// Fetches all cars from the remote data source
  Future<Either<Failure, List<Car>>> getCars();
  
  /// Caches cars locally for offline access
  Future<Either<Failure, void>> cacheCars(List<Car> cars);
  
  /// Gets cached cars from local storage
  Future<Either<Failure, List<Car>>> getCachedCars();
}