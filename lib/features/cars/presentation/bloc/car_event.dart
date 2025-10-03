part of 'car_bloc.dart';

/// Base class for all Car events
abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object> get props => [];
}

/// Event to load all cars
class LoadCarsEvent extends CarEvent {
  const LoadCarsEvent();
}

/// Event to refresh cars list
class RefreshCarsEvent extends CarEvent {
  const RefreshCarsEvent();
}