import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/services/tranlisting_services.dart';

class SearchResController extends GetxController {
  RxString queryStr = ''.obs;

  Rx<double> fontSizeMalayalam =
      SettingsHelpers.instance.getFontSizeMalayalam!.obs;

  TranListingServices searchServices = TranListingServices();

  List<TranLine> tranLineList = [];

  bool isLoading = true;
  bool isTransLoading = true;
  bool isIntptrLoading = true;
  bool isQuranLoading = true;

  @override
  void onInit() {
    super.onInit();
    loadDB();

    queryStr.listen((querystr) async {
      await loadTranSearchRes(queryStr.value);
    });
  }

  loadDB() async {
    var data = Get.arguments;
    queryStr.value = data[0];

    if (queryStr.value == '') return;

    loadTranSearchRes(queryStr.value);
  }

  loadTranSearchRes(String schStr) async {
    try {
      isLoading = true;
      tranLineList = [];
      update();

      List list = await searchServices.getSearchTranLines(queryString: schStr);
      for (var element in list) {
        tranLineList.add(element);
      }

      isLoading = false;
      update();
    } catch (e) {
      //   print(e);
    }
  }

  showSuraTranLines(int suraId, int ayaNo) async {
    await Get.toNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }
}
