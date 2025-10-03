import '../models/car_model.dart';
import '../../../lead/data/models/lead_model.dart';

/// Abstract local data source for cars and leads
abstract class CarLocalDataSource {
  /// Caches cars to local storage
  /// Throws [CacheException] for all error codes
  Future<void> cacheCars(List<CarModel> carsToCache);
  
  /// Gets cached cars from local storage
  /// Throws [CacheException] if no cached data is found
  Future<List<CarModel>> getLastCars();
  
  /// Saves a lead to local database
  /// Throws [CacheException] for all error codes
  Future<void> saveLead(LeadModel lead);
  
  /// Gets all leads from local database
  /// Throws [CacheException] for all error codes
  Future<List<LeadModel>> getLeads();
  
  /// Gets a specific lead by ID
  /// Throws [CacheException] if lead is not found
  Future<LeadModel?> getLeadById(int id);
  
  /// Deletes a lead from local database
  /// Throws [CacheException] for all error codes
  Future<void> deleteLead(int id);
}