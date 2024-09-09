import 'package:alquran_web/services/quran_services.dart';
import 'package:get/get.dart';

class QuranSearchController extends GetxController {
  final QuranService quranService = QuranService();
  final searchQuery = ''.obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> performSearch() async {
    if (searchQuery.isEmpty) return;

    isLoading.value = true;
    try {
      searchResults.value =
          await quranService.fetchSearchResult(searchQuery.value);
    } catch (e) {
      print('Error fetching search results: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  

  String get currentSearchQuery => searchQuery.value;
}
