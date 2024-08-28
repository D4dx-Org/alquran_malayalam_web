import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:quran_project_app/models/quran_verse.dart';

class QuranService {
  final String baseUrl = "http://alquranmalayalam.net/alquran-api";

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
}
