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

  // Updated from versesText (String) to versesContent (List of ContentPiece)
  var versesContent = <ContentPiece>[].obs;

  var currentPage = 604.obs;
  var currentSurahId = 1.obs;
  var isLoading = false.obs;

  late Map<int, List<int>> pageToSurahMap;
  List<ValueKey<int>> verseKeys = [];
  var hoveredVerseIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadPageToSurahMapping();
    // Fetch initial verses if needed
    fetchVerses(currentPage.value);
  }

  /// Loads the mapping of pages to Surah IDs from JSON data.
  Future<void> _loadPageToSurahMapping() async {
    pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
  }

  Future<bool> fetchVerses(int pageNumber) async {
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
          if (firstVerseNumberInSurah == 1 && surahId != 1 && surahId != 9) {
            // Add Basmala as a separate ContentPiece
            combinedVersesContent.add(
              ContentPiece(text: '\uFDFD', isBismilla: true),
            );
          }

          // Add verses as a separate ContentPiece
          combinedVersesContent.add(
            ContentPiece(
              text: _buildContinuousText(fetchedVerses),
              isBismilla: false,
            ),
          );
        }
      }

      versesContent.value = combinedVersesContent;
      return true; // Indicate that all verses have been fetched
    } catch (e) {
      debugPrint('Error fetching verses: $e');
      return false; // Indicate that there was an error
    } finally {
      isLoading.value = false;
      debugPrint('Fetching verses for Page: ${currentPage.value}');
    }
  }

  /// Retrieves the list of Surah IDs associated with the given [pageNumber].
  List<int> _getSurahIdsFromPageNumber(int pageNumber) {
    final surahNumbers = pageToSurahMap[pageNumber];
    return surahNumbers ?? []; // Return all Surah IDs for the page
  }

  /// Retrieves the first Surah ID from the given [pageNumber].
  int _getSurahIdFromPageNumber(int pageNumber) {
    final surahNumbers = pageToSurahMap[pageNumber];
    if (surahNumbers != null && surahNumbers.isNotEmpty) {
      return surahNumbers.first;
    }
    return 1; // Default to Surah 1 if the page number is not found in the map
  }

  /// Navigates to the next page, if not already at the last page.
  Future<void> nextPage() async {
    if (currentPage.value >= 604) {
      // Assuming 604 is the last page
      debugPrint('Already at the last page: ${currentPage.value}');
      // Optionally, show a Snackbar or Toast
      Get.snackbar(
        'End of Quran',
        'You have reached the last page.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }
    currentPage.value++;
    await fetchVerses(currentPage.value);
  }

  /// Navigates to the previous page, if not already at the first page.
  Future<void> previousPage() async {
    if (currentPage.value <= 1) {
      debugPrint('Already at the first page.');
      // Optionally, show a Snackbar or Toast
      Get.snackbar(
        'Start of Quran',
        'You are already at the first page.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }
    currentPage.value--;
    await fetchVerses(currentPage.value);
  }

  /// Navigates to the next Surah, if possible.
  Future<void> nextSurah() async {
    final nextSurahId = _getNextSurahId(currentSurahId.value);
    if (nextSurahId != null) {
      currentSurahId.value = nextSurahId;
      currentPage.value = _getFirstPageForSurah(nextSurahId);
      await fetchVerses(currentPage.value);
      debugPrint('Current Surah ID: ${currentSurahId.value}');
    }
  }

  /// Navigates to the previous Surah, if possible.
  Future<void> previousSurah() async {
    final previousSurahId = _getPreviousSurahId(currentSurahId.value);
    if (previousSurahId != null) {
      currentSurahId.value = previousSurahId;
      currentPage.value = _getFirstPageForSurah(previousSurahId);
      await fetchVerses(currentPage.value);
      debugPrint('Current Surah ID: ${currentSurahId.value}');
    }
  }

  /// Retrieves the next Surah ID based on the [currentSurahId].
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

  /// Retrieves the previous Surah ID based on the [currentSurahId].
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

  /// Retrieves the first page number where the given [surahId] starts.
  int _getFirstPageForSurah(int surahId) {
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(surahId)) {
        return entry.key;
      }
    }
    return 1; // Default to page 1 if the Surah ID is not found
  }

  /// Builds a continuous text string from the list of [verses].
  /// This method also populates [verseKeys] for potential UI interactions.
  String _buildContinuousText(List<QuranVerse> verses) {
    verseKeys = []; // Reset the keys list
    return verses.map((verse) {
      final verseNumberInt =
          int.parse(verse.verseNumber.split(':').last); // Convert to int
      final key = ValueKey<int>(verseNumberInt); // Use verse number as the key
      verseKeys.add(key); // Add the key to the list
      return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(verse.verseNumber.split(':').last)}\uFD3E ';
    }).join();
  }

  /// Converts a string [number] to its corresponding Arabic numerals.
  String _convertToArabicNumbers(String number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  /// Retrieves the Unicode name of the Surah based on [surahId].
  String getSurahNameUnicode(int surahId) {
    if (surahId < 1 || surahId > 114) {
      return '';
    }
    String unicodeChar = SurahUnicodeData.getSurahNameUnicode(surahId);
    return unicodeChar + String.fromCharCode(0xE000);
  }
}
