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
  
  /// Sends a lead to the remote API
  Future<Either<Failure, void>> sendLead(Lead lead);
  
  /// Sends multiple leads to the remote API
  Future<Either<Failure, void>> sendLeads(List<Lead> leads);
  
  /// Gets unsent leads from the local database
  Future<Either<Failure, List<Lead>>> getUnsentLeads();
  
  /// Marks a lead as sent
  Future<Either<Failure, void>> markLeadAsSent(int id);
}

/*
Resumo (LeadRepository):
Contrato único agregando operações CRUD locais, consulta de pendentes e envio (single/batch).
Separação permite que AutoSyncService e casos de uso fiquem desacoplados da implementação
(ex: SQLite + HTTP). markLeadAsSent isola semântica de atualização pós-envio.
*/