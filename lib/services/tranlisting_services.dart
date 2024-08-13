import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/services/dbservice.dart';

class TranListingServices {
  final dbProvider = DBService.dbProvider;

  Future openDB() async {
    return await dbProvider.openDB();
  }

  Future<List<TranLine>> getTranLines(
      {required int suraNo,
      int pageNo = 1,
      int perPage = 7,
      int inStartAyaNo = 1}) async {
    final db = await dbProvider.database;
    int startAyaNo =
        inStartAyaNo > 1 ? inStartAyaNo : (pageNo - 1) * perPage + 1;
    int endAyaNo = (pageNo - 1) * perPage + perPage;

    List<Map<String, dynamic>> result;
    String searchSql = '';
    String whereStr = '';
    if (suraNo > 0) {
      searchSql = "AND sura_no=$suraNo ";
      whereStr = "AND aya_no BETWEEN $startAyaNo AND $endAyaNo ";
    }
    try {
      result = await db.rawQuery(
          "SELECT line_id, sura_no, aya_no, malay_meaning, malwords, arabwords FROM trans_words  WHERE 1=1 $searchSql $whereStr ORDER BY sura_no, aya_no, line_id ");
      List<TranLine> lines = result.isNotEmpty
          ? result.map((item) => TranLine.fromMap(item)).toList()
          : [];
      if (lines.isNotEmpty) {
        int i = 0;
        for (TranLine rLine in lines) {
          if (i == 0 || (i > 0 && lines[i].ayaNo != lines[i - 1].ayaNo)) {
            rLine.malTran = '${rLine.ayaNo}. ${rLine.malTran}';
          }
          i++;
        }
      }
      return lines;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getSearchTranLines({required String queryString}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    String whereStr = '';

    whereStr = "AND malay_meaning LIKE '%$queryString%' ";
    try {
      result = await db.rawQuery(
          "SELECT line_id, sura_no, aya_no, malay_meaning, '' AS malwords, '' AS arabwords FROM trans_words  WHERE 1=1 $whereStr ORDER BY sura_no, aya_no, line_id ");
      List<TranLine> lines = result.isNotEmpty
          ? result.map((item) => TranLine.fromMap(item)).toList()
          : [];
      if (lines.length > 0) {
        int i = 0;
        for (TranLine rLine in lines) {
          if (i == 0 || (i > 0 && lines[i].ayaNo != lines[i - 1].ayaNo)) {
            rLine.malTran = rLine.ayaNo.toString() + '. ' + rLine.malTran;
          }
          i++;
        }
      }
      return lines;
    } catch (e) {
      return Future.error(e);
    }
  }
}
