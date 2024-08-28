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
                    child: Text(
                      'Juz ${juz['juz']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                                      number:
                                          int.parse(surah['SuraId'].toString()),
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
                                          surah['SuraType'] == 'Makkiya'
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

// import 'package:alquran_web/widgets/star_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class JuzListPage extends StatelessWidget {
//   JuzListPage({super.key});

//   final List<Map<String, dynamic>> juzList = [
//     {
//       'juz': 1,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 2,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 3,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 4,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 5,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 6,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 7,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 8,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     {
//       'juz': 9,
//       'surahs': [
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         {
//           'number': 1,
//           'name': 'Al-Fatihah',
//           'arabicName': 'الفاتحة',
//           'ayat': 7,
//           'type': 'Makkah',
//         },
//         {
//           'number': 2,
//           'name': 'Al-Baqarah',
//           'arabicName': 'البقرة',
//           'ayat': 286,
//           'type': 'Madinah',
//         },
//         // Add more surah data here
//       ],
//     },
//     // Add more juz data here
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final listViewColor = const Color.fromARGB(255, 244, 244, 244);

//     return ListView.builder(
//       itemCount: juzList.length,
//       itemBuilder: (context, index) {
//         final juz = juzList[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             elevation: 0,
//             color: listViewColor,
//             child: IntrinsicHeight(
//               // Wrap the Column with IntrinsicHeight
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Juz ${juz['juz']}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // Navigate to Surah Detailed page with the selected juz
//                           },
//                           child: const Text(
//                             'Read Juz',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     // Wrap the SingleChildScrollView with Expanded
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           for (var surah in juz['surahs'])
//                             Card(
//                               elevation: 1,
//                               color: isDarkMode
//                                   ? const Color(0xFF3C3C3C)
//                                   : Colors.white,
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 8),
//                                 leading: StarNumber(
//                                   number: surah['number'],
//                                 ),
//                                 title: Text(
//                                   surah['name'],
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 subtitle: Row(
//                                   children: [
//                                     SvgPicture.asset(
//                                       surah['type'] == 'Makkiya'
//                                           ? "icons/Makiyyah_Icon.svg"
//                                           : "icons/Madaniyya_Icon.svg",
//                                       height: 11, // Adjust size as needed
//                                       width: 9,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       '${surah['ayat']} Ayat',
//                                       style: TextStyle(
//                                           fontSize: 12, color: Colors.black),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Text(
//                                   surah['arabicName'],
//                                   style: TextStyle(
//                                     color: isDarkMode
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   // Navigate to Surah Detailed page withx the selected surah
//                                 },
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8)
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
