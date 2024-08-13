import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:alquran_malayalam/services/dbservice.dart';

class BookmarksServices {
  final dbProvider = DBService.dbProvider;

  Future openDB() async {
    return await dbProvider.openDB();
  }

  Future getAllBookmarks() async {
    final db = await dbProvider.database;

    try {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT, SuraId INTEGER, AyaNo INTEGER, SuraName TEXT )");
      var result = await db.rawQuery(
          "SELECT id, SuraId, AyaNo, SuraName FROM bookmarks ORDER BY id DESC");
      return result ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  // Adds new Bookmark records
  Future<int> createBookmark(Bookmark bmark) async {
    final db = await dbProvider.database;
    await db.execute(
        "CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT, SuraId INTEGER, AyaNo INTEGER, SuraName TEXT )");

    var result = await db.rawInsert(
        "INSERT INTO bookmarks (SuraId, AyaNo, SuraName) VALUES ( ${bmark.suraId}, ${bmark.ayaNo}, '${bmark.suraName}')");
    return result;
  }

  //Delete Bookmark records
  Future<int> deleteBookmark(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<int> deleteAllBookmarks() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'bookmarks',
    );
    return result;
  }
}
