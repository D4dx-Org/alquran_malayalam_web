// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {
  final String baseUrl = "https://alquranmalayalam.net/alquran-api";
  var ArticleId = 1;
  var surahNumber = 1;
  var AyaNumber = 1;
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

  Future<List<Map<String, dynamic>>> fetchAyaLines(
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
      throw Exception('Failed to load Aya');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSearchResult(
      String searchword) async {
    final response =
        await http.get(Uri.parse("$baseUrl/searchword/0/$searchword"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      // Fetch all surahs to get the MSuraName
      List<Map<String, dynamic>> surahs = await fetchSurahs();

      return data.map((item) {
        // Find the corresponding surah
        var surah = surahs.firstWhere((s) => s['SuraId'] == item['SuraNo'],
            orElse: () => {'MSuraName': 'Unknown'});

        return {
          "LineId": item["LineId"],
          "SuraNo": item["SuraNo"],
          "MSuraName": surah['MSuraName'],
          "AyaNo": item["AyaNo"],
          "MalTran": item["MalTran"],
          "LineWords": item["LineWords"],
        };
      }).toList();
    } else {
      throw Exception('Failed to load Search Results');
    }
  }

Future<List<Map<String, dynamic>>> fetchVerses(int surahNumber, int verseNumber) async {
    final response = await http.get(
      Uri.parse("$baseUrl/ayalines/$surahNumber/$verseNumber")
    );
    
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
      }).toList();
    } else {
      throw Exception('Failed to load verse');
    }
  }

  Future<List<Map<String, dynamic>>> fetchJuz(int juzNumber) async {
    final response =
        await http.get(Uri.parse("$baseUrl/juzsuraaya/$juzNumber"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map(
            (item) => {
              "SuraId": item["SuraId"],
              "ayafrom": item["ayafrom"],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load Juz');
    }
  }
}
