import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lead.dart';

/// Abstract repository for lead-related operations
abstract class LeadRepository {
  /// Saves a lead to the local database
  Future<Either<Failure, void>> saveLead(Lead lead);
  
  /// Gets all leads from the local database
  Future<Either<Failure, List<Lead>>> getLeads();
  
  /// Gets a specific lead by ID
  Future<Either<Failure, Lead?>> getLeadById(int id);
  
  /// Deletes a lead from the local database
  Future<Either<Failure, void>> deleteLead(int id);
}