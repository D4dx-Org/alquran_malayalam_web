import 'package:alquran_web/services/quran_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranController extends GetxController {
  final QuranService _quranService = QuranService();
  final _surahNames = <String>[].obs;
  final _surahIds = <int>[].obs;
  final _selectedSurah = ''.obs;
  final _selectedSurahId = 0.obs;
  final _selectedSurahAyahCount = 0.obs;
  final _selectedAyahNumber = 1.obs;
  final _selectedAyahRange = ''.obs;
  late final SharedPreferences _sharedPreferences;

  static QuranController get instance => Get.find<QuranController>();

  QuranController({
    required SharedPreferences sharedPreferences,
  }) {
    _sharedPreferences = sharedPreferences;
  }

  List<String> get surahNames => _surahNames;
  List<int> get surahIds => _surahIds;
  String get selectedSurah => _selectedSurah.value;
  int get selectedSurahId => _selectedSurahId.value;
  int get selectedSurahAyahCount => _selectedSurahAyahCount.value;
  int get selectedAyahNumber => _selectedAyahNumber.value;
  String get selectedAyahRange => _selectedAyahRange.value;

  void updateSelectedSurah(String surahName) {
    final index = _surahNames.indexOf(surahName);
    if (index != -1) {
      _selectedSurah.value = surahName;
      _selectedSurahId.value = _surahIds[index];
      _selectedSurahAyahCount.value = _surahAyahCounts[index];
      _selectedAyahNumber.value = 1;
      _selectedAyahRange.value = '${_surahIds[index]} : 1';
      _sharedPreferences.setString('selectedSurah', surahName);
      _sharedPreferences.setInt('selectedSurahId', _surahIds[index]);
      _sharedPreferences.setInt('selectedAyahNumber', 1);
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
      _sharedPreferences.setString('selectedSurah', _surahNames[index]);
      _sharedPreferences.setInt('selectedSurahId', surahId);
      _sharedPreferences.setInt('selectedAyahNumber', 1);
    }
  }

  void updateSelectedAyahRange(String ayahRange) {
    _selectedAyahRange.value = ayahRange;
    final parts = ayahRange.split(' : ');
    _selectedAyahNumber.value = int.parse(parts[1]);
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchSurahs();
    _loadSelectedSurah();
  }

  Future<void> fetchSurahs() async {
    try {
      final surahs = await _quranService.fetchSurahs();
      _surahNames.value =
          surahs.map((surah) => surah['MSuraName'] as String).toList();
      _surahIds.value =
          surahs.map((surah) => int.parse(surah['SuraId'].toString())).toList();
      _surahAyahCounts.value = surahs
          .map((surah) => int.parse(surah['TotalAyas'].toString()))
          .toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchAyahLines(int surahNumber) async {
    try {
      final ayahLines = await _quranService.fetchAyahLines(surahNumber);
      for (var ayahLine in ayahLines) {
        print('Surah Number: ${ayahLine['SuraNo']}');
        print('Ayah Number: ${ayahLine['AyaNo']}');
      }
    } catch (e) {
      debugPrint('Error fetching ayah lines: $e');
    }
  }

  void _loadSelectedSurah() {
    final storedSurah = _sharedPreferences.getString('selectedSurah');
    final storedSurahId = _sharedPreferences.getInt('selectedSurahId');
    final storedAyahNumber = _sharedPreferences.getInt('selectedAyahNumber');
    if (storedSurah != null &&
        storedSurahId != null &&
        storedAyahNumber != null &&
        _surahNames.isNotEmpty) {
      final index = _surahNames.indexOf(storedSurah);
      if (index != -1) {
        _selectedSurah.value = _surahNames[index];
        _selectedSurahId.value = _surahIds[index];
        _selectedSurahAyahCount.value = _surahAyahCounts[index];
        _selectedAyahNumber.value = storedAyahNumber;
        _selectedAyahRange.value = '$storedSurahId : $storedAyahNumber';
      } else {
        _selectedSurah.value = _surahNames.first;
        _selectedSurahId.value = _surahIds.first;
        _selectedSurahAyahCount.value = _surahAyahCounts.first;
        _selectedAyahNumber.value = 1;
        _selectedAyahRange.value = '${_surahIds.first} : 1';
      }
    } else if (_surahNames.isNotEmpty) {
      _selectedSurah.value = _surahNames.first;
      _selectedSurahId.value = _surahIds.first;
      _selectedSurahAyahCount.value = _surahAyahCounts.first;
      _selectedAyahNumber.value = 1;
      _selectedAyahRange.value = '${_surahIds.first} : 1';
    }
  }

  final _surahAyahCounts = <int>[].obs;
}
