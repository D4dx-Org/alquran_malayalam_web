// ignore_for_file: non_constant_identifier_names

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/utils/surah_unicode_data.dart';
import 'package:alquran_web/pages/home_pages/widgets/footer.dart';
import 'package:alquran_web/pages/home_pages/widgets/star_widget.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  SurahListPageState createState() => SurahListPageState();
}

class SurahListPageState extends State<SurahListPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> surahs = [];
  final _quranService = QuranService();
  final _quranController = Get.find<QuranController>();
  final readingController = Get.find<ReadingController>();

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    setState(() {
      _currentIndex = 0;
    });

    try {
      final fetchedSurahs = await _quranService.fetchSurahs();
      setState(() {
        surahs = fetchedSurahs;
        _currentIndex = 1;
      });
    } catch (e) {
      setState(() {
        _currentIndex = 2;
      });
      debugPrint('Error fetching Surahs: $e');
    }
  }

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 + (screenWidth - 1440) / 10000;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    int crossAxisCount = 3;

    if (screenWidth < 650) {
      crossAxisCount = 1;
    } else if (screenWidth < 1000) {
      crossAxisCount = 2;
    } else if (screenWidth < 1500) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 3;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: CircularProgressIndicator()),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: DynamicHeightGridView(
                    itemCount: surahs.length,
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 5.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    builder: (context, index) {
                      final surah = surahs[index];
                      return _buildSurahCard(surah);
                    },
                  ),
                ),
                const SizedBox(height: 20), // Add spacing before the footer
                const FooterWidget(), // Display the footer at the bottom
              ],
            ),
          ),
          const Center(
            child: Text('Error fetching Surahs'),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: StarNumber(
            number: int.parse(surah['SuraId'].toString()),
          ),
          title: Text(
            surah['MSuraName'],
            style: GoogleFonts.notoSansMalayalam(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Row(
            children: [
              SvgPicture.asset(
                surah['SuraType'] == 'مَكِّيَة'
                    ? "icons/Makiyyah_Icon.svg"
                    : "icons/Madaniyya_Icon.svg",
                height: 11,
                width: 9,
              ),
              const SizedBox(width: 8),
              Text(
                '${surah['TotalAyas']} Ayat',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                ),
              ),
            ],
          ),
          trailing: Text(
            SurahUnicodeData.getSurahNameUnicode(
                int.parse(surah['SuraId'].toString())),
            style: const TextStyle(
              fontFamily: "SuraNames",
              fontSize: 24,
            ),
          ),
          onTap: () {
            int AyaNumber = 1;
            _quranController.updateSelectedSurah(surah['MSuraName'], AyaNumber);
            _quranController.updateSelectedSurahId(
                int.parse(surah['SuraId'].toString()), AyaNumber);

            _quranController.updateSelectedAyaNumber(AyaNumber);
            final surahId = int.parse(surah['SuraId'].toString());
            final surahName = surah['MSuraName'];
            readingController.navigateToSpecificSurah(surahId);

            Get.toNamed(
              Routes.SURAH_DETAILED,
              arguments: {
                'surahId': surahId,
                'surahName': surahName,
                'AyaNumber': AyaNumber,
                'initialTab': 0,
              },
            );
          },
        ),
      ),
    );
  }
}
