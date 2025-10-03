part of 'car_bloc.dart';

/// Base class for all Car states
abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object> get props => [];
}

/// Initial state
class CarInitial extends CarState {}

/// Loading state
class CarLoading extends CarState {}

/// Success state with loaded cars
class CarLoaded extends CarState {
  final List<Car> cars;

  const CarLoaded({required this.cars});

  @override
  List<Object> get props => [cars];
}

/// Error state
class CarError extends CarState {
  final String message;

  const CarError({required this.message});

  @override
  List<Object> get props => [message];
}