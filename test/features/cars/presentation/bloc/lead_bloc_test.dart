import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:teste_ws_work_flutter/core/errors/failures.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/get_leads.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/usecases/save_lead.dart';
import 'package:teste_ws_work_flutter/features/lead/presentation/bloc/lead_bloc.dart';

import 'lead_bloc_test.mocks.dart';

@GenerateMocks([SaveLead, GetLeads])
void main() {
  late LeadBloc bloc;
  late MockSaveLead mockSaveLead;
  late MockGetLeads mockGetLeads;

  setUp(() {
    mockSaveLead = MockSaveLead();
    mockGetLeads = MockGetLeads();
    bloc = LeadBloc(saveLead: mockSaveLead, getLeads: mockGetLeads);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be LeadInitial', () {
    expect(bloc.state, equals(LeadInitial()));
  });

  group('SaveLeadEvent', () {
    final tLead = Lead(
      carId: 1,
      userName: 'Test User',
      userEmail: 'test@test.com',
      userPhone: '11999999999',
      createdAt: DateTime(2023, 10, 5),
      carModel: 'ONIX PLUS',
      carValue: 50000.0,
    );

    blocTest<LeadBloc, LeadState>(
      'should emit [LeadLoading, LeadSaved] when lead is saved successfully',
      build: () {
        when(mockSaveLead(any)).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(SaveLeadEvent(lead: tLead)),
      expect: () => [
        LeadLoading(),
        LeadSaved(),
      ],
    );

    blocTest<LeadBloc, LeadState>(
      'should emit [LeadLoading, LeadError] when saving lead fails',
      build: () {
        when(mockSaveLead(any)).thenAnswer(
          (_) async => const Left(CacheFailure('Cache Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(SaveLeadEvent(lead: tLead)),
      expect: () => [
        LeadLoading(),
        const LeadError(message: 'Cache Failure'),
      ],
    );
  });

  group('LoadLeadsEvent', () {
    final tLeadList = [
      Lead(
        id: 1,
        carId: 1,
        userName: 'Test User',
        userEmail: 'test@test.com',
        userPhone: '11999999999',
        createdAt: DateTime(2023, 10, 5),
        carModel: 'ONIX PLUS',
        carValue: 50000.0,
      ),
    ];

    blocTest<LeadBloc, LeadState>(
      'should emit [LeadLoading, LeadsLoaded] when leads are loaded successfully',
      build: () {
        when(mockGetLeads()).thenAnswer((_) async => Right(tLeadList));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadLeadsEvent()),
      expect: () => [
        LeadLoading(),
        LeadsLoaded(leads: tLeadList),
      ],
    );

    blocTest<LeadBloc, LeadState>(
      'should emit [LeadLoading, LeadError] when loading leads fails',
      build: () {
        when(mockGetLeads()).thenAnswer(
          (_) async => const Left(CacheFailure('Cache Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadLeadsEvent()),
      expect: () => [
        LeadLoading(),
        const LeadError(message: 'Cache Failure'),
      ],
    );
  });
}