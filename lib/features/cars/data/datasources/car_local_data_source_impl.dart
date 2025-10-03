import 'package:sqflite/sqflite.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/car_model.dart';
import '../../../lead/data/models/lead_model.dart';
import 'car_local_data_source.dart';

const String cachedCars = 'CACHED_CARS';
const String carsTable = 'cars';
const String leadsTable = 'leads';

/// Implementation of [CarLocalDataSource] using SQLite
class CarLocalDataSourceImpl implements CarLocalDataSource {
  final Database database;

  CarLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheCars(List<CarModel> carsToCache) async {
    try {
      // Clear existing cached cars
      await database.delete(carsTable);
      
      // Insert new cars
      for (final car in carsToCache) {
        await database.insert(
          carsTable,
          car.toMap(), // Usar toMap() para SQLite
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      throw CacheException('Failed to cache cars: $e');
    }
  }

  @override
  Future<List<CarModel>> getLastCars() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(carsTable);
      
      if (maps.isEmpty) {
        throw const CacheException('No cached cars found');
      }
      
      return maps.map((map) => CarModel.fromMap(map)).toList(); // Usar fromMap() para SQLite
    } catch (e) {
      throw CacheException('Failed to get cached cars: $e');
    }
  }

  @override
  Future<void> saveLead(LeadModel lead) async {
    try {
      await database.insert(
        leadsTable,
        lead.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to save lead: $e');
    }
  }

  @override
  Future<List<LeadModel>> getLeads() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        leadsTable,
        orderBy: 'createdAt DESC',
      );
      
      return maps.map((map) => LeadModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get leads: $e');
    }
  }

  @override
  Future<LeadModel?> getLeadById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        leadsTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return LeadModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get lead by ID: $e');
    }
  }

  @override
  Future<void> deleteLead(int id) async {
    try {
      await database.delete(
        leadsTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to delete lead: $e');
    }
  }

  @override
  Future<List<LeadModel>> getUnsentLeads() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        leadsTable,
        where: 'isSent = ?',
        whereArgs: [0], // 0 = false
        orderBy: 'createdAt ASC',
      );
      
      return maps.map((map) => LeadModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get unsent leads: $e');
    }
  }

  @override
  Future<void> markLeadAsSent(int id) async {
    try {
      await database.update(
        leadsTable,
        {'isSent': 1}, // 1 = true
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to mark lead as sent: $e');
    }
  }
}