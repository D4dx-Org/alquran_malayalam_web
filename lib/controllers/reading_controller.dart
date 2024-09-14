import 'package:alquran_web/services/surah_unicode_data.dart';
import 'package:get/get.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final SharedPreferences sharedPreferences;

  final RxList<QuranVerse> verses = <QuranVerse>[].obs;
  Map<String, String> surahNameMapping = {};
  final RxBool isLoading = false.obs;
  final RxString surahName = ''.obs;
  final RxString surahEnglishName = ''.obs;
  final RxInt currentSurahId = 1.obs;

  ReadingController({required this.sharedPreferences});

  @override
  void onInit() {
    super.onInit();

    _loadLastReadSurah();
  }

  void _loadLastReadSurah() {
    final lastReadSurahId = sharedPreferences.getInt('lastReadSurahId') ?? 1;
    fetchSurah(lastReadSurahId);
  }

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

      currentSurahId.value = surahId;

      // Save the current surah id
      sharedPreferences.setInt('lastReadSurahId', surahId);

      // Print the ayahs
      // printAyahs();
    } catch (e) {
      // You might want to show an error message to the user here
    } finally {
      isLoading.value = false;
    }
  }

  String getArabicSurahName() => surahName.value;
  String getEnglishSurahName() => surahEnglishName.value;
  int getVerseCount() => verses.length;
  bool isEndOfSurah(int index) => index >= verses.length - 1;

  void nextSurah() {
    if (currentSurahId.value < 114) {
      fetchSurah(currentSurahId.value + 1);
    }
  }

  void previousSurah() {
    if (currentSurahId.value > 1) {
      fetchSurah(currentSurahId.value - 1);
    }
  }

  String getSurahNameUnicode(int surahId) {
    if (surahId < 1 || surahId > 114) {
      return '';
    }
    String unicodeChar = SurahUnicodeData.getSurahNameUnicode(surahId);
    return unicodeChar + String.fromCharCode(0xE000);
  }
}
