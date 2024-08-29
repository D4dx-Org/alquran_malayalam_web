import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:quran_project_app/models/quran_verse.dart';

class QuranService {
  final String baseUrl = "http://alquranmalayalam.net/alquran-api";
  // ignore: non_constant_identifier_names
  var ArticleId = 1;

  Future<List<Map<String, dynamic>>> fetchSurahs() async {
    final response = await http.get(Uri.parse("$baseUrl/suranames"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map((item) => {
                "SuraId": item["SuraId"],
                "ASuraName": item["ASuraName"],
                "MSuraName": item["MSuraName"],
                "SuraType": item["SuraType"],
                "MalMean": item["MalMean"],
                "TotalAyas": item["TotalAyas"],
                "TotalLines": item["TotalLines"],
              })
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
      throw Exception('Failed to load Publishersbio');
    }
  }
}
