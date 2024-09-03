// SurahListPage.dart
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/widgets/star_widget.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> surahs = [];
  final _quranService = QuranService();
  final _quranController = Get.find<QuranController>();

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 3;

    if (screenWidth < 650) {
      crossAxisCount = 1;
    } else if (screenWidth < 950) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DynamicHeightGridView(
              itemCount: surahs.length,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 5.0,
              builder: (context, index) {
                final surah = surahs[index];
                return _buildSurahCard(surah);
              },
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
            ],
          ),
          trailing: Text(
            surah['ASuraName'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () {
            _quranController.updateSelectedSurah(surah['MSuraName']);
            _quranController
                .updateSelectedSurahId(int.parse(surah['SuraId'].toString()));
            final surahId = int.parse(surah['SuraId'].toString());
            final surahName = surah['MSuraName'];
            debugPrint('Navigating to SURAH_DETAILED with arguments:');
            debugPrint('surahId: $surahId');
            debugPrint('surahName: $surahName');
            Get.toNamed(
              Routes.SURAH_DETAILED,
              arguments: {
                'surahId': surahId,
                'surahName': surahName,
                'ayahNumber': 1, // Include the initial ayah number
              },
            );
          },
        ),
      ),
    );
  }
}
