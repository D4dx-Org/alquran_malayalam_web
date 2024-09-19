import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/services/surah_unicode_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final SharedPreferences sharedPreferences;
  final ItemScrollController itemScrollController = ItemScrollController();
  final _quranController = Get.find<QuranController>();

  final RxList<QuranVerse> verses = <QuranVerse>[].obs;
  Map<String, String> surahNameMapping = {};
  final RxBool isLoading = false.obs;
  final RxString surahName = ''.obs;
  final RxString surahEnglishName = ''.obs;
  final RxInt currentSurahId = 1.obs;

  ReadingController({required this.sharedPreferences});

  @override
  void onInit() {
    loadLastReadSurah();
    super.onInit();
  }

  void scrollToVerse(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Update the selected Ayah number in QuranController
    if (index < verses.length) {
      final quranController = QuranController.instance;
      quranController
          .updateSelectedAyahNumber(_quranController.selectedAyahNumber);
    }
  }

  void loadLastReadSurah() {
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

      // Clear previous verses
      verses.clear();

      // Fetch verses using the fetchAyahs method
      await loadVerses(
          surahId); // Assuming surahId corresponds to the page number

      currentSurahId.value = surahId;

      // Save the current surah id
      sharedPreferences.setInt('lastReadSurahId', surahId);

      // Notify the UI that the surah has been updated
      update();
    } catch (e) {
      // Handle error (e.g., show a message to the user)
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadVerses(int pageNumber) async {
    isLoading.value = true;
    try {
      final fetchedVerses = await _quranComService.fetchAyahs(pageNumber);
      for (var verse in fetchedVerses) {
        verses.add(verse); // Load each ayah separately
      }
    } catch (e) {
      // Handle error (e.g., show a message to the user)
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
