import 'package:alquran_malayalam/models/article.dart';
import 'package:alquran_malayalam/services/dbservice.dart';

class ArticlesServices {
  final dbProvider = DBService.dbProvider;

  Future openDB() async {
    return await dbProvider.openDB();
  }

  // get Article of given article id from table.
  Future getArticle(int articleId) async {
    final db = await dbProvider.database;
    try {
      var article = await db.rawQuery(
          "SELECT aid, title, matter FROM articles WHERE aid = $articleId");
      if (article.length == 0) return null;
      return Article.fromMap(article[0]);
    } catch (e) {
      return Future.error(e);
    }
  }
}
