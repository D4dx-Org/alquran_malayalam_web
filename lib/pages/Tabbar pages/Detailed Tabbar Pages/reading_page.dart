import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingPage extends StatelessWidget {
  ReadingPage({super.key});

  final ReadingController readingController = Get.put(ReadingController());
  final SettingsController settingsController = Get.find<SettingsController>();
  final _quranController = Get.find<QuranController>();

  @override
  Widget build(BuildContext context) {
    // Fetch verses on initial load
    readingController.fetchVerses(readingController.currentPage.value);

    return Scaffold(
      body: Obx(() {
        return readingController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        children: [
                          // Build the header
                          if (readingController.currentPage.value == 0)
                            _buildHeader(),
                          // Display the verses text
                          Text(
                            readingController.versesText.value,
                            style: settingsController.quranFontStyle.value
                                .copyWith(
                              height: 2, // Adjust this value for line spacing
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              _quranController
                  .getSurahNameUnicode(_quranController.selectedSurahId),
              style: const TextStyle(
                fontFamily: 'SuraNames',
                fontSize: 60,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                // For smaller screens, use a column layout
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _quranController.selectedSurah,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(${_quranController.getSurahMalMean(_quranController.selectedSurahId)})',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else {
                // For larger screens, keep the row layout
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _quranController.selectedSurah,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(${_quranController.getSurahMalMean(_quranController.selectedSurahId)})',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        // Only show Bismillah image if it's not Surah Al-Fatihah
        if (_quranController.selectedSurahId != 1 &&
            _quranController.selectedSurahId != 9)
          Obx(
            () {
              // Calculate image size based on Quran font size
              double imageSize = settingsController.quranFontSize.value *
                  8; // Adjust the multiplier as needed

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: imageSize,
                  maxHeight: imageSize /
                      2, // Assuming a 2:1 aspect ratio, adjust as needed
                ),
                child: Image.asset(
                  'images/Bismi.png',
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
