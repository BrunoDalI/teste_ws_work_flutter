import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lead.dart';
import '../repositories/lead_repository.dart';

/// Use case for getting unsent leads from local database
class GetUnsentLeads implements NoParamsUseCase<List<Lead>> {
  final LeadRepository repository;

  GetUnsentLeads(this.repository);

  @override
  Future<Either<Failure, List<Lead>>> call() async {
    return await repository.getUnsentLeads();
  }
}