// ignore_for_file: non_constant_identifier_names

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/shared_preference_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/services/surah_unicode_data.dart';
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
      currentPage = 0;
      _AyaLines.value =
          await _quranService.fetchAyaLines(surahNumber, currentPage);
      getAyaStartingLineIds();
    } catch (e) {
      debugPrint('Error fetching Aya lines: $e');
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

    if (storedSurah != null &&
        storedSurahId != null &&
        storedAyaRange != null &&
        _surahNames.isNotEmpty) {
      final index = _surahNames.indexOf(storedSurah);
      if (index != -1) {
        _selectedSurah.value = _surahNames[index];
        _selectedSurahId.value = _surahIds[index];
        _selectedSurahAyaCount.value = _surahAyaCounts[index];
        _selectedAyaNumber.value = 1;
        _selectedAyaRange.value = storedAyaRange;
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

  Future<bool> ensureAyaIsLoaded(int surahId, int AyaNumber) async {
    bool newDataLoaded = false;
    if (surahId != _selectedSurahId.value) {
      updateSelectedSurahId(surahId, AyaNumber);
      await _fetchAyaLines(surahId);
      newDataLoaded = true;
    }

    while (
        _AyaLines.isEmpty || int.parse(_AyaLines.last['AyaNo']) < AyaNumber) {
      await fetchMoreAyaLines();
      newDataLoaded = true;
    }

    return newDataLoaded;
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
    int currentAyaNumber = 0;

    for (var line in _AyaLines) {
      int AyaNumber = int.parse(line['AyaNo']);
      int lineId = int.parse(line['LineId']);

      if (AyaNumber != currentAyaNumber) {
        AyaStartingLineIds[AyaNumber] = lineId;
        currentAyaNumber = AyaNumber;
      }
    }

    return AyaStartingLineIds;
  }

  Future<void> scrollToAya(int AyaNumber, String lineId) async {
    try {
      // Ensure the Aya is loaded
      await ensureAyaIsLoaded(_selectedSurahId.value, AyaNumber);
      // Add a small delay to allow for widget initialization
      await Future.delayed(const Duration(milliseconds: 50));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (itemScrollController.isAttached) {
          // Find the index of the Aya
          int index = _AyaLines.indexWhere((Aya) =>
              int.parse(Aya['AyaNo']) == AyaNumber && Aya['LineId'] == lineId);
          if (index == -1) {
            // If exact match not found, find the nearest Aya
            index = _AyaLines.indexWhere(
                (Aya) => int.parse(Aya['AyaNo']) >= AyaNumber);
          }
          if (index == -1) {
            // If still not found, scroll to the end
            index = _AyaLines.length;
          }
          // Attempt to scroll
          itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOutCubic,
            alignment: 0,
          );
          // Update the selected Aya number and range
          _selectedAyaNumber.value = AyaNumber;
          _selectedAyaRange.value = '${_selectedSurahId.value} : $AyaNumber';

          // Notify the UI to update the dropdown
          update(); // This will trigger the UI to rebuild and reflect the new Aya number in the dropdown
        }
      });
    } catch (e) {
      // Handle error
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
