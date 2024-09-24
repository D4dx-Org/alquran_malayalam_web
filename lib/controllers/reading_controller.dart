import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/json_utils.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final JsonParser _jsonParser = JsonParser();
  var versesText = ''.obs;
  var currentPage = 1.obs;
  var currentSurahId = 1.obs;
  var isLoading = false.obs;
  late Map<int, List<int>> pageToSurahMap;
  List<ValueKey<String>> verseKeys = [];
  var hoveredVerseIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadPageToSurahMapping();
  }

  Future<void> _loadPageToSurahMapping() async {
    pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
  }

  Future<void> fetchVerses(int pageNumber) async {
    isLoading.value = true;

    try {
      currentSurahId.value = _getSurahIdFromPageNumber(pageNumber);
      final fetchedVerses = await _quranComService.fetchAyahs(pageNumber);
      versesText.value = _buildContinuousText(fetchedVerses);
    } catch (e) {
      debugPrint('Error fetching verses: $e');
    } finally {
      isLoading.value = false;
      debugPrint(
          'Fetching verses for Surah ID: ${currentSurahId.value}, Page: ${currentPage.value}');
    }
  }

  int _getSurahIdFromPageNumber(int pageNumber) {
    final surahNumbers = pageToSurahMap[pageNumber];
    if (surahNumbers != null && surahNumbers.isNotEmpty) {
      return surahNumbers.first;
    }
    return 1; // Default to Surah 1 if the page number is not found in the map
  }

  Future<void> nextPage() async {
    currentPage.value++;
    await fetchVerses(currentPage.value);
  }

  Future<void> previousPage() async {
    if (currentPage.value > 1) {
      currentPage.value--;
      await fetchVerses(currentPage.value);
    }
  }

  Future<void> nextSurah() async {
    final nextSurahId = _getNextSurahId(currentSurahId.value);
    if (nextSurahId != null) {
      currentSurahId.value = nextSurahId;
      currentPage.value = _getFirstPageForSurah(nextSurahId);
      await fetchVerses(currentPage.value);
      debugPrint('Current Surah ID: ${currentSurahId.value}');
    }
  }

  Future<void> previousSurah() async {
    final previousSurahId = _getPreviousSurahId(currentSurahId.value);
    if (previousSurahId != null) {
      currentSurahId.value = previousSurahId;
      currentPage.value = _getFirstPageForSurah(previousSurahId);
      await fetchVerses(currentPage.value);
      debugPrint('Current Surah ID: ${currentSurahId.value}');
    }
  }

  int? _getNextSurahId(int currentSurahId) {
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(currentSurahId)) {
        final index = entry.value.indexOf(currentSurahId);
        if (index < entry.value.length - 1) {
          return entry.value[index + 1];
        }
      }
    }
    return null; // No next Surah ID found
  }

  int? _getPreviousSurahId(int currentSurahId) {
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(currentSurahId)) {
        final index = entry.value.indexOf(currentSurahId);
        if (index > 0) {
          return entry.value[index - 1];
        }
      }
    }
    return null; // No previous Surah ID found
  }

  int _getFirstPageForSurah(int surahId) {
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(surahId)) {
        return entry.key;
      }
    }
    return 1; // Default to page 1 if the Surah ID is not found
  }

  String _buildContinuousText(List<QuranVerse> verses) {
    verseKeys = []; // Reset the keys list
    return verses.map((verse) {
      final key = ValueKey(verse.verseNumber); // Use verse number as the key
      verseKeys.add(key); // Add the key to the list
      return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(verse.verseNumber.split(':').last)}\uFD3E ';
    }).join();
  }



  String _convertToArabicNumbers(String number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }
}
