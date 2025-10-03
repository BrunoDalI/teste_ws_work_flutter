import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/repositories/lead_repository.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_unsent_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/send_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_sync_bloc.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_sync_event.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_sync_state.dart';
import 'package:teste_ws_work_flutter/core/errors/failures.dart';

class FakeLeadRepository implements LeadRepository {
  List<Lead> unsent = [];
  bool sendShouldFail = false;
  bool loadShouldFail = false;

  @override
  Future<Either<Failure, List<Lead>>> getUnsentLeads() async {
    if (loadShouldFail) return const Left(ServerFailure('err'));
    return Right(List.of(unsent));
  }

  @override
  Future<Either<Failure, void>> markLeadAsSent(int id) async {
    unsent = unsent.where((e) => e.id != id).toList();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> sendLeads(List<Lead> leads) async {
    if (sendShouldFail) return const Left(ServerFailure('send fail'));
    return const Right(null);
  }

  // Unused methods for this test
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

class FakeGetUnsentLeads extends GetUnsentLeads {
  final FakeLeadRepository repo;
  FakeGetUnsentLeads(this.repo) : super(repo);
  @override
  Future<Either<Failure, List<Lead>>> call() => repo.getUnsentLeads();
}

class FakeSendLeads extends SendLeads {
  final FakeLeadRepository repo;
  FakeSendLeads(this.repo) : super(repo);
  @override
  Future<Either<Failure, void>> call(SendLeadsParams params) => repo.sendLeads(params.leads);
}

void main() {
  late FakeGetUnsentLeads mockGetUnsentLeads;
  late FakeSendLeads mockSendLeads;
  late FakeLeadRepository mockLeadRepository;
  late LeadSyncBloc bloc;

  Lead sampleLead(int id) => Lead(
        id: id,
        carId: 1,
        userName: 'User $id',
        userEmail: 'u$id@test.com',
        userPhone: '123',
        createdAt: DateTime(2024,1,1),
        carModel: 'Car',
        carValue: 1000,
        isSent: false,
      );

  setUp(() {
  mockLeadRepository = FakeLeadRepository();
  mockGetUnsentLeads = FakeGetUnsentLeads(mockLeadRepository);
  mockSendLeads = FakeSendLeads(mockLeadRepository);
    bloc = LeadSyncBloc(
      getUnsentLeads: mockGetUnsentLeads,
      sendLeads: mockSendLeads,
      leadRepository: mockLeadRepository,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('LoadUnsentLeadsEvent', () {
    blocTest<LeadSyncBloc, LeadSyncState>(
      'emits [Loading, Loaded] when success',
      build: () {
        mockLeadRepository.unsent = [sampleLead(1)];
        return bloc..add(const LoadUnsentLeadsEvent());
      },
      expect: () => [
        isA<LeadSyncLoading>(),
  predicate((state) => state is LeadSyncLoaded && state.unsentLeads.length == 1),
      ],
    );

    blocTest<LeadSyncBloc, LeadSyncState>(
      'emits [Loading, Error] when failure',
      build: () {
        mockLeadRepository.loadShouldFail = true;
        return bloc..add(const LoadUnsentLeadsEvent());
      },
      expect: () => [
        isA<LeadSyncLoading>(),
        isA<LeadSyncError>(),
      ],
    );
  });

  group('SyncLeadsEvent', () {
    blocTest<LeadSyncBloc, LeadSyncState>(
      'sync success path',
      build: () {
        mockLeadRepository.unsent = [sampleLead(1)];
        return bloc..add(const LoadUnsentLeadsEvent());
      },
      act: (b) async {
        b.add(const SyncLeadsEvent());
      },
      expect: () => [
        isA<LeadSyncLoading>(),
        isA<LeadSyncLoaded>(),
        isA<LeadSyncSending>(),
        // Success then reload -> Loading -> Loaded
        isA<LeadSyncSuccess>(),
        isA<LeadSyncLoading>(),
        isA<LeadSyncLoaded>(),
      ],
    );
  });

  group('Auto Sync', () {
    blocTest<LeadSyncBloc, LeadSyncState>(
      'enable auto sync updates state',
      build: () {
        return bloc..add(const LoadUnsentLeadsEvent());
      },
      act: (b) async {
        b.add(const EnableAutoSyncEvent(Duration(minutes: 1)));
      },
      expect: () => [
        isA<LeadSyncLoading>(),
        isA<LeadSyncLoaded>(),
  predicate((state) => state is LeadSyncLoaded && state.autoSyncEnabled == true),
      ],
    );
  });
}
