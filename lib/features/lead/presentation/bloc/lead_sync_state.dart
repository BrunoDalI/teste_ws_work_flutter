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
  final bool autoSyncEnabled;
  final Duration? autoSyncInterval;
  final DateTime? nextAutoSyncAt;

  const LeadSyncLoaded({
    required this.unsentLeads,
    this.autoSyncEnabled = false,
    this.autoSyncInterval,
    this.nextAutoSyncAt,
  });

  LeadSyncLoaded copyWith({
    List<Lead>? unsentLeads,
    bool? autoSyncEnabled,
    Duration? autoSyncInterval,
    DateTime? nextAutoSyncAt,
  }) {
    return LeadSyncLoaded(
      unsentLeads: unsentLeads ?? this.unsentLeads,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      autoSyncInterval: autoSyncInterval ?? this.autoSyncInterval,
      nextAutoSyncAt: nextAutoSyncAt ?? this.nextAutoSyncAt,
    );
  }

  @override
  List<Object> get props => [unsentLeads, autoSyncEnabled, autoSyncInterval ?? const Duration(), nextAutoSyncAt ?? DateTime.fromMillisecondsSinceEpoch(0)];
}

/// Sending leads to remote API
class LeadSyncSending extends LeadSyncState {
  final List<Lead> unsentLeads;
  final bool autoSyncEnabled;
  final Duration? autoSyncInterval;
  final DateTime? nextAutoSyncAt;

  const LeadSyncSending({
    required this.unsentLeads,
    this.autoSyncEnabled = false,
    this.autoSyncInterval,
    this.nextAutoSyncAt,
  });

  @override
  List<Object> get props => [unsentLeads, autoSyncEnabled, autoSyncInterval ?? const Duration(), nextAutoSyncAt ?? DateTime.fromMillisecondsSinceEpoch(0)];
}

/// Sync completed successfully
class LeadSyncSuccess extends LeadSyncState {
  final int syncedCount;
  final bool autoSyncEnabled;
  final Duration? autoSyncInterval;
  final DateTime? nextAutoSyncAt;

  const LeadSyncSuccess({
    required this.syncedCount,
    this.autoSyncEnabled = false,
    this.autoSyncInterval,
    this.nextAutoSyncAt,
  });

  @override
  List<Object> get props => [syncedCount, autoSyncEnabled, autoSyncInterval ?? const Duration(), nextAutoSyncAt ?? DateTime.fromMillisecondsSinceEpoch(0)];
}

/// Error occurred
class LeadSyncError extends LeadSyncState {
  final String message;

  const LeadSyncError({required this.message});

  @override
  List<Object> get props => [message];
}