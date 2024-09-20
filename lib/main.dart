import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/search_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/controllers/shared_preference_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize essential controllers
  Get.put(SharedPreferencesController(sharedPreferences: sharedPreferences));
  Get.put(QuranController(sharedPreferences: sharedPreferences),
      permanent: true);
  Get.put(SettingsController(sharedPreferences: sharedPreferences),
      permanent: true);

  // Lazy load other controllers
  Get.lazyPut(() => BookmarkController(sharedPreferences: sharedPreferences),
      fenix: true);
  Get.lazyPut(() => ReadingController(), fenix: true);
  Get.lazyPut(() => AudioController(), fenix: true);
  Get.lazyPut(() => QuranSearchController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
