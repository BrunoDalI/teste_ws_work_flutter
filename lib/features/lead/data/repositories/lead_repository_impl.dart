import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lead.dart';
import '../../domain/repositories/lead_repository.dart';
import '../../../cars/data/datasources/car_local_data_source.dart';
import '../models/lead_model.dart';

/// Implementation of [LeadRepository]
class LeadRepositoryImpl implements LeadRepository {
  final CarLocalDataSource localDataSource;

  LeadRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveLead(Lead lead) async {
    try {
      final leadModel = LeadModel.fromEntity(lead);
      await localDataSource.saveLead(leadModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lead>>> getLeads() async {
    try {
      final leadModels = await localDataSource.getLeads();
      return Right(leadModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Lead?>> getLeadById(int id) async {
    try {
      final leadModel = await localDataSource.getLeadById(id);
      return Right(leadModel?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLead(int id) async {
    try {
      await localDataSource.deleteLead(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}