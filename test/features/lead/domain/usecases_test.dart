import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/save_lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_unsent_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/send_leads.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class InMemoryRepo implements LeadRepository {
  final List<Lead> _leads = [];
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async { _leads.add(lead); return const Right(null);}  
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(List.of(_leads));
  @override
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => Right(_leads.where((l)=>!l.isSent).toList());
  @override
  Future<Either<Failure, void>> sendLeads(List<Lead> leads) async => const Right(null);
  // Métodos não utilizados
  @override
  Future<Either<Failure, Lead?>> getLeadById(int id) async => const Right(null);
  @override
  Future<Either<Failure, void>> deleteLead(int id) async => const Right(null);
  @override
  Future<Either<Failure, void>> sendLead(Lead lead) async => const Right(null);
  @override
  Future<Either<Failure, void>> markLeadAsSent(int id) async => const Right(null);
}

void main() {
  final repo = InMemoryRepo();
  final getLeads = GetLeads(repo);
  final saveLead = SaveLead(repo);
  final getUnsent = GetUnsentLeads(repo);
  final send = SendLeads(repo);

  final lead = Lead(
    id: 1,
    carId: 10,
    userName: 'User',
    userEmail: 'u@test.com',
    userPhone: '123',
    createdAt: DateTime.now(),
    carModel: 'Modelo',
    carValue: 1000,
  );

  test('SaveLead persiste e GetLeads retorna', () async {
    await saveLead(SaveLeadParams(lead: lead));
    final res = await getLeads();
    expect(res.isRight(), true);
    res.fold((_) {}, (list) => expect(list.length, 1));
  });

  test('GetUnsentLeads retorna não enviados', () async {
    final res = await getUnsent();
    res.fold((_) {}, (list) => expect(list.any((l)=>!l.isSent), true));
  });

  test('SendLeads executa sem erro', () async {
    final res = await send(SendLeadsParams(leads: [lead]));
    expect(res.isRight(), true);
  });
}

// Resumo (UseCases Test): garante integração básica entre casos de uso e repositório em memória.
