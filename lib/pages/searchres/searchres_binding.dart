import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/searchres/searchres_controller.dart';

class SearchResBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResController>(() => SearchResController());
  }
}
