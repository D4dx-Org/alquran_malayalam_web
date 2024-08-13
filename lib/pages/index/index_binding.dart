import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
