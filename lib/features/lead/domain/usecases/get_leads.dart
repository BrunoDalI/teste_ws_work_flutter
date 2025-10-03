import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lead.dart';
import '../repositories/lead_repository.dart';

/// Use case to get all leads
class GetLeads implements NoParamsUseCase<List<Lead>> {
  final LeadRepository repository;

  GetLeads(this.repository);

  @override
  Future<Either<Failure, List<Lead>>> call() async {
    return await repository.getLeads();
  }
}