
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final SharedPreferences _sharedPreferences;

  SettingsController({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    _loadFontSizes();
    _loadFontFamily();
  }

  RxDouble quranFontSize = 15.0.obs;
  RxDouble translationFontSize = 15.0.obs;
  RxString quranFontFamily = 'Utmani'.obs;

  void _loadFontSizes() {
    quranFontSize.value = _sharedPreferences.getDouble('quran_font_size') ?? 15.0;
    translationFontSize.value = _sharedPreferences.getDouble('translation_font_size') ?? 15.0;
  }

  void _loadFontFamily() {
    quranFontFamily.value = _sharedPreferences.getString('quran_font_family') ?? 'Utmani';
  }

  void setQuranFontFamily(String fontFamily) {
    quranFontFamily.value = fontFamily;
    _sharedPreferences.setString('quran_font_family', fontFamily);
  }

  void increaseQuranFontSize() {
    quranFontSize.value += 1;
    _sharedPreferences.setDouble('quran_font_size', quranFontSize.value);
  }

  void decreaseQuranFontSize() {
    if (quranFontSize.value > 10) {
      quranFontSize.value -= 1;
      _sharedPreferences.setDouble('quran_font_size', quranFontSize.value);
    }
  }

  void increaseTranslationFontSize() {
    translationFontSize.value += 1;
    _sharedPreferences.setDouble('translation_font_size', translationFontSize.value);
  }

  void decreaseTranslationFontSize() {
    if (translationFontSize.value > 10) {
      translationFontSize.value -= 1;
      _sharedPreferences.setDouble('translation_font_size', translationFontSize.value);
    }
  }
}
