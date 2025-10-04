import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/lead.dart';
import '../../domain/usecases/get_leads.dart';
import '../../domain/usecases/save_lead.dart';

part 'lead_event.dart';
part 'lead_state.dart';

/// BLoC for managing lead-related state
class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final SaveLead saveLead;
  final GetLeads getLeads;

  LeadBloc({
    required this.saveLead,
    required this.getLeads,
  }) : super(LeadInitial()) {
    on<SaveLeadEvent>(_onSaveLead);
    on<LoadLeadsEvent>(_onLoadLeads);
  }

  /// Handle SaveLeadEvent
  Future<void> _onSaveLead(SaveLeadEvent event, Emitter<LeadState> emit) async {
    emit(LeadLoading());
    
    final result = await saveLead(SaveLeadParams(lead: event.lead));
    
    result.fold(
      (failure) => emit(LeadError(message: failure.message)),
      (_) => emit(LeadSaved()),
    );
  }

  /// Handle LoadLeadsEvent
  Future<void> _onLoadLeads(LoadLeadsEvent event, Emitter<LeadState> emit) async {
    emit(LeadLoading());
    
    final result = await getLeads();
    
    result.fold(
      (failure) => emit(LeadError(message: failure.message)),
      (leads) => emit(LeadsLoaded(leads: leads)),
    );
  }
}

/*
Resumo (LeadBloc):
Centraliza transições de estado para operações básicas com leads: carregar todos e salvar.
Mantém estados enxutos para simplificar UI e testes (Loading, Saved, Loaded, Error).
Decisão: Após salvar um lead emitimos LeadSaved em vez de recarregar imediatamente a lista para
permitir que a UI decida quando atualizar (ex: navegar de volta e disparar LoadLeadsEvent).
*/