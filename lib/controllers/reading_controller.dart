
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:get/get.dart';
import 'package:alquran_web/models/verse_model.dart';

class QuranApiController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  
  final RxList<QuranVerse> verses = <QuranVerse>[].obs;
  final RxBool isLoading = false.obs;
  final RxString surahName = ''.obs;
  final RxString surahEnglishName = ''.obs;

  Future<void> fetchSurah(int surahId) async {
    isLoading.value = true;
    try {
      // Fetch surah details
      final surahDetails = await _quranComService.getSurahDetails(surahId);
      surahName.value = surahDetails['name'];
      surahEnglishName.value = surahDetails['englishName'];

      // Fetch verses
      final fetchedVerses = await _quranComService.fetchAyahs(surahId);
      verses.assignAll(fetchedVerses);
    } catch (e) {
      print('Error fetching surah: $e');
      // You might want to show an error message to the user here
    } finally {
      isLoading.value = false;
    }
  }

  String getArabicSurahName() => surahName.value;
  String getEnglishSurahName() => surahEnglishName.value;
  int getVerseCount() => verses.length;
  bool isEndOfSurah(int index) => index >= verses.length - 1;
}
