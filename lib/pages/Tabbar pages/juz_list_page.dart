import 'package:alquran_web/widgets/star_widget.dart';
import 'package:flutter/material.dart';
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
      'juz': 3,
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
      'juz': 4,
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
      'juz': 5,
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
      'juz': 6,
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
      'juz': 7,
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
      'juz': 8,
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
      'juz': 9,
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
          'number': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'ayat': 286,
          'type': 'Madinah',
        },
        // Add more surah data here
      ],
    },
    // Add more juz data here
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gridViewColor = const Color.fromARGB(255, 244, 244, 244);
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 3;

    if (screenWidth < 480) {
      crossAxisCount = 1;
    } else if (screenWidth < 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    double _calculateCardHeight(BuildContext context, Map<String, dynamic> juz,
        BoxConstraints constraints) {
      final double maxHeight = constraints.maxHeight;
      final double itemHeight =
          60.0; // Adjust this value to control the height of each surah card
      final int surahCount = juz['surahs'].length;
      final double totalHeight = (itemHeight * surahCount) +
          110.0; // 56.0 is the height of the Juz title

      return totalHeight > maxHeight ? maxHeight : totalHeight;
    }

    double _calculateChildAspectRatio(
        BuildContext context, int crossAxisCount) {
      final screenWidth = MediaQuery.of(context).size.width;
      final cardWidth = screenWidth / crossAxisCount;

      // Use the _calculateCardHeight function to determine the card height
      final cardHeight =
          _calculateCardHeight(context, juzList[0], BoxConstraints());

      return cardWidth / cardHeight;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _calculateChildAspectRatio(context, crossAxisCount),
// Adjust this value to control the height-to-width ratio
      ),
      itemCount: juzList.length,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling within the Juz card
                    itemCount: juz['surahs'].length,
                    itemBuilder: (context, surahIndex) {
                      final surah = juz['surahs'][surahIndex];
                      return Card(
                        elevation: 1,
                        color:
                            isDarkMode ? const Color(0xFF3C3C3C) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: StarNumber(number: surah['number']),
                          title: Text(
                            surah['name'],
                            style: TextStyle(
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            surah['arabicName'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
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
//                                   // Navigate to Surah Detailed page with the selected surah
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
//     // Add more juz data here
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final listViewColor = const Color.fromARGB(255, 244, 244, 244);

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isMobile = constraints.maxWidth < 600;
//         final isTablet =
//             constraints.maxWidth >= 600 && constraints.maxWidth < 900;
//         final isDesktop = constraints.maxWidth >= 900;

//         int crossAxisCount = 1;
//         if (isTablet) {
//           crossAxisCount = 2;
//         } else if (isDesktop) {
//           crossAxisCount = 3;
//         }

//         return ListView.builder(
//           itemCount: juzList.length,
//           itemBuilder: (context, index) {
//             final juz = juzList[index];
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 elevation: 0,
//                 color: listViewColor,
//                 child: IntrinsicHeight(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: crossAxisCount,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Juz ${juz['juz']}',
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       for (var surah in juz['surahs'])
//                                         Card(
//                                           elevation: 1,
//                                           color: isDarkMode
//                                               ? const Color(0xFF3C3C3C)
//                                               : Colors.white,
//                                           margin: const EdgeInsets.symmetric(
//                                               vertical: 4),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: ListTile(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     horizontal: 16,
//                                                     vertical: 8),
//                                             leading: StarNumber(
//                                               number: surah['number'],
//                                             ),
//                                             title: Text(
//                                               surah['name'],
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             subtitle: Row(
//                                               children: [
//                                                 SvgPicture.asset(
//                                                   surah['type'] == 'Makkiya'
//                                                       ? "icons/Makiyyah_Icon.svg"
//                                                       : "icons/Madaniyya_Icon.svg",
//                                                   height:
//                                                       11, // Adjust size as needed
//                                                   width: 9,
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Text(
//                                                   '${surah['ayat']} Ayat',
//                                                   style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.black),
//                                                 ),
//                                               ],
//                                             ),
//                                             trailing: Text(
//                                               surah['arabicName'],
//                                               style: TextStyle(
//                                                 color: isDarkMode
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             onTap: () {
//                                               // Navigate to Surah Detailed page with the selected surah
//                                             },
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (!isMobile)
//                         Expanded(
//                           flex: 1,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 8),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     // Navigate to Surah Detailed page with the selected juz
//                                   },
//                                   child: const Text(
//                                     'Read Juz',
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
