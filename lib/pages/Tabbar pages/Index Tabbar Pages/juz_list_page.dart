
import 'package:alquran_web/services/quran_services.dart';
import 'package:alquran_web/services/utils.dart';
import 'package:alquran_web/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class JuzListPage extends StatefulWidget {
  JuzListPage({super.key});

  @override
  _JuzListPageState createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage> {
  late Future<Map<int, List<Map<String, dynamic>>>> _juzMappedData;
  final QuranService _quranService = QuranService();
  final JuzJsonParser _juzJsonParser = JuzJsonParser();

  @override
  void initState() {
    super.initState();
    _juzMappedData = _fetchJuzMappedData();
  }

  Future<Map<int, List<Map<String, dynamic>>>> _fetchJuzMappedData() async {
    final surahs = await _quranService.fetchSurahs();
    final juzData = await _juzJsonParser.loadJsonData();
    final Map<int, List<Map<String, dynamic>>> juzMappedData = {};

    surahs.forEach((surah) {
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
    });

    return juzMappedData;
  }

  @override
  Widget build(BuildContext context) {
    const gridViewColor = Color.fromARGB(255, 244, 244, 244);
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 3;

    if (screenWidth < 480) {
      crossAxisCount = 1;
    } else if (screenWidth < 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: FutureBuilder<Map<int, List<Map<String, dynamic>>>>(
          future: _juzMappedData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final juzMappedData = snapshot.data!;
              return MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                itemCount: juzMappedData.keys.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final juzIndex = juzMappedData.keys.elementAt(index);
                  final surahs = juzMappedData[juzIndex]!;
                  return Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 0,
                    color: gridViewColor,
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
                                  onPressed: () {},
                                  child: const Text('Read Juz'))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: surahs.length *
                              80.0, // Adjust the height based on the number of surahs
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: surahs.length,
                              itemExtent: 70.0,
                              itemBuilder: (context, surahIndex) {
                                final surah = surahs[surahIndex];
                                return Card(
                                  elevation: 1,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    leading: StarNumber(
                                      number: int.parse(surah['SuraId']),
                                    ),
                                    title: Text(
                                      surah['MSuraName'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
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
                                        const SizedBox(width: 4),
                                        Text(
                                          '${surah['TotalAyas']} Ayat',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      surah['ASuraName'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      // Navigate to Surah Detailed page with the selected surah
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
      ),
    );
  }
}
