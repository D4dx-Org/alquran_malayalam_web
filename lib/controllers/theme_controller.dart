import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _loadTheme();

  // Define custom colors
  static const Color darkBackgroundColor = Color(0xFF333333); // RGB(51, 51, 51)
  static const Color lightBackgroundColor = Colors.white;

  bool _loadTheme() => _box.read(_key) ?? false;

  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: lightBackgroundColor,
        // Add other light theme customizations here
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBackgroundColor,
        // Add other dark theme customizations here
      );

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

  void toggleTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    saveTheme(!_loadTheme());
    update();
  }

  // Method to get the current background color
  Color get backgroundColor =>
      _loadTheme() ? darkBackgroundColor : lightBackgroundColor;
}
