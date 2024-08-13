import 'package:alquran_malayalam/pages/bookmarks/bookmarks_controller.dart';
import 'package:get/instance_manager.dart';

class BookmarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarksController>(() => BookmarksController());
  }
}
