import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {
  final String baseUrl = "https://alquranmalayalam.net/alquran-api";
  // ignore: non_constant_identifier_names
  var ArticleId = 1;
  var surahNumber = 1;
  var ayahNumber = 1;
  var pageNumber = 0;
  String searchword = '';

  Future<List<Map<String, dynamic>>> fetchSurahs() async {
    final response = await http.get(Uri.parse("$baseUrl/suranames"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map(
            (item) => {
              "SuraId": item["SuraId"],
              "ASuraName": item["ASuraName"],
              "MSuraName": item["MSuraName"],
              "SuraType": item["SuraType"],
              "MalMean": item["MalMean"],
              "TotalAyas": item["TotalAyas"],
              "TotalLines": item["TotalLines"],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  Future<List<String>> fetchAbout() async {
    final response = await http.get(Uri.parse("$baseUrl/articles/$ArticleId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item['matter'] as String).toList();
    } else {
      throw Exception('Failed to load Articles');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAyahLines(
      int surahNumber, int currentPage) async {
    pageNumber = currentPage;
    final response = await http
        .get(Uri.parse("$baseUrl/linetrans/$surahNumber/$pageNumber"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) {
        return {
          "LineId": item["LineId"],
          "SuraNo": item["SuraNo"],
          "AyaNo": item["AyaNo"],
          "MalTran": item["MalTran"],
          "LineWords": (item["LineWords"] as List<dynamic>).map((wordItem) {
            return {
              "MalWord": wordItem["MalWord"],
              "ArabWord": wordItem["ArabWord"],
            };
          }).toList(),
        };
      }).toList(); // Call toList() here
    } else {
      throw Exception('Failed to load Ayah');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSearchResult(
      String searchword) async {
    final response =
        await http.get(Uri.parse("$baseUrl/searchword/0/$searchword"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map(
            (item) => {
              "LineId": item["LineId"],
              "SuraNo": item["SuraNo"],
              "AyaNo": item["AyaNo"],
              "MalTran": item["MalTran"],
              "LineWords": item["LineWords"],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load Search Results');
    }
  }
}
