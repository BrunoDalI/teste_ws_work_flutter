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

/*
Resumo (GetCars):
Use case fino responsável por recuperar lista de carros delegando a política
de origem (remota/cache) ao repositório. Reforça o isolamento da camada de
apresentação e facilita extensão futura (filtros, paginação) sem quebrar UI.
*/