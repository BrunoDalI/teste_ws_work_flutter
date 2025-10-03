import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_unsent_leads.dart';
import '../../domain/usecases/send_leads.dart';
import '../../domain/repositories/lead_repository.dart';
import 'lead_sync_event.dart';
import 'lead_sync_state.dart';

/// BLoC for managing lead synchronization
class LeadSyncBloc extends Bloc<LeadSyncEvent, LeadSyncState> {
  final GetUnsentLeads _getUnsentLeads;
  final SendLeads _sendLeads;
  final LeadRepository _leadRepository;

  LeadSyncBloc({
    required GetUnsentLeads getUnsentLeads,
    required SendLeads sendLeads,
    required LeadRepository leadRepository,
  })  : _getUnsentLeads = getUnsentLeads,
        _sendLeads = sendLeads,
        _leadRepository = leadRepository,
        super(const LeadSyncInitial()) {
    on<LoadUnsentLeadsEvent>(_onLoadUnsentLeads);
    on<SyncLeadsEvent>(_onSyncLeads);
  }

  Future<void> _onLoadUnsentLeads(
    LoadUnsentLeadsEvent event,
    Emitter<LeadSyncState> emit,
  ) async {
    emit(const LeadSyncLoading());

    final result = await _getUnsentLeads();

    result.fold(
      (failure) => emit(LeadSyncError(message: failure.message)),
      (leads) => emit(LeadSyncLoaded(unsentLeads: leads)),
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

    emit(LeadSyncSending(unsentLeads: unsentLeads));

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
          
          emit(LeadSyncSuccess(syncedCount: unsentLeads.length));
          
          // Reload unsent leads to update the list
          add(const LoadUnsentLeadsEvent());
        },
      );
    } catch (e) {
      emit(LeadSyncError(message: 'Erro inesperado: $e'));
    }
  }
}