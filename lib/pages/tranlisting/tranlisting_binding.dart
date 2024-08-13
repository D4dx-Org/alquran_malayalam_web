import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/tranlisting/tranlisting_controller.dart';

class TranListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TranListingController>(() => TranListingController());
  }
}
