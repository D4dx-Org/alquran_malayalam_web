import 'package:alquran_web/controllers/theme_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light().copyWith(
      //   textTheme: GoogleFonts.notoSansMalayalamTextTheme(),
      // ),
      // darkTheme: ThemeData.dark().copyWith(
      //   textTheme: GoogleFonts.notoSansMalayalamTextTheme(),
      // ),
      // themeMode: themeController.theme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
