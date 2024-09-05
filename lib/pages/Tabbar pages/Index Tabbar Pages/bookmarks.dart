import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();
    final quranController = Get.find<QuranController>();

    return Scaffold(
      body: Obx(() {
        final bookmarkedAyahs = bookmarkController.getBookmarkedAyahsList();

        return GridView.builder(
          itemCount: bookmarkedAyahs.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarkedAyahs[index];
            final surahId = bookmark['surahId']!;
            final ayahNumber = bookmark['ayahNumber']!;
            final surahName = quranController.getSurahName(surahId);

            return _buildBookmarksCard(surahName, surahId, ayahNumber);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: _getChildAspectRatio(context),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 5.0,
          ),
        );
      }),
    );
  }

  Widget _buildBookmarksCard(String surahName, int surahId, int ayahNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFF6F6F6),
            child: SvgPicture.asset(
              'assets/icons/Bookmarks_Icon.svg',
              colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(115, 78, 9, 1), BlendMode.srcIn),
            ),
          ),
          title: Text(
            surahName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Row(
            children: [
              Text(
                'Page ',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(width: 8),
              Text(
                'Juz no',
                style: TextStyle(
                  fontSize: 8,
                ),
              ),
            ],
          ),
          trailing: Text(
            '$surahId : $ayahNumber',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () {
            final quranController = Get.find<QuranController>();
            quranController.updateSelectedSurah(surahName);
            quranController.updateSelectedSurahId(surahId);
            Get.toNamed(
              Routes.SURAH_DETAILED,
              arguments: {
                'surahId': surahId,
                'surahName': surahName,
                'ayahNumber': ayahNumber,
              },
            );
          },
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 480) return 1;
    if (screenWidth < 800) return 2;
    return 3;
  }

  double _getChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double ratio = screenWidth / screenHeight;

    if (screenWidth < 480) return ratio * 6;
    if (screenWidth < 800) return ratio * 3;
    if (screenWidth < 1025) return ratio * 2;
    return ratio * 3;
  }
}
