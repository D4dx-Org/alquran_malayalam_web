// ignore_for_file: non_constant_identifier_names

import 'dart:developer' as developer;

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/shared_preference_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/utils/surah_unicode_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio_controller.dart';

class QuranController extends GetxController {
  final QuranService _quranService = QuranService();
  final SharedPreferences sharedPreferences;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ReadingController readingController = Get.put(ReadingController());

  QuranController({required this.sharedPreferences});

  late final SharedPreferencesController _prefsController;
  final _surahNames = <String>[].obs;
  final _arabicSurahNames = <String>[].obs;
  final _surahIds = <int>[].obs;
  final _selectedSurah = ''.obs;
  final _selectedSurahId = 0.obs;
  final _selectedSurahAyaCount = 0.obs;
  final _selectedAyaNumber = 1.obs;
  final _selectedAyaRange = ''.obs;
  final _AyaLines = <Map<String, dynamic>>[].obs;
  final _surahAyaCounts = <int>[].obs;
  final _surahMalMeans = <String>[].obs;
  final isLoadingEntireSurah = false.obs;

  int currentPage = 0;
  static QuranController get instance => Get.find<QuranController>();

  List<String> get surahNames => _surahNames;
  List<String> get arabicSurahNames => _arabicSurahNames;
  List<int> get surahIds => _surahIds;
  String get selectedSurah => _selectedSurah.value;
  int get selectedSurahId => _selectedSurahId.value;
  int get selectedSurahAyaCount => _selectedSurahAyaCount.value;
  int get selectedAyaNumber => _selectedAyaNumber.value;
  String get selectedAyaRange => _selectedAyaRange.value;
  List<Map<String, dynamic>> get AyaLines => _AyaLines;
  List<String> get surahMalMeans => _surahMalMeans;

  @override
  void onInit() async {
    super.onInit();
    _prefsController = Get.find<SharedPreferencesController>();

    await fetchSurahs();
    _loadSelectedSurah();
  }

  void navigateToPreviousSurah() {
    final currentIndex = _surahIds.indexOf(_selectedSurahId.value);
    if (currentIndex > 0) {
      final newSurahId = _surahIds[currentIndex - 1];
      updateSelectedSurahId(newSurahId, 1);
      _fetchAyaLines(newSurahId);
      Get.find<AudioController>().changeSurah(newSurahId);
      readingController.navigateToSpecificSurah(newSurahId);
    }
  }

  void navigateToNextSurah() {
    final currentIndex = _surahIds.indexOf(_selectedSurahId.value);
    if (currentIndex < _surahIds.length - 1) {
      final newSurahId = _surahIds[currentIndex + 1];
      updateSelectedSurahId(newSurahId, 1);
      _fetchAyaLines(newSurahId);
      readingController.navigateToSpecificSurah(newSurahId);
      Get.find<AudioController>().changeSurah(newSurahId);
    }
  }

  void updateSelectedSurah(String surahName, int AyaNumber) {
    final index = _surahNames.indexOf(surahName);
    if (index != -1) {
      _selectedSurah.value = surahName;
      _selectedSurahId.value = _surahIds[index];
      _selectedSurahAyaCount.value = _surahAyaCounts[index];
      _selectedAyaNumber.value = AyaNumber;
      _selectedAyaRange.value = '${_surahIds[index]} : $AyaNumber';
      _prefsController.setString('selectedSurah', surahName);
      _prefsController.setString(
          'selectedArabicSurah', _arabicSurahNames[index]);
      _prefsController.setInt('selectedSurahId', _surahIds[index]);
      _prefsController.setInt('selectedAyaNumber', AyaNumber);
      _prefsController.setString(
          'selectedAyaRange', '${_surahIds[index]} : $AyaNumber');
      _prefsController.setString('selectedSurahMalMean', _surahMalMeans[index]);
      _fetchAyaLines(_surahIds[index]);
      scrollToAya(AyaNumber, '1'); // Scroll to the specified Aya
    }
  }

