import '../models/car_model.dart';

/// Abstract remote data source for cars
abstract class CarRemoteDataSource {
  /// Fetches cars from the remote API
  /// Throws [ServerException] for all error codes
  Future<List<CarModel>> getCars();
}