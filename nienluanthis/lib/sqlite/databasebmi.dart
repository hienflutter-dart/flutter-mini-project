import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseBmi {
  static final DatabaseBmi _instance = DatabaseBmi._internal();
  static Database? _database;

  factory DatabaseBmi() {
    return _instance;
  }

  DatabaseBmi._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bmi_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bmi_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        weight REAL,
        height REAL,
        date TEXT
      )
    ''');
  }

  Future<void> insertBMIData(String username, double weight, double height) async {
    final db = await database;
    DateTime now = DateTime.now();
    await db.insert(
      'bmi_data',
      {
        'username': username,
        'weight': weight,
        'height': height,
        'date': now.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getBMIData(String username) async {
    final db = await database;
    return await db.query(
      'bmi_data',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'date ASC',
    );
  }

  Future<Map<String, dynamic>?> getLastEntry(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'bmi_data',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
