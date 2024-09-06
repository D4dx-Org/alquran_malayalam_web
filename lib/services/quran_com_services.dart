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
      throw Exception('Failed to load Surahs: ${response.statusCode}');
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
      throw Exception('Surah not found: $surahNumber');
    }
  }

  Future<List<QuranVerse>> fetchAyahs(int surahId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/quran/verses/uthmani?chapter_number=$surahId"));

    if (response.statusCode == 200) {
      final ayahsData = jsonDecode(utf8.decode(response.bodyBytes));
      List<QuranVerse> ayahs = [];

      for (var verse in ayahsData['verses']) {
        ayahs.add(QuranVerse(
          verseNumber: verse['verse_key'].toString(),
          arabicText: verse['text_uthmani'].toString(),
        ));
      }

      return ayahs;
    } else {
      throw Exception(
          'Failed to load Ayahs for Surah $surahId: ${response.statusCode}');
    }
  }

  Future<String?> fetchAyahAudio(String verseKey) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/verses/by_key/$verseKey?audio=1"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final verse = data['verse'] as Map<String, dynamic>?;
        if (verse != null && verse.containsKey('audio')) {
          final audio = verse['audio'] as Map<String, dynamic>?;
          if (audio != null && audio.containsKey('url')) {
            String audioUrl = audio['url'] as String;
            // Check if the audioUrl is a relative path
            if (!audioUrl.startsWith('http')) {
              // Prepend the base URL if necessary
              audioUrl = 'https://audio.qurancdn.com/' + audioUrl;
            }
            return audioUrl;
          }
        }
        print('No audio URL found for verse $verseKey');
        return null;
      } else {
        throw Exception('Failed to load Ayah audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching audio for verse $verseKey: $e');
      return null;
    }
  }

  Future<List<QuranVerse>> searchAyahs(String query, String language) async {
    final response = await http
        .get(Uri.parse("$baseUrl/search?q=$query&language=$language"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<QuranVerse> results = [];
      for (var item in data['search']['results']) {
        results.add(QuranVerse(
          verseNumber: item['verse_key'],
          arabicText: item['text'],
        ));
      }
      return results;
    } else {
      throw Exception('Failed to search Ayahs: ${response.statusCode}');
    }
  }
}
