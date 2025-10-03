import '../models/lead_model.dart';

/// Abstract remote data source for lead operations
abstract class LeadRemoteDataSource {
  /// Sends a lead to the WSWork API
  Future<void> sendLead(LeadModel lead);
  
  /// Sends multiple leads to the WSWork API
  Future<void> sendLeads(List<LeadModel> leads);
}