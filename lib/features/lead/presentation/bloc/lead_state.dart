part of 'lead_bloc.dart';

/// Base class for all Lead states
abstract class LeadState extends Equatable {
  const LeadState();

  @override
  List<Object> get props => [];
}

/// Initial state
class LeadInitial extends LeadState {}

/// Loading state
class LeadLoading extends LeadState {}

/// Success state when a lead is saved
class LeadSaved extends LeadState {}

/// Success state with loaded leads
class LeadsLoaded extends LeadState {
  final List<Lead> leads;

  const LeadsLoaded({required this.leads});

  @override
  List<Object> get props => [leads];
}

/// Error state
class LeadError extends LeadState {
  final String message;

  const LeadError({required this.message});

  @override
  List<Object> get props => [message];
}