import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
