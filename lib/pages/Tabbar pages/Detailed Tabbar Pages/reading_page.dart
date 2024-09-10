import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';

class ReadingPage extends StatelessWidget {
  final ReadingController _readingController = Get.find<ReadingController>();
  final SettingsController _settingsController = Get.find<SettingsController>();
  final QuranController _quranController = Get.find<QuranController>();
  final AudioController _audioController = Get.find<AudioController>();

  ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => _readingController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildHeader(),
                                _buildContinuousText(),
                              ],
                            ),
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
                  .getArabicSurahName(_quranController.selectedSurahId),
              style: _settingsController.quranFontStyle.value,
            ),
          ),
        ),
        Text(
          _quranController.selectedSurah,
          style:
              GoogleFonts.notoSans(fontSize: 18, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContinuousText() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _audioController
                        .playSurah(_quranController.selectedSurahId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 241,
                        241), // Change this to your desired background color
                    foregroundColor: Colors
                        .black, // This sets the color of the text and icon
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize
                        .min, // This ensures the button size fits its content
                    children: [
                      Icon(Icons.play_arrow_rounded),
                      SizedBox(
                          width: 8), // Add some space between the icon and text
                      Text('Play'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Obx(
                () => RichText(
                  text: TextSpan(
                    style: _settingsController.quranFontStyle.value,
                    children: _readingController.verses.map((verse) {
                      String arabicNumber = _convertToArabicNumbers(
                          verse.verseNumber.split(':').last);
                      return TextSpan(
                        text: '${verse.arabicText} $arabicNumber ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _audioController.playAyah(verse.verseNumber);
                          },
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
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
