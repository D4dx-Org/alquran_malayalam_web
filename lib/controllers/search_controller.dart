import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:get/get.dart';

class QuranSearchController extends GetxController {
  final QuranService quranService = QuranService();
  final QuranComService quranComService = QuranComService();
  final searchQuery = ''.obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

   bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

   Future<void> performSearch() async {
    if (searchQuery.isEmpty) return;

    isLoading.value = true;
    try {
      if (_containsArabic(searchQuery.value)) {
        // Handle Arabic search using QuranComService
        final arabicResults = await quranComService.searchAyas(searchQuery.value);
        
        // Convert the results to match the expected format for UI
        searchResults.value = await Future.wait(arabicResults.map((verse) async {
          // Get surah details to get the name
          final surahNumber = int.parse(verse.verseKey.split(':')[0]);
          final surahDetails = await quranComService.getSurahDetails(surahNumber);
          
          return {
            "SuraNo": surahNumber,
            "AyaNo": int.parse(verse.verseKey.split(':')[1]),
            "MSuraName": surahDetails['name'], // Arabic name from QuranComService
            "MalTran": verse.text, // Arabic text
            "LineWords": verse.words.map((word) => {
              "ArabWord": word.text,
              "MalWord": "", // Empty as we don't have Malayalam translation here
            }).toList(),
          };
        }));
      } else {
        // Handle Malayalam/default search using QuranService
        searchResults.value = await quranService.fetchSearchResult(searchQuery.value);
      }
    } catch (e) {
      print('Search error: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
  String get currentSearchQuery => searchQuery.value;
}
