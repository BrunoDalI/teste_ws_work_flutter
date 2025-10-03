import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:teste_ws_work_flutter/core/errors/failures.dart';
import 'package:teste_ws_work_flutter/features/cars/domain/entities/car.dart';
import 'package:teste_ws_work_flutter/features/cars/domain/usecases/get_cars.dart';
import 'package:teste_ws_work_flutter/features/cars/presentation/bloc/car_bloc.dart';

import 'car_bloc_test.mocks.dart';

@GenerateMocks([GetCars])
void main() {
  late CarBloc bloc;
  late MockGetCars mockGetCars;

  setUp(() {
    mockGetCars = MockGetCars();
    bloc = CarBloc(getCars: mockGetCars);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be CarInitial', () {
    expect(bloc.state, equals(CarInitial()));
  });

  group('LoadCarsEvent', () {
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

    blocTest<CarBloc, CarState>(
      'should emit [CarLoading, CarLoaded] when data is gotten successfully',
      build: () {
        when(mockGetCars()).thenAnswer((_) async => const Right(tCarList));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCarsEvent()),
      expect: () => [
        CarLoading(),
        const CarLoaded(cars: tCarList),
      ],
    );

    blocTest<CarBloc, CarState>(
      'should emit [CarLoading, CarError] when getting data fails',
      build: () {
        when(mockGetCars()).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCarsEvent()),
      expect: () => [
        CarLoading(),
        const CarError(message: 'Server Failure'),
      ],
    );
  });

  group('RefreshCarsEvent', () {
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

    blocTest<CarBloc, CarState>(
      'should emit [CarLoaded] when data is refreshed successfully',
      build: () {
        when(mockGetCars()).thenAnswer((_) async => const Right(tCarList));
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshCarsEvent()),
      expect: () => [
        const CarLoaded(cars: tCarList),
      ],
    );

    blocTest<CarBloc, CarState>(
      'should emit [CarError] when refreshing data fails',
      build: () {
        when(mockGetCars()).thenAnswer(
          (_) async => const Left(NetworkFailure('Network Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshCarsEvent()),
      expect: () => [
        const CarError(message: 'Network Failure'),
      ],
    );
  });
}