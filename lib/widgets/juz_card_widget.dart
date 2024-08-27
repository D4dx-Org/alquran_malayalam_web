import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'surah_card_widget.dart';

class JuzCardWidget extends StatelessWidget {
  final Map<String, dynamic> juzData;

  const JuzCardWidget({super.key, required this.juzData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final listViewColor = const Color.fromARGB(255, 244, 244, 244);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 0,
      color: listViewColor,
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Juz ${juzData['juz']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Surah Detailed page with the selected juz
                    },
                    child: const Text(
                      'Read Juz',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var surah in juzData['surahs'])
                      SurahCardWidget(
                        surah: surah,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
