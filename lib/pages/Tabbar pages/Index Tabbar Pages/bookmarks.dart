import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();
    final quranController = Get.find<QuranController>();

    return Scaffold(
      body: Obx(() {
        final bookmarkedAyas = bookmarkController.getBookmarkedAyasList();

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return _buildMultipleListViews(
                  bookmarkedAyas, 3, quranController);
            } else if (constraints.maxWidth > 650) {
              return _buildMultipleListViews(
                  bookmarkedAyas, 2, quranController);
            } else {
              return _buildMultipleListViews(
                  bookmarkedAyas, 1, quranController);
            }
          },
        );
      }),
    );
  }

  Widget _buildMultipleListViews(List<Map<String, dynamic>> bookmarkedAyas,
      int columnCount, QuranController quranController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnCount, (columnIndex) {
        return Expanded(
          child: ListView.builder(
            itemCount: (bookmarkedAyas.length / columnCount).ceil(),
            itemBuilder: (context, index) {
              final itemIndex = index * columnCount + columnIndex;
              if (itemIndex < bookmarkedAyas.length) {
                final bookmark = bookmarkedAyas[itemIndex];
                final surahId = bookmark['surahId']!;
                final AyaNumber = bookmark['AyaNumber']!;
                final lineId = bookmark['lineId']!;
                final surahName = quranController.getSurahName(surahId);

                return _buildBookmarksCard(
                    surahName, surahId, AyaNumber, lineId);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildBookmarksCard(
      String surahName, int surahId, int AyaNumber, String lineId) {
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
              'icons/Bookmarks_Icon.svg',
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
            '$surahId : $AyaNumber',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () async {
            final quranController = Get.find<QuranController>();
            await quranController.ensureAyaIsLoaded(surahId, AyaNumber);

            Get.toNamed(
              Routes.SURAH_DETAILED,
              arguments: {
                'surahId': surahId,
                'surahName': surahName,
                'AyaNumber': AyaNumber,
                'lineId': lineId,
              },
            );
          },
        ),
      ),
    );
  }
}
