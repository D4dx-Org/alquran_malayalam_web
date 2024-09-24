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

  // Future<List<QuranVerse>> fetchAyahs(int pageNumber) async {
  //   final response = await http.get(
  //       Uri.parse("$baseUrl/quran/verses/uthmani?page_number=$pageNumber"));

  //   if (response.statusCode == 200) {
  //     final ayahsData = jsonDecode(utf8.decode(response.bodyBytes));
  //     List<QuranVerse> ayahs = [];

  //     for (var verse in ayahsData['verses']) {
  //       ayahs.add(QuranVerse(
  //         verseNumber: verse['verse_key'].toString(),
  //         arabicText: verse['text_uthmani'].toString(),
  //       ));
  //     }

  //     return ayahs;
  //   } else {
  //     throw Exception(
  //         'Failed to load Ayahs for Surah $pageNumber: ${response.statusCode}');
  //   }
  // }

  Future<List<QuranVerse>> fetchAyahs(int pageNumber,int surahId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/quran/verses/uthmani?page_number=$pageNumber&chapter_number=$surahId"));

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
          'Failed to load Ayahs for Surah $pageNumber: ${response.statusCode}');
    }
  }

  Future<String?> fetchAyahAudio(String verseKey,
      {int recitationId = 7}) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/verses/by_key/$verseKey?audio=$recitationId"));
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
              audioUrl = 'https://audio.qurancdn.com/$audioUrl';
            }
            return audioUrl;
          }
        }
        return null;
      } else {
        throw Exception('Failed to load Ayah audio: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> fetchSurahAudio(int surahNumber,
      {int recitationId = 7}) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/recitations/$recitationId/by_chapter/$surahNumber"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final audioFiles = data['audio_files'] as List;

      return audioFiles.map((file) {
        String audioUrl = file['url'];
        if (!audioUrl.startsWith('http')) {
          return 'https://verses.quran.com/$audioUrl';
        }
        return audioUrl;
      }).toList();
    } else {
      throw Exception('Failed to load Surah audio: ${response.statusCode}');
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

  Future<String?> fetchBismiAudio({int recitationId = 7}) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/verses/by_key/1:1?audio=$recitationId"));
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
              audioUrl = 'https://audio.qurancdn.com/$audioUrl';
            }
            return audioUrl;
          }
        }
        return null;
      } else {
        throw Exception('Failed to load Ayah audio: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }
}
