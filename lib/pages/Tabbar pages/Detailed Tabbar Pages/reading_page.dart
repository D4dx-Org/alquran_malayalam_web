import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final ReadingController _readingController = Get.find<ReadingController>();

  final SettingsController _settingsController = Get.find<SettingsController>();

  final QuranController _quranController = Get.find<QuranController>();

  final AudioController _audioController = Get.find<AudioController>();
  // final List<GlobalKey> _ayahKeys = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReadingController>(builder: (_) {
      return SelectionArea(
        child: Scaffold(
          body: Stack(
            children: [
              Obx(
                () => _readingController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: ScrollablePositionedList.builder(
                                itemCount: _readingController.verses.length +
                                    1, // +1 for header
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return _buildHeader(); // Header at index 0
                                  } else {
                                    return _buildContinuousText(
                                        index - 1); // Adjust index for verses
                                  }
                                },
                                itemScrollController:
                                    _readingController.itemScrollController,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Obx(() => _audioController.isPlaying.value
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AudioPlayerWidget(),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     _scrollToVerse(60); // Scroll to Ayah 50
            //   },
            //   child: const Text('Scroll to Ayah 50'),
            // ),
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
            Text(
              _quranController.selectedSurah,
              style: GoogleFonts.notoSans(
                  fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _audioController
                        .playSurah(_quranController.selectedSurahId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                    foregroundColor: Colors.black,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded),
                      SizedBox(width: 8),
                      Text('Play'),
                    ],
                  ),
                ),
              ],
            ),
            // Only show Bismillah image if it's not Surah Al-Fatihah (1) or At-Tawbah (9)
            if (_quranController.selectedSurahId != 1 &&
                _quranController.selectedSurahId != 9)
              Obx(
                () {
                  // Calculate image size based on Quran font size
                  double imageSize = _settingsController.quranFontSize.value *
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
          ],
        ),
      ),
    );
  }

  Widget _buildContinuousText(int index) {
    final verse = _readingController.verses[index];
    String arabicNumber =
        _convertToArabicNumbers(verse.verseNumber.split(':').last);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            text: TextSpan(
              style: _settingsController.quranFontStyle.value
                  .copyWith(height: 2.0),
              children: [
                TextSpan(
                  text: '${verse.arabicText} ',
                  style: _settingsController.quranFontStyle.value,
                ),
                TextSpan(
                  text: '$arabicNumber ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _audioController.playAyah(verse.verseNumber);
                    },
                  style: _settingsController.quranFontStyle.value.copyWith(
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Make verse number visually distinct
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  String _convertToArabicNumbers(String number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String arabicNumber =
        number.split('').map((digit) => arabicNumbers[int.parse(digit)]).join();
    return '\uFD3F$arabicNumber\uFD3E';
  }
}
