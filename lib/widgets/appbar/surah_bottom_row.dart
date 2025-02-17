// ignore_for_file: non_constant_identifier_names

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/widgets/search/search_widget.dart';

import '../../controllers/audio_controller.dart';

class SurahBottomRow extends StatefulWidget {
  final double scaleFactor;
  final TabController tabController;

  const SurahBottomRow(this.scaleFactor,
      {required this.tabController, super.key});

  @override
  SurahBottomRowState createState() => SurahBottomRowState();
}

class SurahBottomRowState extends State<SurahBottomRow>
    with SingleTickerProviderStateMixin {
  final _quranController = Get.find<QuranController>();
  final _audioController = Get.find<AudioController>();
  final readingController = Get.find<ReadingController>();

  bool _showSearchBar = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _showSearchBar = false;
      });
    }
  }

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 + (screenWidth - 1440) / 10000;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);
    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    final isLargeScreen = screenWidth > 800;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        color: const Color.fromRGBO(115, 78, 9, 1),
        height: 50,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      // First Drop Down
                      Obx(
                        () => CustomDropdown(
                          options: List.generate(
                            _quranController.surahIds.length,
                            (index) =>
                                '${_quranController.surahIds[index]} - ${_quranController.surahNames[index]}',
                          ),
                          selectedValue:
                              '${readingController.visibleSurahId} - ${_quranController.getSurahName(readingController.visibleSurahId)}',
                          onChanged: (value) {
                            if (value != null) {
                              final parts = value.split(' - ');
                              int newSurahId = int.parse(parts[0]);

                              // Update selectedSurahId and trigger navigation
                              _quranController.updateSelectedSurahId(
                                  newSurahId, 1);

                              // Navigate to the selected Surah in the ReadingPage
                              readingController
                                  .navigateToSpecificSurah(newSurahId);
                            }
                          },
                          scaleFactor: widget.scaleFactor,
                        ),
                      ),

                      // Second Drop Down
                      Obx(
                        () => CustomDropdown(
                          options: List.generate(
                            _quranController.selectedSurahAyaCount,
                            (index) => '${index + 1}',
                          ),
                          selectedValue:
                              _quranController.selectedAyaNumber.toString(),
                          onChanged: (value) async {
                            if (value != null) {
                              int AyaNumber = int.parse(value);

                              // Show loading indicator
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                barrierDismissible: false,
                              );

                              // Check if the audio is currently playing
                              bool wasPlaying =
                                  _audioController.isPlaying.value;

                              if (_audioController.isPlaying.value) {
                                // Stop the current Surah audio before switching to another Aya
                                _audioController.stopSurahPlayback();
                              }

                              try {
                                // First ensure the data is loaded
                                await _quranController.ensureAyaIsLoaded(
                                  _quranController.selectedSurahId,
                                  AyaNumber,
                                );

                                // Update the UI state first
                                _quranController
                                    .updateSelectedAyaNumber(AyaNumber);

                                // Now get the line IDs after data is loaded
                                Map<int, int> startingLineIds =
                                    _quranController.getAyaStartingLineIds();

                                // Try to find the exact line ID
                                int? lineId = startingLineIds[AyaNumber];

                                if (lineId != null) {
                                  // Close loading dialog
                                  Get.back();

                                  // Scroll to the verse using the found line ID
                                  _quranController.scrollToAya(
                                      AyaNumber, lineId.toString());

                                  // Resume audio if it was playing
                                  if (wasPlaying) {
                                    await _audioController.playSpecificAya(
                                      _quranController.selectedSurahId,
                                      AyaNumber,
                                    );
                                  }
                                } else {
                                  Get.back(); // Close loading dialog
                                  throw Exception(
                                      'Verse $AyaNumber not found in the loaded data. Available verses: ${startingLineIds.keys.toList().join(", ")}');
                                }
                              } catch (e) {
                                Get.back(); // Close loading dialog
                                debugPrint('Error navigating to Aya: $e');
                                Get.snackbar(
                                  'Error',
                                  'Failed to navigate to verse $AyaNumber. Please try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            }
                          },
                          scaleFactor: widget.scaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showSearchBar)
                  Expanded(
                    child: isLargeScreen
                        ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: 400,
                                child: SearchWidget(
                                  width: 400,
                                  onSearch: (query) {},
                                  focusNode: _searchFocusNode,
                                ),
                              ),
                            ],
                          )
                        : SearchWidget(
                            width: screenWidth,
                            onSearch: (query) {},
                            focusNode: _searchFocusNode,
                          ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_showSearchBar || isLargeScreen)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showSearchBar = true;
                            _searchFocusNode.requestFocus();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: const Color.fromRGBO(115, 78, 9, 1),
                          foregroundColor:
                              const Color.fromRGBO(162, 132, 94, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(162, 132, 94, 1),
                            width: 2,
                          ),
                          minimumSize: const Size(50, 40),
                        ),
                        child: const Icon(
                          Icons.search_outlined,
                          color: Colors.white,
                        ),
                      ),
                    if (!_showSearchBar || isLargeScreen) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _quranController.navigateToPreviousSurah();
                          _quranController.resetToFirstAya();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: const Color.fromRGBO(115, 78, 9, 1),
                          foregroundColor:
                              const Color.fromRGBO(162, 132, 94, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(162, 132, 94, 1),
                            width: 2,
                          ),
                          minimumSize: const Size(50, 40),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _quranController.navigateToNextSurah();
                          _quranController.resetToFirstAya();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: const Color.fromRGBO(115, 78, 9, 1),
                          foregroundColor:
                              const Color.fromRGBO(162, 132, 94, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(162, 132, 94, 1),
                            width: 2,
                          ),
                          minimumSize: const Size(50, 40),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            Obx(
              () => _quranController.isLoadingEntireSurah.value
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final double scaleFactor;

  const CustomDropdown({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(92, 62, 5, 1),
        border: Border.all(
          color: const Color(0xFF825B11),
          width: 2 * scaleFactor,
        ),
        borderRadius: BorderRadius.circular(10 * scaleFactor),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: 30 * scaleFactor,
          child: DropdownButton<String>(
            value: selectedValue,
            icon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: const Color.fromRGBO(130, 91, 17, 1),
              size: 20 * scaleFactor,
            ),
            style: GoogleFonts.notoSansMalayalam(
              color: const Color.fromRGBO(217, 217, 217, 1),
              fontSize: 16 * scaleFactor,
            ),
            dropdownColor: const Color.fromRGBO(130, 90, 17, 1),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
