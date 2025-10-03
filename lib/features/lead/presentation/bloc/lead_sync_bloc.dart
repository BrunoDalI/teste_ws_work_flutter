import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_unsent_leads.dart';
import '../../domain/usecases/send_leads.dart';
import '../../domain/repositories/lead_repository.dart';
import 'lead_sync_event.dart';
import 'lead_sync_state.dart';
import '../../../../core/sync/auto_sync_service.dart';

/// BLoC for managing lead synchronization
class LeadSyncBloc extends Bloc<LeadSyncEvent, LeadSyncState> {
  final GetUnsentLeads _getUnsentLeads;
  final SendLeads _sendLeads;
  final LeadRepository _leadRepository;
  Timer? _autoSyncTimer;
  Duration? _currentInterval;
  final AutoSyncService? _autoSyncService;
  StreamSubscription? _serviceSub;
  Timer? _countdownTimer;

  LeadSyncBloc({
    required GetUnsentLeads getUnsentLeads,
    required SendLeads sendLeads,
    required LeadRepository leadRepository,
    AutoSyncService? autoSyncService,
  })  : _getUnsentLeads = getUnsentLeads,
        _sendLeads = sendLeads,
        _leadRepository = leadRepository,
        _autoSyncService = autoSyncService,
        super(const LeadSyncInitial()) {
    on<LoadUnsentLeadsEvent>(_onLoadUnsentLeads);
    on<SyncLeadsEvent>(_onSyncLeads);
    on<EnableAutoSyncEvent>(_onEnableAutoSync);
    on<DisableAutoSyncEvent>(_onDisableAutoSync);
    on<AutoSyncTickEvent>(_onAutoSyncTick);

    // Listen external service results to refresh state automatically
    if (_autoSyncService != null) {
      _serviceSub = _autoSyncService.results.listen((res) {
        // After a successful auto sync cycle, reload unsent leads silently
        add(const LoadUnsentLeadsEvent());
      });
      _startCountdown();
    }
  }

  Future<void> _onLoadUnsentLeads(
    LoadUnsentLeadsEvent event,
    Emitter<LeadSyncState> emit,
  ) async {
    emit(const LeadSyncLoading());

    final result = await _getUnsentLeads();

    result.fold(
      (failure) => emit(LeadSyncError(message: failure.message)),
      (leads) {
        bool enabled = false;
        Duration? interval;
        DateTime? nextAt;
        if (state is LeadSyncLoaded) {
          final s = state as LeadSyncLoaded;
            enabled = s.autoSyncEnabled;
            interval = s.autoSyncInterval;
            nextAt = s.nextAutoSyncAt;
        } else if (state is LeadSyncSending) {
          final s = state as LeadSyncSending;
          enabled = s.autoSyncEnabled;
          interval = s.autoSyncInterval;
          nextAt = s.nextAutoSyncAt;
        } else if (state is LeadSyncSuccess) {
          final s = state as LeadSyncSuccess;
          enabled = s.autoSyncEnabled;
          interval = s.autoSyncInterval;
          nextAt = s.nextAutoSyncAt;
        }
        // If we have service, override with its state for consistency
        if (_autoSyncService != null) {
          enabled = _autoSyncService.isEnabled;
          interval = _autoSyncService.interval;
          nextAt = _autoSyncService.nextRunAt;
          _currentInterval = interval;
        }
        emit(LeadSyncLoaded(
          unsentLeads: leads,
          autoSyncEnabled: enabled,
          autoSyncInterval: interval,
          nextAutoSyncAt: nextAt,
        ));
      },
    );
  }

  Future<void> _onSyncLeads(
    SyncLeadsEvent event,
    Emitter<LeadSyncState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is! LeadSyncLoaded) {
      emit(const LeadSyncError(message: 'Nenhum lead carregado para sincronizar'));
      return;
    }

    final unsentLeads = currentState.unsentLeads;
    
    if (unsentLeads.isEmpty) {
      emit(const LeadSyncError(message: 'Não há leads para sincronizar'));
      return;
    }

