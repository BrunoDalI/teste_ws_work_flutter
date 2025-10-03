import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lead.dart';
import '../repositories/lead_repository.dart';

/// Use case to save a lead
class SaveLead implements UseCase<void, SaveLeadParams> {
  final LeadRepository repository;

  SaveLead(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveLeadParams params) async {
    return await repository.saveLead(params.lead);
  }
}

/// Parameters for SaveLead use case
class SaveLeadParams extends Equatable {
  final Lead lead;

  const SaveLeadParams({required this.lead});

  @override
  List<Object> get props => [lead];
}