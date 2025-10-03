import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Database helper for managing SQLite database
class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'cars_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String carsTable = 'cars';
  static const String leadsTable = 'leads';

  /// Get the database instance
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Create tables when database is first created
  static Future<void> _onCreate(Database db, int version) async {
    // Create cars table
    await db.execute('''
      CREATE TABLE $carsTable (
        id INTEGER PRIMARY KEY,
        timestampCadastro INTEGER NOT NULL,
        modeloId INTEGER NOT NULL,
        ano INTEGER NOT NULL,
        combustivel TEXT NOT NULL,
        numPortas INTEGER NOT NULL,
        cor TEXT NOT NULL,
        nomeModelo TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');

    // Create leads table
    await db.execute('''
      CREATE TABLE $leadsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carId INTEGER NOT NULL,
        userName TEXT NOT NULL,
        userEmail TEXT NOT NULL,
        userPhone TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        carModel TEXT NOT NULL,
        carValue REAL NOT NULL
      )
    ''');
  }

  /// Close the database
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}