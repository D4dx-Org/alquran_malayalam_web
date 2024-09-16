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

  QuranController({required this.sharedPreferences});

  late final SharedPreferencesController _prefsController;
  final _surahNames = <String>[].obs;
  final _arabicSurahNames = <String>[].obs;
  final _surahIds = <int>[].obs;
  final _selectedSurah = ''.obs;
  final _selectedSurahId = 0.obs;
  final _selectedSurahAyahCount = 0.obs;
  final _selectedAyahNumber = 1.obs;
  final _selectedAyahRange = ''.obs;
  final _ayahLines = <Map<String, dynamic>>[].obs;
  final _surahAyahCounts = <int>[].obs;
  final _surahMalMeans = <String>[].obs;

  int currentPage = 0;
  static QuranController get instance => Get.find<QuranController>();

  List<String> get surahNames => _surahNames;
  List<String> get arabicSurahNames => _arabicSurahNames;
  List<int> get surahIds => _surahIds;
  String get selectedSurah => _selectedSurah.value;
  int get selectedSurahId => _selectedSurahId.value;
  int get selectedSurahAyahCount => _selectedSurahAyahCount.value;
  int get selectedAyahNumber => _selectedAyahNumber.value;
  String get selectedAyahRange => _selectedAyahRange.value;
  List<Map<String, dynamic>> get ayahLines => _ayahLines;
  List<String> get surahMalMeans => _surahMalMeans;

  void navigateToPreviousSurah() {
    final currentIndex = _surahIds.indexOf(_selectedSurahId.value);
    if (currentIndex > 0) {
      final newSurahId = _surahIds[currentIndex - 1];
      updateSelectedSurahId(newSurahId);
      _fetchAyahLines(newSurahId);
      Get.find<ReadingController>().fetchSurah(newSurahId);

      // Add this line to change the audio
      Get.find<AudioController>().changeSurah(newSurahId);
    }
  }

  void navigateToNextSurah() {
    final currentIndex = _surahIds.indexOf(_selectedSurahId.value);
    if (currentIndex < _surahIds.length - 1) {
      final newSurahId = _surahIds[currentIndex + 1];
      updateSelectedSurahId(newSurahId);
      _fetchAyahLines(newSurahId);
      Get.find<ReadingController>().fetchSurah(newSurahId);

      // Add this line to change the audio
      Get.find<AudioController>().changeSurah(newSurahId);
    }
  }

  void updateSelectedSurah(String surahName) {
    final index = _surahNames.indexOf(surahName);
    if (index != -1) {
      _selectedSurah.value = surahName;
      _selectedSurahId.value = _surahIds[index];
      _selectedSurahAyahCount.value = _surahAyahCounts[index];
      _selectedAyahNumber.value = 1;
      _selectedAyahRange.value = '${_surahIds[index]} : 1';
      _prefsController.setString('selectedSurah', surahName);
      _prefsController.setString(
          'selectedArabicSurah', _arabicSurahNames[index]);
      _prefsController.setInt('selectedSurahId', _surahIds[index]);
      _prefsController.setInt('selectedAyahNumber', 1);
      _prefsController.setString(
          'selectedAyahRange', '${_surahIds[index]} : 1');
      _prefsController.setString('selectedSurahMalMean', _surahMalMeans[index]);
      _fetchAyahLines(_surahIds[index]);
      Get.find<ReadingController>().fetchSurah(_surahIds[index]);
    }
  }

  void updateSelectedSurahId(int surahId) {
    final index = _surahIds.indexOf(surahId);
    if (index != -1) {
      _selectedSurah.value = _surahNames[index];
      _selectedSurahId.value = surahId;
      _selectedSurahAyahCount.value = _surahAyahCounts[index];
      _selectedAyahNumber.value = 1;
      _selectedAyahRange.value = '$surahId : 1';
      _prefsController.setString('selectedSurah', _surahNames[index]);
      _prefsController.setString(
          'selectedArabicSurah', _arabicSurahNames[index]);
      _prefsController.setInt('selectedSurahId', surahId);
      _prefsController.setInt('selectedAyahNumber', 1);
      _prefsController.setString('selectedAyahRange', '$surahId : 1');
      _prefsController.setString('selectedSurahMalMean', _surahMalMeans[index]);
      _fetchAyahLines(surahId);
    }
  }

  void updateSelectedAyahRange(String ayahRange) {
    final parts = ayahRange.split(' : ');
    final surahNumber = int.parse(parts[0]);
    final ayahNumber = int.parse(parts[1]);

    if (surahNumber == _selectedSurahId.value &&
        ayahNumber <= _selectedSurahAyahCount.value) {
      _selectedAyahRange.value = ayahRange;
      _selectedAyahNumber.value = ayahNumber;
      _prefsController.setString('selectedAyahRange', ayahRange);
    } else {
      final lastAyahNumber = _selectedSurahAyahCount.value;
      _selectedAyahRange.value = '${_selectedSurahId.value} : $lastAyahNumber';
      _selectedAyahNumber.value = lastAyahNumber;
      _prefsController.setString(
          'selectedAyahRange', '${_selectedSurahId.value} : $lastAyahNumber');
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

  @override
  void onInit() async {
    super.onInit();
    _prefsController = Get.find<SharedPreferencesController>();

    await fetchSurahs();
    _loadSelectedSurah();
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
      _surahAyahCounts.value = surahs
          .map((surah) => int.parse(surah['TotalAyas'].toString()))
          .toList();
      _surahMalMeans.value =
          surahs.map((surah) => surah['MalMean'] as String).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _fetchAyahLines(int surahNumber) async {
    try {
      currentPage = 0;
      _ayahLines.value =
          await _quranService.fetchAyahLines(surahNumber, currentPage);
      getAyahStartingLineIds();
    } catch (e) {
      debugPrint('Error fetching ayah lines: $e');
    }
  }

  Future<void> fetchMoreAyahLines() async {
    try {
      currentPage++;
      final moreAyahLines = await _quranService.fetchAyahLines(
          _selectedSurahId.value, currentPage);
      _ayahLines.addAll(moreAyahLines);
    } catch (e) {
      debugPrint('Error fetching more ayah lines: $e');
    }
  }

  void _loadSelectedSurah() {
    final storedSurah = _prefsController.getString('selectedSurah');
    final storedSurahId = _prefsController.getInt('selectedSurahId');
    final storedAyahRange = _prefsController.getString('selectedAyahRange');

    if (storedSurah != null &&
        storedSurahId != null &&
        storedAyahRange != null &&
        _surahNames.isNotEmpty) {
      final index = _surahNames.indexOf(storedSurah);
      if (index != -1) {
        _selectedSurah.value = _surahNames[index];
        _selectedSurahId.value = _surahIds[index];
        _selectedSurahAyahCount.value = _surahAyahCounts[index];
        _selectedAyahNumber.value = 1;
        _selectedAyahRange.value = storedAyahRange;
        _fetchAyahLines(_surahIds[index]);
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
    _selectedSurahAyahCount.value = _surahAyahCounts.first;
    _selectedAyahNumber.value = 1;
    _selectedAyahRange.value = '${_surahIds.first} : 1';
    _fetchAyahLines(_surahIds.first);
  }

  Future<bool> ensureAyahIsLoaded(int surahId, int ayahNumber) async {
    bool newDataLoaded = false;
    if (surahId != _selectedSurahId.value) {
      updateSelectedSurahId(surahId);
      await _fetchAyahLines(surahId);
      newDataLoaded = true;
    }

    while (_ayahLines.isEmpty ||
        int.parse(_ayahLines.last['AyaNo']) < ayahNumber) {
      await fetchMoreAyahLines();
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

  Map<int, int> getAyahStartingLineIds() {
    Map<int, int> ayahStartingLineIds = {};
    int currentAyahNumber = 0;

    for (var line in _ayahLines) {
      int ayahNumber = int.parse(line['AyaNo']);
      int lineId = int.parse(line['LineId']);

      if (ayahNumber != currentAyahNumber) {
        ayahStartingLineIds[ayahNumber] = lineId;
        currentAyahNumber = ayahNumber;
      }
    }

    return ayahStartingLineIds;
  }

  Future<void> scrollToAyah(int ayahNumber, String lineId) async {
    try {
      // Ensure the ayah is loaded
      await ensureAyahIsLoaded(_selectedSurahId.value, ayahNumber);

      // Add a small delay to allow for widget initialization
      await Future.delayed(const Duration(milliseconds: 300));

      // Find the index of the ayah
      int index = _ayahLines.indexWhere((ayah) =>
          int.parse(ayah['AyaNo']) == ayahNumber && ayah['LineId'] == lineId);

      if (index == -1) {
        // If exact match not found, find the nearest ayah
        index = _ayahLines
            .indexWhere((ayah) => int.parse(ayah['AyaNo']) >= ayahNumber);
      }

      if (index == -1) {
        // If still not found, scroll to the end
        index = _ayahLines.length - 1;
      }

      // Attempt to scroll
      if (itemScrollController.isAttached) {
        await itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (itemScrollController.isAttached) {
            itemScrollController.scrollTo(
              index: index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
          } else {}
        });
      }

      // Update the selected ayah number and range
      _selectedAyahNumber.value = ayahNumber;
      _selectedAyahRange.value = '${_selectedSurahId.value} : $ayahNumber';

      // Update the UI
      update();
    } catch (e) {
      print('Error in scrollToAyah: $e');
      // You might want to show a user-friendly error message here
    }
  }

  Future<void> navigateToAyah(int ayahNumber) async {
    await ensureAyahIsLoaded(_selectedSurahId.value, ayahNumber);

    // Find the lineId for the selected Ayah
    String lineId = '';
    int ayahIndex = -1;
    for (int i = 0; i < _ayahLines.length; i++) {
      if (int.parse(_ayahLines[i]['AyaNo']) == ayahNumber) {
        lineId = _ayahLines[i]['LineId'];
        ayahIndex = i;
        break;
      }
    }

    // Update the selected Ayah number and range
    _selectedAyahNumber.value = ayahNumber;
    _selectedAyahRange.value = '${_selectedSurahId.value} : $ayahNumber';

    // Scroll to the selected Ayah
    if (ayahIndex != -1) {
      itemScrollController.scrollTo(
        index: ayahIndex,
        duration: const Duration(milliseconds: 500),
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
          'ayahNumber': ayahNumber,
          'lineId': lineId,
        },
      );
    }
  }

  void updateSelectedAyahNumber(int ayahNumber) {
    if (ayahNumber <= _selectedSurahAyahCount.value) {
      _selectedAyahNumber.value = ayahNumber;
      _selectedAyahRange.value = '${_selectedSurahId.value} : $ayahNumber';
      _prefsController.setInt('selectedAyahNumber', ayahNumber);
      _prefsController.setString(
          'selectedAyahRange', '${_selectedSurahId.value} : $ayahNumber');
      // Get.find<AudioController>()
      //     .playSpecificAyah(_selectedSurahId.value, ayahNumber);
    }
  }

  void resetToFirstAyah() {
    updateSelectedAyahNumber(1);
    scrollToAyah(1, '1');
  }
}