    emit(LeadSyncSending(
      unsentLeads: unsentLeads,
      autoSyncEnabled: currentState.autoSyncEnabled,
      autoSyncInterval: currentState.autoSyncInterval,
      nextAutoSyncAt: currentState.nextAutoSyncAt,
    ));

    try {
      // Send leads to remote API
      final sendResult = await _sendLeads(SendLeadsParams(leads: unsentLeads));

      await sendResult.fold(
        (failure) async {
          emit(LeadSyncError(message: failure.message));
        },
        (success) async {
          // Mark leads as sent in local database
          for (final lead in unsentLeads) {
            if (lead.id != null) {
              await _leadRepository.markLeadAsSent(lead.id!);
            }
          }
          
          final nextAt = currentState.autoSyncEnabled && _currentInterval != null
              ? DateTime.now().add(_currentInterval!)
              : null;
          emit(LeadSyncSuccess(
            syncedCount: unsentLeads.length,
            autoSyncEnabled: currentState.autoSyncEnabled,
            autoSyncInterval: currentState.autoSyncInterval,
            nextAutoSyncAt: nextAt,
          ));
          
          // Reload unsent leads to update the list
          add(const LoadUnsentLeadsEvent());
        },
      );
    } catch (e) {
      emit(LeadSyncError(message: 'Erro inesperado: $e'));
    }
  }

  void _onEnableAutoSync(
    EnableAutoSyncEvent event,
    Emitter<LeadSyncState> emit,
  ) {
    _currentInterval = event.interval;

    if (_autoSyncService != null) {
      _autoSyncService.enable(event.interval);
      _startCountdown();
    } else {
      _autoSyncTimer?.cancel();
      _autoSyncTimer = Timer.periodic(event.interval, (_) => add(const AutoSyncTickEvent()));
    }

    if (state is LeadSyncLoaded) {
      final s = state as LeadSyncLoaded;
      final nextAt = DateTime.now().add(event.interval);
      emit(s.copyWith(
        autoSyncEnabled: true,
        autoSyncInterval: event.interval,
        nextAutoSyncAt: nextAt,
      ));
    }

    _autoSyncTimer = Timer.periodic(event.interval, (_) {
      add(const AutoSyncTickEvent());
    });
  }

  void _onDisableAutoSync(
    DisableAutoSyncEvent event,
    Emitter<LeadSyncState> emit,
  ) {
    _currentInterval = null;
    if (_autoSyncService != null) {
      _autoSyncService.disable();
      _countdownTimer?.cancel();
    } else {
      _autoSyncTimer?.cancel();
    }
    if (state is LeadSyncLoaded) {
      emit((state as LeadSyncLoaded).copyWith(
        autoSyncEnabled: false,
        autoSyncInterval: null,
        nextAutoSyncAt: null,
      ));
    }
  }

  void _onAutoSyncTick(
    AutoSyncTickEvent event,
    Emitter<LeadSyncState> emit,
  ) {
    if (state is LeadSyncLoaded) {
      final s = state as LeadSyncLoaded;
      if (s.unsentLeads.isNotEmpty) {
        add(const SyncLeadsEvent());
      } else {
        // Only update next schedule
        emit(s.copyWith(nextAutoSyncAt: DateTime.now().add(_currentInterval!)));
      }
    }
  }

  @override
  Future<void> close() async {
    _autoSyncTimer?.cancel();
    _countdownTimer?.cancel();
    await _serviceSub?.cancel();
    return super.close();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is LeadSyncLoaded && _autoSyncService != null && _autoSyncService.isEnabled) {
        // Re-dispatch a lightweight load just to refresh countdown display without heavy work
        final s = state as LeadSyncLoaded;
        final updated = s.copyWith(nextAutoSyncAt: _autoSyncService.nextRunAt);
        // Directly updating state is acceptable via emit inside Bloc class, but here inside timer callback we are still within class scope.
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        emit(updated);
      }
    });
  }
}