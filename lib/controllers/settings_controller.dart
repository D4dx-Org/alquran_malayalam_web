import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final SharedPreferences _sharedPreferences;

  SettingsController({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    _loadFontSizes();
    _loadFontFamily();
  }

  RxDouble quranFontSize = 25.0.obs;
  RxDouble translationFontSize = 20.0.obs;
  Rx<TextStyle> quranFontStyle = const TextStyle().obs;

  void _loadFontSizes() {
    quranFontSize.value =
        _sharedPreferences.getDouble('quran_font_size') ?? 25.0;
    translationFontSize.value =
        _sharedPreferences.getDouble('translation_font_size') ?? 20.0;
  }

  void _loadFontFamily() {
    String fontFamily =
        _sharedPreferences.getString('quran_font_family') ?? 'Uthmani';
    setQuranFontFamily(fontFamily);
  }

  void setQuranFontFamily(String fontFamily) {
    _sharedPreferences.setString('quran_font_family', fontFamily);

    if (fontFamily == 'Amiri') {
      quranFontStyle.value = GoogleFonts.amiri(fontSize: quranFontSize.value);
    } else {
      quranFontStyle.value = TextStyle(
        fontFamily: 'Uthmanic_Script',
        fontSize: quranFontSize.value,
      );
    }
  }

  void increaseQuranFontSize() {
    quranFontSize.value += 1;
    _updateQuranFontSize();
  }

  void decreaseQuranFontSize() {
    if (quranFontSize.value > 10) {
      quranFontSize.value -= 1;
      _updateQuranFontSize();
    }
  }

  void _updateQuranFontSize() {
    _sharedPreferences.setDouble('quran_font_size', quranFontSize.value);
    setQuranFontFamily(
        _sharedPreferences.getString('quran_font_family') ?? 'Uthmani');
  }

  void increaseTranslationFontSize() {
    translationFontSize.value += 1;
    _sharedPreferences.setDouble(
        'translation_font_size', translationFontSize.value);
  }

  void decreaseTranslationFontSize() {
    if (translationFontSize.value > 10) {
      translationFontSize.value -= 1;
      _sharedPreferences.setDouble(
          'translation_font_size', translationFontSize.value);
    }
  }
}
