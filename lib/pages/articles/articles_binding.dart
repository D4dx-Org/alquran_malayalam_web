import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/articles/articles_controller.dart';

class ArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticlesController>(() => ArticlesController());
  }
}
