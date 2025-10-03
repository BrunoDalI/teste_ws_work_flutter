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

/// Enable automatic synchronization with given interval
class EnableAutoSyncEvent extends LeadSyncEvent {
  final Duration interval;
  const EnableAutoSyncEvent(this.interval);

  @override
  List<Object> get props => [interval];
}

/// Disable automatic synchronization
class DisableAutoSyncEvent extends LeadSyncEvent {
  const DisableAutoSyncEvent();
}

/// Internal periodic tick for auto sync (not exposed to UI directly)
class AutoSyncTickEvent extends LeadSyncEvent {
  const AutoSyncTickEvent();
}