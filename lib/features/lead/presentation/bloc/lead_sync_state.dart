import 'package:equatable/equatable.dart';
import '../../domain/entities/lead.dart';

/// States for Lead Sync BLoC
abstract class LeadSyncState extends Equatable {
  const LeadSyncState();

  @override
  List<Object> get props => [];
}

/// Initial state
class LeadSyncInitial extends LeadSyncState {
  const LeadSyncInitial();
}

/// Loading unsent leads
class LeadSyncLoading extends LeadSyncState {
  const LeadSyncLoading();
}

/// Unsent leads loaded successfully
class LeadSyncLoaded extends LeadSyncState {
  final List<Lead> unsentLeads;

  const LeadSyncLoaded({required this.unsentLeads});

  @override
  List<Object> get props => [unsentLeads];
}

/// Sending leads to remote API
class LeadSyncSending extends LeadSyncState {
  final List<Lead> unsentLeads;

  const LeadSyncSending({required this.unsentLeads});

  @override
  List<Object> get props => [unsentLeads];
}

/// Sync completed successfully
class LeadSyncSuccess extends LeadSyncState {
  final int syncedCount;

  const LeadSyncSuccess({required this.syncedCount});

  @override
  List<Object> get props => [syncedCount];
}

/// Error occurred
class LeadSyncError extends LeadSyncState {
  final String message;

  const LeadSyncError({required this.message});

  @override
  List<Object> get props => [message];
}