import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/services/bookmark_services.dart';
import 'package:alquran_malayalam/widgets/delete_dialog.dart';

class BookmarksController extends GetxController {
  BookmarksServices bookmarksServices = BookmarksServices();
  RxList<Bookmark> bookmarks = <Bookmark>[].obs;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  loadDB() async {
    //   await surahServices.openDB();
    loadBookmarks(1);
  }

  loadBookmarks(int bkTypeNo) async {
    try {
      isLoading = true;
      update();
      bookmarks.value = [];
      List list = await bookmarksServices.getAllBookmarks();
      for (var element in list) {
        bookmarks.add(Bookmark.fromMap(element));
      }

      isLoading = false;
      update();
    } catch (e) {
      // print(e);
    }
  }

  removeBookmark(int bid) {
    bookmarks.removeWhere((bookmark) => bookmark.bId == bid);
    bookmarksServices.deleteBookmark(bid);
    update();
  }

  removeAllBookmarks() {
    if (bookmarks.isEmpty) return;
    DeleteDialog deleteDialog = DeleteDialog(
        deleteMessage: "Are you sure want to delete all Bookmarks?",
        onDeletePressed: () async {
          Get.back();
          bookmarks.removeRange(0, bookmarks.length);
          bookmarksServices.deleteAllBookmarks();
          Get.snackbar('Bookmarks Deleted!', 'No more Bookmarks !!',
              snackPosition: SnackPosition.BOTTOM);

          update();
        });
    deleteDialog.showDeleteDialog();
  }

  showSuraTranLines(Bookmark cbkMark) async {
    int suraId = cbkMark.suraId;
    int ayaNo = cbkMark.ayaNo;

    await Get.offNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }
}
