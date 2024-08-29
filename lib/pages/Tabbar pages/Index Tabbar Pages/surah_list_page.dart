import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  int _currentIndex = 0; // To manage the IndexedStack
  List<Map<String, dynamic>> surahs = [];
  final _quranService = QuranService();

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    setState(() {
      _currentIndex = 0; // Show loading spinner
    });

    try {
      final fetchedSurahs = await _quranService.fetchSurahs();
      setState(() {
        surahs = fetchedSurahs;
        _currentIndex = 1; // Show the list view
      });
    } catch (e) {
      // Handle error
      setState(() {
        _currentIndex = 2; // Show error view
      });
      // Add your error handling logic here
      print('Error fetching Surahs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int crossAxisCount = 3;

    if (screenWidth < 480) {
      crossAxisCount = 1;
    } else if (screenWidth < 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    double childAspectRatio = screenWidth / screenHeight;

    if (screenWidth < 480) {
      childAspectRatio =
          childAspectRatio * 7; // Taller cards for smaller screens
    } else if (screenWidth < 800) {
      childAspectRatio =
          childAspectRatio * 4; // Medium-sized cards for medium screens
    } else if (screenWidth < 1025) {
      childAspectRatio =
          childAspectRatio * 3; // Shorter cards for larger screens
    } else {
      childAspectRatio = childAspectRatio * 3;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return _buildSurahCard(surah);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio:
                    childAspectRatio, // Maintain the original aspect ratio
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
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
                height: 11, // Adjust size as needed
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
            Get.toNamed(
              Routes.SURAH_DETAILED,
              arguments: {'surahId': surah['SuraId']},
            );
          },
        ),
      ),
    );
  }
}
