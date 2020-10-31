import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'bookmark.db'),
        onCreate: (db, version) {
      return db.execute('CREATE TABLE bookmark_articles(id TEXT PRIMARY KEY)');
    }, version: 1);
  }

  static Future<void> insert(String table, String article) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      {
        'id': article,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<String>> getData(String table) async {
    final db = await DBHelper.database();
    var articles = await db.query(table);
    return List.generate(articles.length, (index) => articles[index]['id']);
  }

  static Future<void> removeBookmark(String table, String id) async {
    final db = await DBHelper.database();
    await db.delete(
      'bookmark_articles',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<bool> check(String table, String id) async {
    final db = await DBHelper.database();
    var queryResult = await db.rawQuery('SELECT * FROM $table WHERE id =$id');
    if (queryResult.isEmpty) return false;
    return true;
  }
}