  void updateSelectedSurahId(int surahId, int AyaNumber) {
    final index = _surahIds.indexOf(surahId);
    if (index != -1) {
      _selectedSurah.value = _surahNames[index];
      _selectedSurahId.value = surahId;
      _selectedSurahAyaCount.value = _surahAyaCounts[index];
      _selectedAyaNumber.value = AyaNumber;
      _selectedAyaRange.value = '$surahId : $AyaNumber';
      _prefsController.setString('selectedSurah', _surahNames[index]);
      _prefsController.setString(
          'selectedArabicSurah', _arabicSurahNames[index]);
      _prefsController.setInt('selectedSurahId', surahId);
      _prefsController.setInt('selectedAyaNumber', AyaNumber);
      _prefsController.setString('selectedAyaRange', '$surahId : $AyaNumber');
      _prefsController.setString('selectedSurahMalMean', _surahMalMeans[index]);
      _fetchAyaLines(surahId);
      scrollToAya(AyaNumber, '1'); // Scroll to the specified Aya
    }
  }

  void updateSelectedAyaRange(String AyaRange) {
    final parts = AyaRange.split(' : ');
    final surahNumber = int.parse(parts[0]);
    final AyaNumber = int.parse(parts[1]);

    if (surahNumber == _selectedSurahId.value &&
        AyaNumber <= _selectedSurahAyaCount.value) {
      _selectedAyaRange.value = AyaRange;
      _selectedAyaNumber.value = AyaNumber;
      _prefsController.setString('selectedAyaRange', AyaRange);
    } else {
      final lastAyaNumber = _selectedSurahAyaCount.value;
      _selectedAyaRange.value = '${_selectedSurahId.value} : $lastAyaNumber';
      _selectedAyaNumber.value = lastAyaNumber;
      _prefsController.setString(
          'selectedAyaRange', '${_selectedSurahId.value} : $lastAyaNumber');
    }
  }

  String getSurahName(int surahId) {
    final index = _surahIds.indexOf(surahId);
    if (index != -1) {
      return _surahNames[index];
    }
    return 'Unknown Surah';
  }

  String getArabicSurahName(int surahId) {
    final index = _surahIds.indexOf(surahId);
    if (index != -1) {
      return _arabicSurahNames[index];
    }
    return 'Unknown Surah';
  }

  String getSurahMalMean(int surahId) {
    final index = _surahIds.indexOf(surahId);
    if (index != -1) {
      return _surahMalMeans[index];
    }
    return 'Unknown Meaning';
  }

  void printSelectedSurahMalMean() {
    final index = _surahIds.indexOf(_selectedSurahId.value);
    if (index != -1) {
    } else {}
  }

  void printAllSurahMalMeans() {
    for (int i = 0; i < _surahNames.length; i++) {}
  }

