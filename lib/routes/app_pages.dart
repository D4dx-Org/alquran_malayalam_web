import 'package:alquran_web/pages/Drawer%20Pages/about_us_page.dart';
import 'package:alquran_web/pages/Drawer%20Pages/contact_us_page.dart';
import 'package:alquran_web/pages/detailed_surah_page.dart';
import 'package:alquran_web/pages/index_page.dart';
import 'package:alquran_web/pages/Drawer%20Pages/privacy_page.dart';
import 'package:alquran_web/splash_screen.dart';
import 'package:alquran_web/widgets/search_widget.dart';
import 'package:alquran_web/widgets/settings_widget.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
        GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => const IndexPage(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsWidget(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.ABOUT_US,
      page: () => const AboutUsPage(),
    ),
    GetPage(
      name: Routes.CONTACT_US,
      page: () => const ContactusPage(),
    ),
    GetPage(
      name: Routes.PRIVACY,
      page: () => const PrivacyPage(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchWidget(),
    ),
    GetPage(
      name: Routes.SURAH_DETAILED,
      page: () => const DetailedSurahPage(),
    ),
  ];
}
