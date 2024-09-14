import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class Databaseuser {
  static const _databaseName = 'user.db';
  static const _databaseVersion = 1;
  static const _tableNameUser = 'users';

  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnEmail = 'email';
  static const columnBirthDate = 'birthDate';
  static const columnGender = 'gender';
  static const columnWeight = 'weight';
  static const columnPassword = 'password';
  static const columnHeight = 'height';

  static const String tableUserSql = '''
  CREATE TABLE $_tableNameUser (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnUsername TEXT NOT NULL,
    $columnEmail TEXT NOT NULL UNIQUE,
    $columnBirthDate TEXT,
    $columnGender TEXT,
    $columnWeight REAL,
    $columnHeight REAL,  
    $columnPassword TEXT
  )
''';


  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(tableUserSql);
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    final res = await db.insert(_tableNameUser, user.toMap());
    return res;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableNameUser);

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await _database;
    if (db == null) {
      throw Exception('Database is not initialized');
    }

    // Tạo Map chứa các trường cần cập nhật, không bao gồm mật khẩu
    final userData = {
      'username': user.username,
      'email': user.email,
      'birthDate': user.birthDate.toIso8601String(), // Đảm bảo chuyển đổi DateTime thành String
      'gender': user.gender,
      'weight': user.weight,
      'height': user.height,
    };

    // Cập nhật thông tin người dùng trong cơ sở dữ liệu
    final res = await db.update(
      _tableNameUser,
      userData,
      where: '$columnId = ?',
      whereArgs: [user.id],
    );

    return res;
  }

  Future<User?> getUserByUsernameAndPassword(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableNameUser,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      _tableNameUser,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableNameUser,
      where: '$columnId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

}
