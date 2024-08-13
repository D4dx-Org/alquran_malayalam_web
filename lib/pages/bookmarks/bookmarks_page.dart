import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:alquran_malayalam/pages/bookmarks/bookmarks_controller.dart';

class BookmarksPage extends StatelessWidget {
  List<Bookmark> bookmarks = [];
  final BookmarksController controller = Get.put(BookmarksController());

  BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0C98B5),
          foregroundColor: Color(0xFFFFFFFF),
          title: Text("Bookmarks"),
          actions: [
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.removeAllBookmarks();
                })
          ],
          elevation: 0,
        ),
        body: GetBuilder<BookmarksController>(
            init: controller,
            builder: (_) => controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: BookmarksListing(
                        bookmarks: controller.bookmarks.value,
                      )),
                    ],
                  ))));
  }
}

class BookmarksListing extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final BookmarksController controller = Get.find();

  BookmarksListing({Key? key, required this.bookmarks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) => const Divider(height: 8),
      itemBuilder: (context, index) {
        return BookmarkItemView(
          cbkmark: bookmarks[index],
        );
      },
    );
  }
}

class BookmarkItemView extends StatelessWidget {
  final Bookmark cbkmark;
  final BookmarksController controller = Get.find();

  BookmarkItemView({Key? key, required this.cbkmark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> lines = cbkmark.suraName.split('#');
    return Container(
        // width: Get.width - 24,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        // color: Colors.white,
        child: ListTile(
          onTap: () => controller.showSuraTranLines(cbkmark),
          title: SizedBox(
            width: 180.0,
            child: Text(
              lines[0],
              style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 17.0,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.w600),
            ),
          ),
          subtitle: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                lines[1],
                style: const TextStyle(
                    fontFamily: 'NotoSansMalayalam',
                    fontSize: 15.0,
                    color: Color(0xFF303030),
                    fontWeight: FontWeight.w400),
              )),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => controller.removeBookmark(cbkmark.bId),
          ),
        ));
  }
}
