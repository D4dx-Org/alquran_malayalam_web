// ignore_for_file: non_constant_identifier_names

import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/utils/json_utils.dart';
import 'package:alquran_web/utils/surah_unicode_data.dart';
import 'package:alquran_web/pages/home_pages/widgets/footer.dart';
import 'package:alquran_web/pages/home_pages/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzListPage extends StatefulWidget {
  const JuzListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JuzListPageState createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage> {
  late Future<Map<int, List<Map<String, dynamic>>>> _juzMappedData;
  final QuranService _quranService = QuranService();
  final JsonParser _juzJsonParser = JsonParser();
  final _quranController = Get.find<QuranController>();
  final readingController = Get.find<ReadingController>();

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 +
        (screenWidth - 1440) / 10000; // Dynamic scaling for larger screens
  }

  @override
  void initState() {
    super.initState();
    _juzMappedData = _fetchJuzMappedData();
  }

  Future<List<Map<String, dynamic>>> getAyasFromJuz(int juzNumber) async {
    try {
      // Fetch the Juz data
      List<Map<String, dynamic>> juzData =
          await _quranService.fetchJuz(juzNumber);

      // Process the data to get Aya details
      List<Map<String, dynamic>> AyaDetails = [];
      for (var item in juzData) {
        int suraId = int.parse(item["SuraId"].toString());
        int AyaFrom = int.parse(item["ayafrom"].toString());

        // Fetch Aya lines for the specific Surah and Aya
        List<Map<String, dynamic>> AyaLines =
            await _quranService.fetchAyaLines(suraId, AyaFrom);

        // Add the Aya details to the list
        AyaDetails.addAll(AyaLines);
      }

      return AyaDetails;
    } catch (e) {
      throw Exception('Failed to load Aya from Juz: $e');
    }
  }

  Future<Map<int, List<Map<String, dynamic>>>> _fetchJuzMappedData() async {
    final surahs = await _quranService.fetchSurahs();
    final juzData = await _juzJsonParser.loadJsonData();
    final Map<int, List<Map<String, dynamic>>> juzMappedData = {};

    for (var surah in surahs) {
      final surahIndex = surah['SuraId'];
      for (final juzIndexString in juzData.keys) {
        final juzIndex = int.parse(juzIndexString);
        final juzDetails = juzData[juzIndexString];
        if (juzDetails!.containsKey(surahIndex.toString())) {
          if (!juzMappedData.containsKey(juzIndex)) {
            juzMappedData[juzIndex] = [];
          }
          juzMappedData[juzIndex]!.add(surah);
        }
      }
    }

    return juzMappedData;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50 // Dynamic padding for larger screens
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              FutureBuilder<Map<int, List<Map<String, dynamic>>>>(
                future: _juzMappedData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final juzMappedData = snapshot.data!;
                    return Column(
                      children: [
                        screenWidth < 650
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(30, (index) {
                                  final juzIndex = index + 1;
                                  final surahs = juzMappedData[juzIndex]!;
                                  return _buildJuzCard(juzIndex, surahs);
                                }),
                              )
                            : screenWidth < 950
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(24, (index) {
                                            final juzIndex = index + 1;
                                            final surahs =
                                                juzMappedData[juzIndex]!;
                                            return _buildJuzCard(
                                                juzIndex, surahs);
                                          }),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(6, (index) {
                                            final juzIndex = index + 25;
                                            final surahs =
                                                juzMappedData[juzIndex]!;
                                            return _buildJuzCard(
                                                juzIndex, surahs);
                                          }),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(19, (index) {
                                            final juzIndex = index + 1;
                                            final surahs =
                                                juzMappedData[juzIndex]!;
                                            return _buildJuzCard(
                                                juzIndex, surahs);
                                          }),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(9, (index) {
                                            final juzIndex = index + 20;
                                            final surahs =
                                                juzMappedData[juzIndex]!;
                                            return _buildJuzCard(
                                                juzIndex, surahs);
                                          }),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildJuzCard(
                                                29, juzMappedData[29]!),
                                            _buildJuzCard(
                                                30, juzMappedData[30]!),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 20), // Add spacing before the footer
              const FooterWidget(), // Add FooterWidget here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJuzCard(int juzIndex, List<Map<String, dynamic>> surahs) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 0,
      color: const Color.fromARGB(255, 244, 244, 244),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Juz $juzIndex',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      // Fetch Aya details for the selected Juz
                      List<Map<String, dynamic>> AyaDetails =
                          await getAyasFromJuz(juzIndex);

                      if (AyaDetails.isNotEmpty) {
                        // Assuming you want to navigate to the first Aya of the Juz
                        final firstAya = AyaDetails.first;
                        int AyaNumber = int.parse(firstAya['AyaNumber']
                            .toString()); // Ensure this key exists
                        int surahId = int.parse(firstAya['SuraId']
                            .toString()); // Ensure this key exists

                        _quranController.updateSelectedSurah(
                            firstAya['MSuraName'], AyaNumber);
                        _quranController.updateSelectedSurahId(
                            surahId, AyaNumber);

                        Get.toNamed(
                          Routes.SURAH_DETAILED,
                          arguments: {
                            'surahId': surahId,
                            'surahName':
                                firstAya['MSuraName'], // Ensure this key exists
                            'AyaNumber': AyaNumber,
                            'initialTab': 1,
                          },
                        );
                      }
                    } catch (e) {
                      // Handle any errors that occur during fetching
                      Get.snackbar('Error', 'Failed to load Aya details: $e');
                    }
                  },
                  child: const Text('Read Juz'),
                )
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: surahs.length,
            itemBuilder: (context, surahIndex) {
              final surah = surahs[surahIndex];
              return _buildSurahCard(surah);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: StarNumber(
          number: int.parse(surah['SuraId']),
        ),
        title: Text(
          surah['MSuraName'],
          style: GoogleFonts.notoSansMalayalam(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Row(
          children: [
            SvgPicture.asset(
              surah['SuraType'] == 'مَكِّيَة'
                  ? "assets/icons/Makiyyah_Icon.svg"
                  : "assets/icons/Madaniyya_Icon.svg",
              height: 11,
              width: 9,
            ),
            const SizedBox(width: 4),
            Text(
              '${surah['TotalAyas']} Ayat',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black,
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
          int AyaNumber = 5;
          final surahId = int.parse(surah['SuraId'].toString());
          final surahName = surah['MSuraName'];
          _quranController.updateSelectedSurah(surah['MSuraName'], AyaNumber);
          _quranController.updateSelectedSurahId(
              int.parse(surah['SuraId'].toString()), AyaNumber);
          _quranController.updateSelectedAyaNumber(AyaNumber);
          readingController.navigateToSpecificSurah(surahId);

          Get.toNamed(
            Routes.SURAH_DETAILED,
            arguments: {
              'surahId': surahId,
              'surahName': surahName,
              'AyaNumber': AyaNumber,
              'initialTab': 1,
            },
          );
        },
      ),
    );
  }
}
