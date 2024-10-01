// lib/controllers/reading_controller.dart

import 'package:alquran_web/models/content_peice.dart';
import 'package:alquran_web/services/surah_unicode_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/json_utils.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final JsonParser _jsonParser = JsonParser();

  var versesContent = <ContentPiece>[].obs;

  var currentPage = 1.obs;
  var currentSurahId = 1.obs;
  var isLoading = false.obs;

  late Map<int, List<int>> pageToSurahMap;
  List<ValueKey<int>> verseKeys = [];
  var hoveredVerseIndex = (-1).obs;

  // Variables to track loaded pages
  Set<int> loadedPages = {};
  int minPageLoaded = 1;
  int maxPageLoaded = 1;

  @override
  void onInit() {
    super.onInit();
    _loadPageToSurahMapping();
    // Fetch initial verses
    fetchVerses(direction: 'replace');
  }

  Future<void> _loadPageToSurahMapping() async {
    pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
  }

  Future<bool> fetchVerses({String direction = 'replace'}) async {
    int pageNumber;

    if (direction == 'next') {
      pageNumber = maxPageLoaded + 1;
      if (pageNumber > 604) {
        debugPrint('Already at the last page.');
        return true;
      }
    } else if (direction == 'previous') {
      pageNumber = minPageLoaded - 1;
      if (pageNumber < 1) {
        debugPrint('Already at the first page.');
        return true;
      }
    } else {
      // For 'replace' or initial load, use currentPage.value
      pageNumber = currentPage.value;
      minPageLoaded = pageNumber;
      maxPageLoaded = pageNumber;
      loadedPages.clear();
      versesContent.clear();
    }

    if (loadedPages.contains(pageNumber)) {
      debugPrint('Page $pageNumber already loaded.');
      return true;
    }

    isLoading.value = true;

    try {
      final surahIds = _getSurahIdsFromPageNumber(pageNumber);
      List<ContentPiece> combinedVersesContent = [];

      for (int surahId in surahIds) {
        // Fetch all the verses of the surah for the given page number
        final fetchedVerses =
            await _quranComService.fetchAyahs(pageNumber, surahId);

        if (fetchedVerses.isNotEmpty) {
          // Check if the surah starts on this page
          final firstVerseNumberInSurah =
              int.parse(fetchedVerses.first.verseNumber.split(':').last);

          if (firstVerseNumberInSurah == 1) {
            // Add Surah name as a separate ContentPiece
            combinedVersesContent.add(
              ContentPiece(
                text: getSurahNameUnicode(surahId),
                isSurahName: true,
              ),
            );

            // Add Basmala as a separate ContentPiece, excluding Surah 1 and 9
            if (surahId != 1 && surahId != 9) {
              combinedVersesContent.add(
                ContentPiece(text: '\uFDFD', isBismilla: true),
              );
            }
          }

          // Add verses as a separate ContentPiece
          combinedVersesContent.add(
            ContentPiece(
              text: _buildContinuousText(fetchedVerses),
              isBismilla: false,
            ),
          );
        }
        combinedVersesContent.add(
          ContentPiece(
            text: '',
            isDivider: true,
          ),
        );
      }

      // Update versesContent based on the scrolling direction
      if (direction == 'next') {
        versesContent.addAll(combinedVersesContent);
        maxPageLoaded = pageNumber;
      } else if (direction == 'previous') {
        versesContent.insertAll(0, combinedVersesContent);
        minPageLoaded = pageNumber;
      } else {
        versesContent.value = combinedVersesContent;
        minPageLoaded = pageNumber;
        maxPageLoaded = pageNumber;
      }

      loadedPages.add(pageNumber);

      return true; // Indicate that all verses have been fetched
    } catch (e) {
      debugPrint('Error fetching verses: $e');
      return false; // Indicate that there was an error
    } finally {
      isLoading.value = false;
      debugPrint('Fetching verses for Page: $pageNumber');
    }
  }

  List<int> _getSurahIdsFromPageNumber(int pageNumber) {
    final surahNumbers = pageToSurahMap[pageNumber];
    return surahNumbers ?? [];
  }

  Future<void> nextPage() async {
    if (currentPage.value >= 604) {
      debugPrint('Already at the last page: ${currentPage.value}');
      Get.snackbar(
        'End of Quran',
        'You have reached the last page.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }
    currentPage.value++;
    await fetchVerses(direction: 'next');
  }

  Future<void> previousPage() async {
    if (currentPage.value <= 1) {
      debugPrint('Already at the first page.');
      Get.snackbar(
        'Start of Quran',
        'You are already at the first page.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }
    currentPage.value--;
    await fetchVerses(direction: 'previous');
  }

  String _buildContinuousText(List<QuranVerse> verses) {
    verseKeys = [];
    return verses.map((verse) {
      final verseNumberInt = int.parse(verse.verseNumber.split(':').last);
      final key = ValueKey<int>(verseNumberInt);
      verseKeys.add(key);
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

  String getSurahNameUnicode(int surahId) {
    if (surahId < 1 || surahId > 114) {
      return '';
    }
    String unicodeChar = SurahUnicodeData.getSurahNameUnicode(surahId);
    return unicodeChar + String.fromCharCode(0xE000);
  }

  
}
