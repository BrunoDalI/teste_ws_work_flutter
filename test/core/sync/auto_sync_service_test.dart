import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:teste_ws_work_flutter/core/sync/auto_sync_service.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_unsent_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/send_leads.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class FakeLeadRepo implements LeadRepository {
  List<Lead> leads = [];
  List<Lead> sent = [];
  @override
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => Right(List.of(leads.where((l)=>!l.isSent)));
  @override
  Future<Either<Failure, void>> markLeadAsSent(int id) async { final idx = leads.indexWhere((l)=>l.id==id); if(idx!=-1) { leads[idx] = leads[idx].copyWith(isSent: true);} return const Right(null);} 
  @override
  Future<Either<Failure, void>> sendLeads(List<Lead> leadsToSend) async { sent.addAll(leadsToSend); return const Right(null);} 
  // Métodos não usados
  @override
  Future<Either<Failure, void>> deleteLead(int id) async => const Right(null);
  @override
  Future<Either<Failure, Lead?>> getLeadById(int id) async => const Right(null);
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(leads);
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async { leads.add(lead); return const Right(null);} 
  @override
  Future<Either<Failure, void>> sendLead(Lead lead) async => const Right(null);
}

class FakeGetUnsent extends GetUnsentLeads { FakeGetUnsent(LeadRepository repo):super(repo);} 
class FakeSendLeads extends SendLeads { FakeSendLeads(LeadRepository repo):super(repo);} 

void main() {
  test('AutoSyncService envia leads e publica resultado', () async {
    final repo = FakeLeadRepo();
    repo.leads = [Lead(id:1, carId: 1, userName: 'u', userEmail: 'e', userPhone: 'p', createdAt: DateTime.now(), carModel: 'm', carValue: 1000)];
    final service = AutoSyncService(
      getUnsentLeads: FakeGetUnsent(repo),
      sendLeads: FakeSendLeads(repo),
      leadRepository: repo,
    );

    final results = <AutoSyncResult>[];
    final sub = service.results.listen(results.add);

    service.enable(const Duration(milliseconds: 50));
    // Aguarda alguns ticks
    await Future.delayed(const Duration(milliseconds: 160));
    service.disable();
    await sub.cancel();

    expect(results.isNotEmpty, true, reason: 'Deveria ter publicado algum resultado');
    expect(repo.sent.length, 1);
    expect(repo.leads.first.isSent, true);
  });
}

// Resumo (teste AutoSyncService):
// Validamos ciclo de enable -> tick periódico -> envio de leads -> marcação como enviados
// e emissão no stream de resultados. Intervalo reduzido para acelerar o teste.
