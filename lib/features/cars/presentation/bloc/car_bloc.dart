import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/car.dart';
import '../../domain/usecases/get_cars.dart';

part 'car_event.dart';
part 'car_state.dart';

/// BLoC for managing car-related state
class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCars getCars;

  CarBloc({required this.getCars}) : super(CarInitial()) {
    on<LoadCarsEvent>(_onLoadCars);
    on<RefreshCarsEvent>(_onRefreshCars);
  }

  /// Handle LoadCarsEvent
  Future<void> _onLoadCars(LoadCarsEvent event, Emitter<CarState> emit) async {
    emit(CarLoading());
    
    final result = await getCars();
    
    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (cars) => emit(CarLoaded(cars: cars)),
    );
  }

  /// Handle RefreshCarsEvent
  Future<void> _onRefreshCars(RefreshCarsEvent event, Emitter<CarState> emit) async {
    final result = await getCars();
    
    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (cars) => emit(CarLoaded(cars: cars)),
    );
  }
}