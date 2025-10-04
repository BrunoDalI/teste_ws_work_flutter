import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/save_lead.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/pages/leads_page.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class MemoryRepo implements LeadRepository {
  final List<Lead> _leads = [];
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async { _leads.add(lead); return const Right(null);} 
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(List.of(_leads));
  // não usados neste teste
  @override
  Future<Either<Failure, void>> deleteLead(int id) async => const Right(null);
  @override
  Future<Either<Failure, Lead?>> getLeadById(int id) async => const Right(null);
  @override
  Future<Either<Failure, void>> markLeadAsSent(int id) async => const Right(null);
  @override
  Future<Either<Failure, void>> sendLead(Lead lead) async => const Right(null);
  @override
  Future<Either<Failure, void>> sendLeads(List<Lead> leads) async => const Right(null);
  @override
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => Right(_leads.where((l)=>!l.isSent).toList());
}

void main() {
  testWidgets('Fluxo salvar lead e exibir na LeadsPage', (tester) async {
    final repo = MemoryRepo();
    final bloc = LeadBloc(saveLead: SaveLead(repo), getLeads: GetLeads(repo));

    final lead = Lead(
      id: 1,
      carId: 99,
      userName: 'Teste',
      userEmail: 't@test.com',
      userPhone: '123',
      createdAt: DateTime.now(),
      carModel: 'Carro X',
      carValue: 30000,
    );

    // Salva via evento
    bloc.add(SaveLeadEvent(lead: lead));
    await tester.pump();

    // Depois solicita carregamento
    bloc.add(const LoadLeadsEvent());

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(500, 800)),
        child: BlocProvider.value(
          value: bloc,
          child: const MaterialApp(home: LeadsPage()),
        ),
      ),
    );

    // Pump inicial (LeadLoading)
    await tester.pump();
    // Próximo ciclo após carregar
    await tester.pump();

    expect(find.byKey(const Key('leadsListView')), findsOneWidget);
  });
}

// Resumo (Integration Test lead_flow): cobre sequência mínima salvar -> carregar -> renderizar.
