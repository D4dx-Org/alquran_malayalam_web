import 'package:alquran_web/services/quran_services.dart';
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
  late Future<List<Map<String, dynamic>>> _juzList;
  final QuranService _quranService = QuranService();

  @override
  void initState() {
    super.initState();
    _juzList = _fetchJuzList();
  }

  Future<List<Map<String, dynamic>>> _fetchJuzList() async {
    final surahs = await _quranService.fetchSurahs();
    final juzList = <Map<String, dynamic>>[];

    int currentJuz = 1;
    List<Map<String, dynamic>> currentJuzSurahs = [];

    for (final surah in surahs) {
      if (currentJuzSurahs.length == 0 || currentJuzSurahs.length >= 20) {
        if (currentJuzSurahs.isNotEmpty) {
          juzList.add({
            'juz': currentJuz,
            'surahs': currentJuzSurahs,
          });
        }
        currentJuz++;
        currentJuzSurahs = [];
      }
      currentJuzSurahs.add(surah);
    }

    if (currentJuzSurahs.isNotEmpty) {
      juzList.add({
        'juz': currentJuz,
        'surahs': currentJuzSurahs,
      });
    }

    return juzList;
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
<<<<<<< Updated upstream
        child: MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          itemCount: juzList.length,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final juz = juzList[index];
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
                          'Juz ${juz['juz']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                            onPressed: () {}, child: const Text('Read Juz'))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: juz['surahs'].length *
                        80.0, // Adjust the height based on the number of surahs
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: juz['surahs'].length,
                        itemExtent: 70.0,
                        itemBuilder: (context, surahIndex) {
                          final surah = juz['surahs'][surahIndex];
                          return Card(
                            elevation: 1,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              leading: StarNumber(number: surah['number']),
                              title: Text(
                                surah['name'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  SvgPicture.asset(
                                    surah['type'] == 'Makkiya'
                                        ? "icons/Makiyyah_Icon.svg"
                                        : "icons/Madaniyya_Icon.svg",
                                    height: 11,
                                    width: 9,
=======
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _juzList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final juzList = snapshot.data!;
              return MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                itemCount: juzList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final juz = juzList[index];
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
                                'Juz ${juz['juz']}',
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> fad2abc80adc68a1adf38a75da40db78d2d4f8bd
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
<<<<<<< HEAD
<<<<<<< Updated upstream
                              onTap: () {
                                // Navigate to Surah Detailed page with the selected surah
=======
=======
>>>>>>> fad2abc80adc68a1adf38a75da40db78d2d4f8bd
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Read Juz'))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: juz['surahs'].length *
                              80.0, // Adjust the height based on the number of surahs
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: juz['surahs'].length,
                              itemExtent: 70.0,
                              itemBuilder: (context, surahIndex) {
                                final surah = juz['surahs'][surahIndex];
                                return Card(
                                  elevation: 1,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
>>>>>>> Stashed changes
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
<<<<<<< HEAD
                                          surah['SuraType'] == 'مَكِّيَة'
=======
                                          surah['SuraType'] == 'Makkiya'
>>>>>>> fad2abc80adc68a1adf38a75da40db78d2d4f8bd
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
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> fad2abc80adc68a1adf38a75da40db78d2d4f8bd
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
