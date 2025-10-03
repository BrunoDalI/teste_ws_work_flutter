import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';

/// Use case to get all cars
class GetCars implements NoParamsUseCase<List<Car>> {
  final CarRepository repository;

  GetCars(this.repository);

  @override
  Future<Either<Failure, List<Car>>> call() async {
    return await repository.getCars();
  }
}