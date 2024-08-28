import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:quran_project_app/models/quran_verse.dart';

class QuranService {
  final String baseUrl = "http://alquranmalayalam.net/alquran-api";

  Future<List<dynamic>> fetchSurahs() async {
    final response = await http.get(Uri.parse("$baseUrl/suranames/all"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chapters'];
    } else {
      throw Exception('Failed to load Surahs');
    }
  }
}
