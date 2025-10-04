import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/save_lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

// Fakes simples para evitar dependência de geração de código (mockito/build_runner)
class FakeRepo implements LeadRepository {
  List<Lead> stored = [];
  @override
  Future<Either<Failure, List<Lead>>> getLeads() async => Right(List.of(stored));
  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async { stored.add(lead); return const Right(null);} 
  // Métodos não usados nestes testes
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
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async => const Right([]);
}

class FakeGetLeads extends GetLeads {
  FakeGetLeads(this._fn) : super(FakeRepo());
  final Future<Either<Failure, List<Lead>>> Function() _fn;
  @override
  Future<Either<Failure, List<Lead>>> call() => _fn();
}

class FakeSaveLead extends SaveLead {
  FakeSaveLead(this._fn) : super(FakeRepo());
  final Future<Either<Failure, void>> Function(SaveLeadParams params) _fn;
  @override
  Future<Either<Failure, void>> call(SaveLeadParams params) => _fn(params);
}

void main() {
  EquatableConfig.stringify = true;

  late FakeGetLeads mockGetLeads;
  late FakeSaveLead mockSaveLead;

  final tLead = Lead(
    id: 1,
    carId: 10,
    userName: 'User',
    userEmail: 'user@test.com',
    userPhone: '1199999999',
    createdAt: DateTime(2024,1,1),
    carModel: 'Model X',
    carValue: 50000,
    isSent: false,
  );

  setUp(() {
    mockGetLeads = FakeGetLeads(() async => const Right([]));
    mockSaveLead = FakeSaveLead((_) async => const Right(null));
  });

  group('LoadLeadsEvent', () {
    blocTest<LeadBloc, LeadState>(
      'emits [LeadLoading, LeadsLoaded] on success',
      build: () {
        mockGetLeads = FakeGetLeads(() async => Right([tLead]));
        return LeadBloc(saveLead: mockSaveLead, getLeads: mockGetLeads);
      },
      act: (b) => b.add(const LoadLeadsEvent()),
      expect: () => [isA<LeadLoading>(), predicate((s) => s is LeadsLoaded && s.leads.length == 1)],
    );

    blocTest<LeadBloc, LeadState>(
      'emits [LeadLoading, LeadError] on failure',
      build: () {
        mockGetLeads = FakeGetLeads(() async => const Left(ServerFailure('err')));
        return LeadBloc(saveLead: mockSaveLead, getLeads: mockGetLeads);
      },
      act: (b) => b.add(const LoadLeadsEvent()),
      expect: () => [isA<LeadLoading>(), isA<LeadError>()],
    );
  });

  group('SaveLeadEvent', () {
    blocTest<LeadBloc, LeadState>(
      'emits [LeadLoading, LeadSaved] on success',
      build: () {
        mockSaveLead = FakeSaveLead((_) async => const Right(null));
        return LeadBloc(saveLead: mockSaveLead, getLeads: mockGetLeads);
      },
      act: (b) => b.add(SaveLeadEvent(lead: tLead)),
      expect: () => [isA<LeadLoading>(), isA<LeadSaved>()],
    );

    blocTest<LeadBloc, LeadState>(
      'emits [LeadLoading, LeadError] on failure',
      build: () {
        mockSaveLead = FakeSaveLead((_) async => const Left(ValidationFailure('invalid')));
        return LeadBloc(saveLead: mockSaveLead, getLeads: mockGetLeads);
      },
      act: (b) => b.add(SaveLeadEvent(lead: tLead)),
      expect: () => [isA<LeadLoading>(), isA<LeadError>()],
    );
  });
}

// Resumo (teste LeadBloc):
// Exercitamos os fluxos principais (carregar e salvar leads) validando as transições
// de estado. Optamos por fakes ao invés de mocks dinâmicos para reduzir complexidade
// e melhorar a previsibilidade, mantendo o foco no comportamento do BLoC.
