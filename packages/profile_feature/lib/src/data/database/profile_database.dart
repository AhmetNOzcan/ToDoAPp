import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Owns the SQLite database used by the profile feature.
///
/// Each feature manages its own database file so that features remain
/// self-contained and can be added or removed without touching shared code.
class ProfileDatabase {
  static const _databaseName = 'profile_feature.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _open();
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL DEFAULT '',
        last_name TEXT NOT NULL DEFAULT '',
        photo_path TEXT
      )
    ''');

    // Seed a single profile row so that updates by id=1 always succeed.
    await db.insert('user_profile', {
      'first_name': '',
      'last_name': '',
      'photo_path': null,
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
