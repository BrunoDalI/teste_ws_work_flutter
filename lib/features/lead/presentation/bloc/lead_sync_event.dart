import 'package:equatable/equatable.dart';

/// Events for Lead Sync BLoC
abstract class LeadSyncEvent extends Equatable {
  const LeadSyncEvent();

  @override
  List<Object> get props => [];
}

/// Event to load unsent leads
class LoadUnsentLeadsEvent extends LeadSyncEvent {
  const LoadUnsentLeadsEvent();
}

/// Event to sync leads to remote API
class SyncLeadsEvent extends LeadSyncEvent {
  const SyncLeadsEvent();
}