  Future<void> fetchSurahs() async {
    try {
      final surahs = await _quranService.fetchSurahs();
      _surahNames.value =
          surahs.map((surah) => surah['MSuraName'] as String).toList();
      _arabicSurahNames.value =
          surahs.map((surah) => surah['ASuraName'] as String).toList();
      _surahIds.value =
          surahs.map((surah) => int.parse(surah['SuraId'].toString())).toList();
      _surahAyaCounts.value = surahs
          .map((surah) => int.parse(surah['TotalAyas'].toString()))
          .toList();
      _surahMalMeans.value =
          surahs.map((surah) => surah['MalMean'] as String).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _fetchAyaLines(int surahNumber) async {
    try {
      // Load just the first verse initially
      final verses = await _quranService.fetchVerses(surahNumber, 1);
      if (verses.isNotEmpty) {
        _AyaLines.value = verses;
        getAyaStartingLineIds();
      }
    } catch (e) {
      debugPrint('Error fetching Aya lines: $e');
    }
  }

  Future<void> loadEntireSurah(int surahNumber) async {
    try {
      isLoadingEntireSurah.value = true;

      // Load verses in smaller batches
      const batchSize = 5; // Load 5 pages at a time
      final totalAyas = _selectedSurahAyaCount.value;
      final estimatedPages =
          (totalAyas / 10).ceil(); // Assuming 10 lines per page

      for (int i = 0; i < estimatedPages; i += batchSize) {
        final endIndex =
            (i + batchSize < estimatedPages) ? i + batchSize : estimatedPages;
        final batchFutures = List.generate(
          endIndex - i,
          (index) => _quranService.fetchAyaLines(surahNumber, i + index + 1),
        );

        try {
          final batchResults = await Future.wait(batchFutures);
          for (final lines in batchResults) {
            if (lines.isNotEmpty) {
              _AyaLines.addAll(lines);
            }
          }
        } catch (e) {
          debugPrint('Error loading batch starting at page ${i + 1}: $e');
          // Continue with next batch even if this one fails
        }

        // Add a small delay between batches
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Sort AyaLines by AyaNo and LineId
      _AyaLines.sort((a, b) {
        int ayaComp = int.parse(a['AyaNo'].toString())
            .compareTo(int.parse(b['AyaNo'].toString()));
        if (ayaComp != 0) return ayaComp;
        return int.parse(a['LineId'].toString())
            .compareTo(int.parse(b['LineId'].toString()));
      });

      // Remove duplicates if any
      final seen = <String>{};
      _AyaLines.removeWhere((line) {
        final key = '${line['AyaNo']}-${line['LineId']}';
        return !seen.add(key);
      });

      debugPrint(
          'Loaded ${_AyaLines.length} total lines for surah $surahNumber');
      isLoadingEntireSurah.value = false;
    } catch (e) {
      debugPrint('Error loading entire surah: $e');
      isLoadingEntireSurah.value = false;
    }
  }

  Future<void> fetchMoreAyaLines() async {
    try {
      currentPage++;
      final moreAyaLines = await _quranService.fetchAyaLines(
          _selectedSurahId.value, currentPage);
      _AyaLines.addAll(moreAyaLines);
    } catch (e) {
      // debugPrint('Error fetching more Aya lines: $e');
    }
  }

  void _loadSelectedSurah() {
    final storedSurah = _prefsController.getString('selectedSurah');
    final storedSurahId = _prefsController.getInt('selectedSurahId');
    final storedAyaRange = _prefsController.getString('selectedAyaRange');
    final storedAyaNumber = _prefsController.getInt('selectedAyaNumber') ?? 1;

    if (storedSurah != null &&
        storedSurahId != null &&
        storedAyaRange != null &&
        _surahNames.isNotEmpty) {
      final index = _surahNames.indexOf(storedSurah);
      if (index != -1) {
        _selectedSurah.value = _surahNames[index];
        _selectedSurahId.value = _surahIds[index];
        _selectedSurahAyaCount.value = _surahAyaCounts[index];
        _selectedAyaNumber.value = storedAyaNumber;
        _selectedAyaRange.value = storedAyaRange;

        // Sync with reading controller
        readingController.updateVisibleSurah(_surahIds[index]);

        // Fetch the Aya lines
        _fetchAyaLines(_surahIds[index]);
      } else {
        _useFirstSurah();
      }
    } else if (_surahNames.isNotEmpty) {
      _useFirstSurah();
    }
  }

  void _useFirstSurah() {
    _selectedSurah.value = _surahNames.first;
    _selectedSurahId.value = _surahIds.first;
    _selectedSurahAyaCount.value = _surahAyaCounts.first;
    _selectedAyaNumber.value = 1;
    _selectedAyaRange.value = '${_surahIds.first} : 1';
    _fetchAyaLines(_surahIds.first);
  }

  Future<bool> ensureAyaIsLoaded(int surahId, int ayaNumber) async {
    developer.log(
        'Starting ensureAyaIsLoaded for Surah: $surahId, Aya: $ayaNumber',
        name: 'AyaLoader');

    try {
      // First validate the input parameters
      if (surahId < 1 || surahId > 114) {
        developer.log('Invalid surah ID: $surahId', name: 'AyaLoader');
        throw ArgumentError('Invalid surah ID: $surahId');
      }

      if (ayaNumber < 1) {
        developer.log('Invalid aya number: $ayaNumber', name: 'AyaLoader');
        throw ArgumentError('Invalid aya number: $ayaNumber');
      }

      // Check if verse is already loaded
      bool isAlreadyLoaded = _AyaLines.any((aya) {
        final ayaNo = int.tryParse(aya['AyaNo']?.toString() ?? '') ?? -1;
        return ayaNo == ayaNumber;
      });

      developer.log('Aya already loaded: $isAlreadyLoaded', name: 'AyaLoader');

      if (isAlreadyLoaded) {
        developer.log('Aya was already loaded, returning', name: 'AyaLoader');
        return true;
      }

      // Load the specific verse
      developer.log('Fetching verse for Surah: $surahId, Aya: $ayaNumber',
          name: 'AyaLoader');
      final verses = await _quranService.fetchVerses(surahId, ayaNumber);

      if (verses.isEmpty) {
        developer.log('No verses returned from fetchVerses', name: 'AyaLoader');
        return false;
      }

      developer.log('Successfully fetched ${verses.length} verses',
          name: 'AyaLoader');

      // Add new verses to _AyaLines
      for (var verse in verses) {
        if (!_AyaLines.any((line) =>
            line['AyaNo'].toString() == verse['AyaNo'].toString() &&
            line['LineId'].toString() == verse['LineId'].toString())) {
          _AyaLines.add(verse);
        }
      }

      // Sort verses by AyaNo and LineId
      _AyaLines.sort((a, b) {
        int ayaComp = int.parse(a['AyaNo'].toString())
            .compareTo(int.parse(b['AyaNo'].toString()));
        if (ayaComp != 0) return ayaComp;
        return int.parse(a['LineId'].toString())
            .compareTo(int.parse(b['LineId'].toString()));
      });

      developer.log('Successfully loaded and sorted verses', name: 'AyaLoader');
      return true;
    } catch (e, stackTrace) {
      developer.log('Error in ensureAyaIsLoaded: $e\n$stackTrace',
          name: 'AyaLoader');
      return false;
    }
  }

  String getSurahNameUnicode(int surahId) {
    if (surahId < 1 || surahId > 114) {
      return '';
    }
    String unicodeChar = SurahUnicodeData.getSurahNameUnicode(surahId);
    return unicodeChar + String.fromCharCode(0xE000);
  }

  Map<int, int> getAyaStartingLineIds() {
    Map<int, int> AyaStartingLineIds = {};

    if (_AyaLines.isEmpty) {
      debugPrint(
          'Warning: AyaLines is empty when trying to get starting line IDs');
      return AyaStartingLineIds;
    }

    try {
      // Sort AyaLines by AyaNo and LineId to ensure correct order
      final sortedLines = List<Map<String, dynamic>>.from(_AyaLines);
      sortedLines.sort((a, b) {
        int aAya = int.parse(a['AyaNo'].toString());
        int bAya = int.parse(b['AyaNo'].toString());
        if (aAya != bAya) return aAya.compareTo(bAya);
        return int.parse(a['LineId'].toString())
            .compareTo(int.parse(b['LineId'].toString()));
      });

      // Process each line to find starting line IDs
      for (var line in sortedLines) {
        if (line['AyaNo'] == null || line['LineId'] == null) {
          debugPrint('Warning: Invalid line data: $line');
          continue;
        }

        int AyaNumber = int.parse(line['AyaNo'].toString());
        int lineId = int.parse(line['LineId'].toString());

        // Store the first line ID for each Aya
        if (!AyaStartingLineIds.containsKey(AyaNumber)) {
          AyaStartingLineIds[AyaNumber] = lineId;
        }
      }

      // Debug information
      if (AyaStartingLineIds.isEmpty) {
        debugPrint('Warning: No starting line IDs found.');
        debugPrint('First few lines of data: ${sortedLines.take(5)}');
      } else {
        debugPrint(
            'Found starting line IDs for Ayas: ${AyaStartingLineIds.keys.toList()}');
        debugPrint(
            'Total number of Ayas with line IDs: ${AyaStartingLineIds.length}');
      }

      return AyaStartingLineIds;
    } catch (e) {
      debugPrint('Error in getAyaStartingLineIds: $e');
      debugPrint('Current AyaLines data: ${_AyaLines.take(5)}');
      return AyaStartingLineIds;
    }
  }

  Future<void> scrollToAya(int AyaNumber, String lineId) async {
    developer.log('Starting scrollToAya with Aya: $AyaNumber',
        name: 'ScrollToAya');

    // Add multiple retry attempts for scroll
    int maxRetries = 3;
    int currentRetry = 0;

    while (currentRetry < maxRetries) {
      try {
        await ensureAyaIsLoaded(_selectedSurahId.value, AyaNumber);

        // Wait for widget to be built
        await Future.delayed(Duration(milliseconds: 100 * (currentRetry + 1)));

        if (!itemScrollController.isAttached) {
          developer.log(
              'ScrollController not attached, attempt ${currentRetry + 1}',
              name: 'ScrollToAya');
          currentRetry++;
          continue;
        }

        int index = _AyaLines.indexWhere(
            (Aya) => int.parse(Aya['AyaNo'].toString()) == AyaNumber);

        if (index != -1) {
          developer.log('Found Aya at index: $index, scrolling',
              name: 'ScrollToAya');

          itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: 0.1, // Scroll to slightly below the top
          );

          _selectedAyaNumber.value = AyaNumber;
          _selectedAyaRange.value = '${_selectedSurahId.value} : $AyaNumber';
          update();

          developer.log('Scroll complete', name: 'ScrollToAya');
          break;
        } else {
          developer.log('Aya not found in loaded lines', name: 'ScrollToAya');
          currentRetry++;
        }
      } catch (e) {
        developer.log('Error in scroll attempt ${currentRetry + 1}: $e',
            name: 'ScrollToAya');
        currentRetry++;
      }
    }

    if (currentRetry >= maxRetries) {
      developer.log('Failed to scroll after $maxRetries attempts',
          name: 'ScrollToAya');
    }
  }

  Future<void> navigateToAya(int AyaNumber) async {
    await ensureAyaIsLoaded(_selectedSurahId.value, AyaNumber);

    // Find the lineId for the selected Aya
    String lineId = '';
    int AyaIndex = -1;
    for (int i = 0; i < _AyaLines.length; i++) {
      if (int.parse(_AyaLines[i]['AyaNo']) == AyaNumber) {
        lineId = _AyaLines[i]['LineId'];
        AyaIndex = i;
        break;
      }
    }

    // Update the selected Aya number and range
    _selectedAyaNumber.value = AyaNumber;
    _selectedAyaRange.value = '${_selectedSurahId.value} : $AyaNumber';

    // Scroll to the selected Aya
    if (AyaIndex != -1) {
      itemScrollController.scrollTo(
        index: AyaIndex,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeInOut,
      );
    }

    // Navigate to the SurahDetailed page if not already there
    if (Get.currentRoute != Routes.SURAH_DETAILED) {
      Get.toNamed(
        Routes.SURAH_DETAILED,
        arguments: {
          'surahId': _selectedSurahId.value,
          'surahName': _selectedSurah.value,
          'AyaNumber': AyaNumber,
          'lineId': lineId,
        },
      );
    }
  }

  void updateSelectedAyaNumber(int AyaNumber) {
    if (AyaNumber <= _selectedSurahAyaCount.value) {
      _selectedAyaNumber.value = AyaNumber;
      _selectedAyaRange.value = '${_selectedSurahId.value} : $AyaNumber';
      _prefsController.setInt('selectedAyaNumber', AyaNumber);
      _prefsController.setString(
          'selectedAyaRange', '${_selectedSurahId.value} : $AyaNumber');
      // Get.find<AudioController>()
      //     .playSpecificAya(_selectedSurahId.value, AyaNumber);
    }
  }

  void resetToFirstAya() {
    updateSelectedAyaNumber(1);
    scrollToAya(1, '1');
  }
}
