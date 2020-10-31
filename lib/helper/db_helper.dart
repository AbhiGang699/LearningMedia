import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
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

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    var articles = await db.query(table);
    return List.generate(articles.length, (index) => articles[index]['id']);
  }

  static Future<void> removeBookmark(id) async {
    final db = await DBHelper.database();
    await db.delete(
      'bookmark_articles',
      where: "id = ?",
      whereArgs: id,
    );
  }
}
