import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), "MyLeaves.db"),
      onCreate: (db, version) {
        db.execute("CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, note TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertNote(String title, String note) async {
    final db = await database;
    await db.rawInsert("INSERT INTO notes(title, note) VALUES(?, ?)", [title, note]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.rawDelete("DELETE FROM notes WHERE id = ?", [id]);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query("notes"); // Fetch all rows from 'notes' table
  }
}
