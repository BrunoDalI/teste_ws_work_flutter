import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_unsent_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/send_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_sync_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_sync_event.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/pages/lead_sync_page.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class TestRepo implements LeadRepository {
  List<Lead> unsent = [];
  @override
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => Right(List.of(unsent));
  @override
  Future<Either<Failure, void>> markLeadAsSent(int id) async => const Right(null);
  @override
  Future<Either<Failure, void>> sendLeads(List<Lead> leads) async => const Right(null);
  // unused
  @override
  Future<Either<Failure, void>> deleteLead(int id) async => const Right(null);
  @override
  Future<Either<Failure, Lead?>> getLeadById(int id) async => const Right(null);
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(unsent);
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async => const Right(null);
  @override
  Future<Either<Failure, void>> sendLead(Lead lead) async => const Right(null);
}

void main() {
  testWidgets('should show list and refresh indicator', (tester) async {
    final repo = TestRepo();
    repo.unsent = [Lead(id: 1, carId: 1, userName: 'A', userEmail: 'a@a', userPhone: '1', createdAt: DateTime(2024), carModel: 'M', carValue: 10)];
    final bloc = LeadSyncBloc(getUnsentLeads: GetUnsentLeads(repo), sendLeads: SendLeads(repo), leadRepository: repo);

    await tester.pumpWidget(MaterialApp(home: BlocProvider.value(value: bloc..add(const LoadUnsentLeadsEvent()), child: const LeadSyncPage())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sincronizar Leads'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsWidgets);
  });
}
