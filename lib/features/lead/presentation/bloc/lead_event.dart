part of 'lead_bloc.dart';

/// Base class for all Lead events
abstract class LeadEvent extends Equatable {
  const LeadEvent();

  @override
  List<Object> get props => [];
}

/// Event to save a lead
class SaveLeadEvent extends LeadEvent {
  final Lead lead;

  const SaveLeadEvent({required this.lead});

  @override
  List<Object> get props => [lead];
}

/// Event to load all leads
class LoadLeadsEvent extends LeadEvent {
  const LoadLeadsEvent();
}