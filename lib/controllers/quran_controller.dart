import 'package:alquran_web/services/quran_services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranController extends GetxController {
  final QuranService _quranService = QuranService();
  final _surahNames = <String>[].obs;
  final _selectedSurah = ''.obs;
  final _selectedSurahId = 0.obs;
  late final SharedPreferences _sharedPreferences;

  static QuranController get instance => Get.find<QuranController>();

  QuranController({
    required SharedPreferences sharedPreferences,
  }) {
    _sharedPreferences = sharedPreferences;
  }

  List<String> get surahNames => _surahNames;
  String get selectedSurah => _selectedSurah.value;
  int get selectedSurahId => _selectedSurahId.value;

  set selectedSurah(String value) {
    _selectedSurah.value = value;
    _sharedPreferences.setString('selectedSurah', value);
  }

  set selectedSurahId(int value) {
    _selectedSurahId.value = value;
    _sharedPreferences.setInt('selectedSurahId', value);
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
    } catch (e) {
      // Handle error
    }
  }

  void updateSelectedSurah(String surahName, int surahId) {
    _selectedSurah.value = surahName;
    _selectedSurahId.value = surahId;
    _sharedPreferences.setString('selectedSurah', surahName);
    _sharedPreferences.setInt('selectedSurahId', surahId);
  }

  void _loadSelectedSurah() {
    final storedSurah = _sharedPreferences.getString('selectedSurah');
    final storedSurahId = _sharedPreferences.getInt('selectedSurahId');
    if (storedSurah != null &&
        storedSurahId != null &&
        _surahNames.isNotEmpty) {
      final index = _surahNames.indexOf(storedSurah);
      if (index != -1) {
        _selectedSurah.value = _surahNames[index];
        _selectedSurahId.value = storedSurahId;
      } else {
        _selectedSurah.value = _surahNames.first;
        _selectedSurahId.value = int.parse(_surahNames.first);
      }
    } else if (_surahNames.isNotEmpty) {
      _selectedSurah.value = _surahNames.first;
      _selectedSurahId.value = int.parse(_surahNames.first);
    }
  }
}
