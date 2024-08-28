import 'package:alquran_web/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class JuzListPage extends StatelessWidget {
  final List<Map<String, dynamic>> juzList = [
    {
      'juz': 1,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },

        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        // Add more surah data here
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        {
          'number': 1,
          'name': 'Al-Fatihah',
          'arabicName': 'الفاتحة',
          'ayat': 7,
          'type': 'Makkah',
        },
        // Add more surah data here
      ],
    },
    // Add more juz data here
  ];

  JuzListPage({super.key});

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
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${surah['ayat']} Ayat',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                surah['arabicName'],
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
        ),
      ),
    );
  }
}
