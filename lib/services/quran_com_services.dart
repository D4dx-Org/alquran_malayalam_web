import 'dart:convert';
import 'package:alquran_web/models/verse_model.dart';
import 'package:http/http.dart' as http;

class QuranComService {
  final String baseUrl = "https://api.quran.com/api/v4";

  Future<List<dynamic>> fetchSurahs() async {
    final response = await http.get(Uri.parse("$baseUrl/chapters"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chapters'];
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  Future<Map<String, dynamic>> getSurahDetails(int surahNumber) async {
    final surahs = await fetchSurahs();
    final surah =
        surahs.firstWhere((s) => s['id'] == surahNumber, orElse: () => null);
    if (surah != null) {
      return {
        'name': surah['name_arabic'],
        'englishName': surah['name_simple'],
      };
    } else {
      throw Exception('Surah not found');
    }
  }

  Future<List<QuranVerse>> fetchAyahs(int surahId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/quran/verses/uthmani?chapter_number=$surahId"));

    if (response.statusCode == 200) {
      final ayahsData = jsonDecode(response.body);
      List<QuranVerse> ayahs = [];

      for (int i = 0; i < ayahsData['verses'].length; i++) {
        ayahs.add(QuranVerse(
          verseNumber: ayahsData['verses'][i]['verse_key'].toString(),
          arabicText: ayahsData['verses'][i]['text_uthmani'].toString(),
        ));
      }

      return ayahs;
    } else {
      throw Exception('Failed to load Ayahs');
    }
  }

  Future<String> fetchAyahAudio(int ayahId) async {
    final response = await http
        .get(Uri.parse("$baseUrl/verses/by_key/$ayahId/recitations/1"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['audio']['url'];
    } else {
      throw Exception('Failed to load Ayah audio');
    }
  }

  Future<List<QuranVerse>> searchAyahs(String query, String language) async {
    final response = await http
        .get(Uri.parse("$baseUrl/quran/search?q=$query&language=$language"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<QuranVerse> results = [];
      for (var item in data['results']) {
        results.add(QuranVerse(
          verseNumber: '${item['sura']['id']}:${item['ayah']['id']}',
          arabicText: item['ayah']['text'],
        ));
      }
      return results;
    } else {
      throw Exception('Failed to search Ayahs');
    }
  }
}
