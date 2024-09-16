import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalCardWidget extends StatelessWidget {
  final QuranController quranController;

  const HorizontalCardWidget({
    super.key,
    required this.quranController,
  });

  @override
  Widget build(BuildContext context) {
    double cardHeight = 34;
    double cardWidth = 160;

    final List<Map<String, dynamic>> surahs = [
      {
        'id': 2,
        'name': 'ആയത്തൗൽ കുർസി'
      }, // Ayat al-Kursi is from Surah Al-Baqarah (2)
      {'id': 36, 'name': 'സൂറ: യാസീൻ'},
      {'id': 67, 'name': 'സൂറ: അൽമുൽക്ക്'},
      {'id': 55, 'name': 'സൂറ: അർറഹ്മാൻ'},
      {'id': 56, 'name': 'സൂറ: അൽവാഖിഅ'},
      {'id': 18, 'name': 'സൂറ: അൽകഹ്ഫ്'},
    ];

    Map<int, String> surahLineIds = {
      2: '1000',
      36: '10668',
      67: '13914',
      55: '13142',
      56: '13226',
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: surahs.map((surah) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: cardWidth,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            int ayahNumber = surah['id'] == 2 ? 255 : 1;

                            if (surah['name'] != null && surah['id'] != null) {
                              quranController.updateSelectedSurah(
                                  surah['name'].toString(), ayahNumber);
                              quranController.updateSelectedSurahId(
                                  surah['id'], ayahNumber);
                              quranController.scrollToAyah(
                                  ayahNumber, surahLineIds[surah['id']]!);

                              Get.toNamed(
                                Routes.SURAH_DETAILED,
                                arguments: {
                                  'surahId': surah['id'],
                                  'surahName': surah['name'],
                                  'ayahNumber': ayahNumber,
                                },
                              );
                            } else {
                              debugPrint('Invalid surah data');
                            }
                          },
                          child: Container(
                            height: cardHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color.fromRGBO(226, 226, 226, 1),
                            ),
                            child: Center(
                              child: Text(
                                surah['name']?.toString() ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(130, 130, 130, 1),
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
