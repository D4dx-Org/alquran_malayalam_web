import 'package:get/get.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';

class SettingsController extends GetxController {
  bool isLoading = true;
  static const double maxFontSizeArabic = 26;
  static const double maxFontSizeMalayalam = 21;
  static const double maxFontSizeEnglish = 21;
  Rx<double> fontSizeArabic = SettingsHelpers.instance.getFontSizeArabic!.obs;
  Rx<double> fontSizeMalayalam =
      SettingsHelpers.instance.getFontSizeMalayalam!.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading = false;
  }

  double curFontSize(String lang) {
    double cFontSize = 14.0;
    if (lang == 'Arabic') {
      cFontSize = fontSizeArabic.value;
    } else if (lang == 'Malayalam') {
      cFontSize = fontSizeMalayalam.value;
    }
    return cFontSize;
  }

  String getFontSize(String lang) {
    return curFontSize(lang).toString();
  }

  void setFontSize(String lang, double value) {
    if (lang == 'Arabic') {
      SettingsHelpers.instance.fontSizeArabic(value);
      fontSizeArabic.value = value;
    } else if (lang == 'Malayalam') {
      SettingsHelpers.instance.fontSizeMalayalam(value);
      fontSizeMalayalam.value = value;
    }
  }

  double getMinFontSize(String lang) {
    double minFontSize = 14.0;
    if (lang == 'Arabic') {
      minFontSize = SettingsHelpers.minFontSizeArabic;
    } else if (lang == 'Malayalam') {
      minFontSize = SettingsHelpers.minFontSizeMalayalam;
    }
    return minFontSize;
  }

  double getMaxFontSize(String lang) {
    double maxFontSize = 14.0;
    if (lang == 'Arabic') {
      maxFontSize = maxFontSizeArabic;
    } else if (lang == 'Malayalam') {
      maxFontSize = maxFontSizeMalayalam;
    } else if (lang == 'English') {
      maxFontSize = maxFontSizeEnglish;
    }
    return maxFontSize;
  }

  changeValue(String lang, int shift) {
    double cFontsize = curFontSize(lang);
    double value = cFontsize;
    if (shift == -1 && (cFontsize - 1 < getMinFontSize(lang))) {
      value = getMinFontSize(lang);
    } else if (shift == 1 && (cFontsize + 1 > getMaxFontSize(lang))) {
      value = getMaxFontSize(lang);
    } else {
      value = cFontsize + shift;
    }
    if (value != cFontsize) {
      setFontSize(lang, value);
    }
  }

  resetFontSize() {
    setFontSize('Arabic', getMinFontSize('Arabic'));
    setFontSize('Malayalam', getMinFontSize('Malayalam'));
  }
}
