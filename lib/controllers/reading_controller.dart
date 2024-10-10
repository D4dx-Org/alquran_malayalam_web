// lib/controllers/reading_controller.dart

import 'package:alquran_web/models/content_peice.dart';
import 'package:alquran_web/services/surah_unicode_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final JsonParser _jsonParser = JsonParser();
  ScrollController scrollController = ScrollController();
  var versesContent = <ContentPiece>[].obs;
  late SharedPreferences _sharedPreferences;

  List<ValueKey<String>> verseKeys = [];
  Set<int> loadedPages = {};
  late Map<int, List<int>> pageToSurahMap;
  var currentPage = 1.obs;
  var isLoading = false.obs;
  var hoveredVerseIndex = (-1).obs;
  int minPageLoaded = 1;
  int maxPageLoaded = 1;

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadPageToSurahMapping();
    pageToSurahMap = {};
    _sharedPreferences = await SharedPreferences.getInstance();
    // Load saved preferences for current page
    _loadSavedPreferences();
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
            await _quranComService.fetchAyas(pageNumber, surahId);

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
                surahId: surahId,
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
              text: _buildContinuousText(fetchedVerses, surahId),
              isBismilla: false,
            ),
          );
        }
      }

      // Add the divider at the end of the content for the page
      combinedVersesContent.add(
        ContentPiece(
          text: '',
          isDivider: true,
        ),
      );

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
      _saveCurrentPage(pageNumber); // Save current page

      return true; // Indicate that all verses have been fetched
    } catch (e) {
      debugPrint('Error fetching verses: $e');
      return false; // Indicate that there was an error
    } finally {
      isLoading.value = false;
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
    _saveCurrentPage(currentPage.value); // Save the new page
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
    _saveCurrentPage(currentPage.value); // Save the new page
  }

  String _buildContinuousText(List<QuranVerse> verses, int surahId) {
    verseKeys.clear();
    return verses.map((verse) {
      final AyaNumber = verse.verseNumber.split(':').last;
      final key = ValueKey<String>("$surahId:$AyaNumber");
      verseKeys.add(key);
      return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(AyaNumber)}\uFD3E ';
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

  Future<void> navigateToSurah(
      int surahId, ScrollController scrollController) async {
    // Find the pages associated with the surah from the JSON mapping
    List<int> pagesToLoad = _findPagesForSurah(surahId);

    if (pagesToLoad.isEmpty) {
      debugPrint('No pages found for Surah $surahId');
      return;
    }

    // Directly load the first page containing the surah
    int targetPage = pagesToLoad.first;

    // Fetch verses for the specific target page containing the Surah
    currentPage.value = targetPage;
    await fetchVerses(direction: 'replace');

    // Find the index of the Surah name in the content
    int index = versesContent.indexWhere(
      (piece) => piece.isSurahName && piece.surahId == surahId,
    );

    if (index != -1) {
      _scrollToIndex(index, scrollController);
    }
  }

  void navigateToSpecificSurah(int surahId) {
    navigateToSurah(surahId, scrollController);
    _saveLastReadVerse(
        surahId, 1); // Save the surah and verse number (change as needed)
  }

  List<int> _findPagesForSurah(int surahId) {
    // Return the list of pages containing the given Surah ID from the mapping
    return pageToSurahMap.entries
        .where((entry) => entry.value.contains(surahId))
        .map((entry) => entry.key)
        .toList();
  }

  void _scrollToIndex(int index, ScrollController scrollController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final offset = index * 100.0;
      scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _loadSavedPreferences() {
    // Load the last saved page number from shared preferences if available
    final savedPage = _sharedPreferences.getInt('currentPage');
    if (savedPage != null && savedPage >= 1 && savedPage <= 604) {
      currentPage.value = savedPage;
      minPageLoaded = savedPage;
      maxPageLoaded = savedPage;
    }
  }

  void _saveCurrentPage(int pageNumber) {
    _sharedPreferences.setInt('currentPage', pageNumber);
  }

  void _saveLastReadVerse(int surahId, int verseNumber) {
    _sharedPreferences.setInt('lastReadSurahId', surahId);
    _sharedPreferences.setInt('lastReadVerseNumber', verseNumber);
  }
}
