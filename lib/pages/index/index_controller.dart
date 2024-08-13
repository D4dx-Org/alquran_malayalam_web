import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/services/dbservice.dart';
import 'package:alquran_malayalam/services/surah_services.dart';

class IndexController extends GetxController {
  DBService dbService = DBService();
  SurahServices surahServices = SurahServices();
  List<Surah> surahs = [];
  bool isLoading = true;
  Rxn<Surah> selectedSurah = Rxn<Surah>();
  RxInt selAyahNo = 1.obs;
  RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await dbService.openDB();
    loadSurahs();
    FlutterNativeSplash.remove();
  }

  Surah getSurah(int id) {
    return surahs.singleWhere((element) => element.suraId == id);
  }

  loadSurahs() async {
    try {
      isLoading = true;
      update();
      List list = await surahServices.getSurahs();
      for (var element in list) {
        surahs.add(Surah.fromMap(element));
      }

      isLoading = false;
      selectSurah(surahs.first);
      update();
    } catch (e) {
      //  print(e);
    }
  }

  selectSurah(Surah surah) async {
    selectedSurah.value = surah;
  }

  loadSuraDetailPage(int suraId, {int ayaNo = 1}) async {
    Get.toNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }

  getNavSurah(int shift) {
    int curSuraId = selectedSurah.value!.suraId;
    if (shift == -1 && curSuraId > 1) {
      curSuraId--;
    } else if (shift == 1 && curSuraId <= 113) {
      curSuraId++;
    }
    selectedSurah.value = getSurah(curSuraId);
  }
}
