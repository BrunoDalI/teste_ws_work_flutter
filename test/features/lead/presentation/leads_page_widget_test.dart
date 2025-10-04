import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/pages/leads_page.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/save_lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class RepoWidgetFake implements LeadRepository {
  List<Lead> list = [];
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(list);
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async { list.add(lead); return const Right(null);} 
  // não usados
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
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => Right(list.where((l)=>!l.isSent).toList());
}

Widget buildTestable(LeadRepository repo, {double width = 400}) {
  final bloc = LeadBloc(saveLead: SaveLead(repo), getLeads: GetLeads(repo));
  return MediaQuery(
    data: MediaQueryData(size: Size(width, 800)),
    child: BlocProvider.value(
      value: bloc..add(const LoadLeadsEvent()),
      child: const MaterialApp(home: LeadsPage()),
    ),
  );
}

void main() {
  final repo = RepoWidgetFake();
  repo.list = List.generate(3, (i) => Lead(
    id: i+1,
    carId: 10,
    userName: 'User $i',
    userEmail: 'u$i@test.com',
    userPhone: '123',
    createdAt: DateTime.now(),
    carModel: 'Modelo $i',
  carValue: 1000.0 + i,
  ));

  testWidgets('LeadsPage mostra lista (modo list)', (tester) async {
    await tester.pumpWidget(buildTestable(repo, width: 500));
    await tester.pump();
    expect(find.byKey(const Key('leadsListView')), findsOneWidget);
  });

  testWidgets('LeadsPage mostra grid (modo grid)', (tester) async {
    await tester.pumpWidget(buildTestable(repo, width: 900));
    await tester.pump();
    expect(find.byKey(const Key('leadsGridView')), findsOneWidget);
  });
}

// Resumo (Widget Test LeadsPage): valida alternância entre layout lista e grid conforme largura.
