import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:teste_ws_work_flutter/core/errors/exceptions.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';
import 'package:teste_ws_work_flutter/features/cars/data/datasources/car_local_data_source.dart';
import 'package:teste_ws_work_flutter/features/cars/data/datasources/car_remote_data_source.dart';
import 'package:teste_ws_work_flutter/features/cars/data/models/car_model.dart';
import 'package:teste_ws_work_flutter/features/cars/data/repositories/car_repository_impl.dart';
import 'package:teste_ws_work_flutter/features/cars/domain/entities/car.dart';

import 'car_repository_impl_test.mocks.dart';

@GenerateMocks([CarRemoteDataSource, CarLocalDataSource])
void main() {
  late CarRepositoryImpl repository;
  late MockCarRemoteDataSource mockRemoteDataSource;
  late MockCarLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCarRemoteDataSource();
    mockLocalDataSource = MockCarLocalDataSource();
    repository = CarRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getCars', () {
    const tCarModelList = [
      CarModel(
        id: 1,
        timestampCadastro: 1696539488,
        modeloId: 12,
        ano: 2015,
        combustivel: 'FLEX',
        numPortas: 4,
        cor: 'BEGE',
        nomeModelo: 'ONIX PLUS',
        valor: 50000.0,
      ),
    ];

    const tCarList = [
      Car(
        id: 1,
        timestampCadastro: 1696539488,
        modeloId: 12,
        ano: 2015,
        combustivel: 'FLEX',
        numPortas: 4,
        cor: 'BEGE',
        nomeModelo: 'ONIX PLUS',
        valor: 50000.0,
      ),
    ];

    test('should return cars when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getCars())
          .thenAnswer((_) async => tCarModelList);
      when(mockLocalDataSource.cacheCars(tCarModelList))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.getCars();

      // assert
      expect(result, equals(const Right(tCarList)));
      verify(mockRemoteDataSource.getCars());
      verify(mockLocalDataSource.cacheCars(tCarModelList));
    });

    test('should return cached cars when remote call fails and cache exists', () async {
      // arrange
      when(mockRemoteDataSource.getCars())
          .thenThrow(const NetworkException('Network error'));
      when(mockLocalDataSource.getLastCars())
          .thenAnswer((_) async => tCarModelList);

      // act
      final result = await repository.getCars();

      // assert
      expect(result, equals(const Right(tCarList)));
      verify(mockRemoteDataSource.getCars());
      verify(mockLocalDataSource.getLastCars());
    });

    test('should return network failure when remote call fails and no cache', () async {
      // arrange
      when(mockRemoteDataSource.getCars())
          .thenThrow(const NetworkException('Network error'));
      when(mockLocalDataSource.getLastCars())
          .thenThrow(const CacheException('No cache'));

      // act
      final result = await repository.getCars();

      // assert
      expect(result, equals(const Left(NetworkFailure('Network error'))));
      verify(mockRemoteDataSource.getCars());
      verify(mockLocalDataSource.getLastCars());
    });

    test('should return server failure when server error occurs', () async {
      // arrange
      when(mockRemoteDataSource.getCars())
          .thenThrow(const ServerException('Server error'));

      // act
      final result = await repository.getCars();

      // assert
      expect(result, equals(const Left(ServerFailure('Server error'))));
      verify(mockRemoteDataSource.getCars());
    });
  });
}