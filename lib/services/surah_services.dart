import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/services/dbservice.dart';

class SurahServices {
  final dbProvider = DBService.dbProvider;

  Future openDB() async {
    return await dbProvider.openDB();
  }

  //Get All Surah Names
  //Searches if query string was passed
  Future getSurahs({String searchKey = ''}) async {
    final db = await dbProvider.database;
    String searchSql = '';
    if (searchKey.isNotEmpty) {
      searchSql =
          "AND (`ASuraName` LIKE '%$searchKey%' OR `MSuraName` LIKE '%$searchKey%')";
    }
    try {
      var result = await db?.rawQuery(
          "SELECT * FROM suratable WHERE 1 = 1 $searchSql ORDER BY `Sura_id` ASC");
      return result ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getSurah(int id) async {
    final db = await dbProvider.database;
    try {
      var result =
          await db?.rawQuery('SELECT * FROM suratable WHERE Sura_id = $id');
      if (result.length == 0) return null;
      return Surah.fromMap(result[0]);
    } catch (e) {
      return Future.error(e);
    }
  }
}
