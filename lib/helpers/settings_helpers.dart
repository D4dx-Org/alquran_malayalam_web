import 'package:get_storage/get_storage.dart';

class SettingsHelpers {
  static SettingsHelpers _instance = SettingsHelpers.internal();
  static final _prefBox = GetStorage();

  factory SettingsHelpers() => _instance;

  static SettingsHelpers get instance {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_instance == null) {
      _instance = SettingsHelpers();
    }
    return _instance;
  }

  SettingsHelpers.internal();

  lastReadPageSuraAyaNo(int suraNo, int ayaNo) {
    _prefBox.write('lastReadNo', "$suraNo:$ayaNo");
  }

  static const String minSuraAyaNo = "1:1";
  String get getLastReadNo {
    final String? lastReadNoString = _prefBox.read('lastReadNo');
    return lastReadNoString ?? minSuraAyaNo.toString();
  }

  fontSizeArabic(double fontSize) {
    _prefBox.write('fontSizeArabic', fontSize.toString());
  }

  static const double minFontSizeArabic = 21;
  double? get getFontSizeArabic {
    final String? fontSizeString = _prefBox.read('fontSizeArabic');
    return double.tryParse(fontSizeString ?? minFontSizeArabic.toString());
  }

  fontSizeMalayalam(double fontSize) {
    _prefBox.write('fontSizeMalayalam', fontSize.toString());
  }

  static const double minFontSizeMalayalam = 17;
  double? get getFontSizeMalayalam {
    String? fontSizeString = _prefBox.read('fontSizeMalayalam');
    return double.tryParse(fontSizeString ?? minFontSizeMalayalam.toString());
  }
}
