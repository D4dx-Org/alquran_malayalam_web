// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';
import 'package:alquran_web/widgets/Ayah_action_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final _quranController = Get.find<QuranController>();
  final _settingsController = Get.find<SettingsController>();
  final _bookmarkController = Get.find<BookmarkController>();
  final _audioController = Get.find<AudioController>();
  // final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onScroll);
    // itemPositionsListener.itemPositions.addListener(_updateCurrentAya);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNavigation();
    });
  }

  void _updateCurrentAya() {
    if (itemPositionsListener.itemPositions.value.isNotEmpty) {
      final firstVisibleItemIndex =
          itemPositionsListener.itemPositions.value.first.index;
      if (firstVisibleItemIndex > 0 &&
          firstVisibleItemIndex < _quranController.AyaLines.length) {
        final visibleAya = _quranController.AyaLines[firstVisibleItemIndex - 1];
        final AyaNumber = int.parse(visibleAya['AyaNo']);
        _quranController.updateSelectedAyaNumber(AyaNumber);
      }
    }
  }

  void _handleInitialNavigation() async {
    final args = Get.arguments;
    if (args != null && args['AyaNumber'] != null && args['lineId'] != null) {
      final surahId = args['surahId'] as int;
      final AyaNumber = args['AyaNumber'] as int;
      final lineId = args['lineId'] as String;

      await _quranController.ensureAyaIsLoaded(surahId, AyaNumber);
      scrollToAya(AyaNumber, lineId);
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    itemPositionsListener.itemPositions.removeListener(_updateCurrentAya);
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading) {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        // Check for scrolling down (load more)
        final lastIndex = positions.last.index;
        if (lastIndex >= _quranController.AyaLines.length - 5) {
          _loadMoreAyaLines();
        }

        // Check for scrolling up (load previous)
        final firstIndex = positions.first.index;
        if (firstIndex <= 5) {
          _loadPreviousAyaLines();
        }
      }
    }
  }

  Future<void> _loadPreviousAyaLines() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (_quranController.AyaLines.isNotEmpty) {
        final firstAyaNo =
            int.parse(_quranController.AyaLines.first['AyaNo'].toString());
        if (firstAyaNo > 1) {
          // Load previous 10 verses
          final startAya = (firstAyaNo - 10).clamp(1, firstAyaNo - 1);
          for (int ayaNo = startAya; ayaNo < firstAyaNo; ayaNo++) {
            await _quranController.ensureAyaIsLoaded(
                _quranController.selectedSurahId, ayaNo);
          }
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void scrollToAya(int AyaNumber, String lineId) {
    final index = _quranController.AyaLines.indexWhere((Aya) =>
        Aya['AyaNo'] == AyaNumber.toString() && Aya['LineId'] == lineId);
    if (index != -1) {
      _quranController.itemScrollController.scrollTo(
        index: index, // +1 to account for the header
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // If the Aya is not found, it might not be loaded yet.
      // You could show a loading indicator here and retry after a short delay.
      Future.delayed(const Duration(milliseconds: 500),
          () => scrollToAya(AyaNumber, lineId));
    }
  }

  Future<void> _loadMoreAyaLines() async {
    if (_isEndOfSurah()) return;

    setState(() => _isLoading = true);
    await _quranController.fetchMoreAyaLines();
    setState(() => _isLoading = false);
  }

  bool _isEndOfSurah() {
    return _quranController.AyaLines.isNotEmpty &&
        _quranController.AyaLines.last['AyaNo'] ==
            _quranController.selectedSurahAyaCount.toString();
  }

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 +
        (screenWidth - 1440) / 10000; // Dynamic scaling for larger screens
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

    return SelectionArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(
                  () => ScrollablePositionedList.builder(
                    itemScrollController: _quranController.itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemCount: _quranController.AyaLines.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildHeader();
                      } else if (index ==
                          _quranController.AyaLines.length + 1) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      } else {
                        return _buildAya(_quranController.AyaLines[index - 1]);
                      }
                    },
                  ),
                ),
              ),
            ),
            AudioPlayerWidget(),
          ],
        ),
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
              double imageSize = _settingsController.quranFontSize.value *
                  8; // Adjust the multiplier as needed

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: imageSize,
                    maxHeight: imageSize /
                        2, // Assuming a 2:1 aspect ratio, adjust as needed
                  ),
                  child: Text(
                    '\uFDFD',
                    style: TextStyle(fontFamily: 'Amiri_Script', fontSize: 25),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAya(Map<String, dynamic> Aya) {
    int AyaNumber = int.tryParse(Aya['AyaNo'] ?? '') ?? 0;
    String lineId = Aya['LineId'] ?? '';
    String verseKey = "${_quranController.selectedSurahId}:$AyaNumber";

    return Column(
      children: [
        HoverableAya(
          isPlaying: verseKey ==
              _audioController.currentAya
                  .value, // Check if this is the currently playing Aya
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => AyaActionBar(
                      AyaNumber: AyaNumber,
                      lineId: lineId,
                      onPlayPressed: () {
                        _audioController.playAya(verseKey);
                      },
                      onBookmarkPressed: () {
                        _bookmarkController.toggleBookmark(
                          _quranController.selectedSurahId,
                          AyaNumber,
                          lineId,
                        );
                      },
                      isBookmarked: _bookmarkController.isAyaBookmarked(
                        _quranController.selectedSurahId,
                        AyaNumber,
                        lineId,
                      ),
                      lineWords: Aya['LineWords'],
                      translation: Aya['MalTran'],
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: [
                          ...(Aya['LineWords'] as List<Map<String, dynamic>>)
                              .map(
                            (word) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: _buildArabicWord(
                                  word['ArabWord'], word['MalWord']),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () => SelectableText(
                        Aya['MalTran'],
                        style: TextStyle(
                          fontSize:
                              _settingsController.translationFontSize.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromRGBO(194, 194, 194, 1),
          thickness: 2,
          height: 32,
        ),
      ],
    );
  }

  Widget _buildArabicWord(String arabicWord, String translation) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(194, 194, 194, 1),
        ),
        color: const Color.fromARGB(255, 244, 244, 244),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => SelectableText(
              arabicWord,
              style: _settingsController.quranFontStyle.value,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => SelectableText(
              translation,
              style: TextStyle(
                fontSize: _settingsController.translationFontSize.value,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class HoverableAya extends StatefulWidget {
  final Widget child;
  final bool
      isPlaying; // New parameter to indicate if this Aya is currently playing

  const HoverableAya({
    super.key,
    required this.child,
    this.isPlaying = false, // Default to false if not provided
  });

  @override
  HoverableAyaState createState() => HoverableAyaState();
}

class HoverableAyaState extends State<HoverableAya> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isPlaying || _isHovered
                ? Colors
                    .grey[200] // Apply hover effect if it's hovered or playing
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(12), // Adjust the radius as needed
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
