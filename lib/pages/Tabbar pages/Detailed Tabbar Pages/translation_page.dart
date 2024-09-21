import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';
import 'package:alquran_web/widgets/ayah_action_bar.dart';
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
    // itemPositionsListener.itemPositions.addListener(_updateCurrentAyah);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNavigation();
    });
  }

  void _updateCurrentAyah() {
    if (itemPositionsListener.itemPositions.value.isNotEmpty) {
      final firstVisibleItemIndex =
          itemPositionsListener.itemPositions.value.first.index;
      if (firstVisibleItemIndex > 0 &&
          firstVisibleItemIndex < _quranController.ayahLines.length) {
        final visibleAyah =
            _quranController.ayahLines[firstVisibleItemIndex - 1];
        final ayahNumber = int.parse(visibleAyah['AyaNo']);
        _quranController.updateSelectedAyahNumber(ayahNumber);
      }
    }
  }

  void _handleInitialNavigation() async {
    final args = Get.arguments;
    if (args != null && args['ayahNumber'] != null && args['lineId'] != null) {
      final surahId = args['surahId'] as int;
      final ayahNumber = args['ayahNumber'] as int;
      final lineId = args['lineId'] as String;

      await _quranController.ensureAyahIsLoaded(surahId, ayahNumber);
      scrollToAyah(ayahNumber, lineId);
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    itemPositionsListener.itemPositions.removeListener(_updateCurrentAyah);
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading) {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final lastIndex = positions.last.index;
        if (lastIndex >= _quranController.ayahLines.length - 5) {
          _loadMoreAyahLines();
        }
      }
    }
  }

  void scrollToAyah(int ayahNumber, String lineId) {
    final index = _quranController.ayahLines.indexWhere((ayah) =>
        ayah['AyaNo'] == ayahNumber.toString() && ayah['LineId'] == lineId);
    if (index != -1) {
      _quranController.itemScrollController.scrollTo(
        index: index, // +1 to account for the header
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // If the ayah is not found, it might not be loaded yet.
      // You could show a loading indicator here and retry after a short delay.
      Future.delayed(const Duration(milliseconds: 500),
          () => scrollToAyah(ayahNumber, lineId));
    }
  }

  Future<void> _loadMoreAyahLines() async {
    if (_isEndOfSurah()) return;

    setState(() => _isLoading = true);
    await _quranController.fetchMoreAyahLines();
    setState(() => _isLoading = false);
  }

  bool _isEndOfSurah() {
    return _quranController.ayahLines.isNotEmpty &&
        _quranController.ayahLines.last['AyaNo'] ==
            _quranController.selectedSurahAyahCount.toString();
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
                    itemCount: _quranController.ayahLines.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildHeader();
                      } else if (index ==
                          _quranController.ayahLines.length + 1) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      } else {
                        return _buildAyah(
                            _quranController.ayahLines[index - 1]);
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

  Widget _buildAyah(Map<String, dynamic> ayah) {
    int ayahNumber = int.tryParse(ayah['AyaNo'] ?? '') ?? 0;
    String lineId = ayah['LineId'] ?? '';
    String verseKey = "${_quranController.selectedSurahId}:$ayahNumber";

    return HoverableAyah(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => AyahActionBar(
                  ayahNumber: ayahNumber,
                  lineId: lineId,
                  onPlayPressed: () {
                    _audioController.playAyah(verseKey);
                  },
                  onBookmarkPressed: () {
                    _bookmarkController.toggleBookmark(
                      _quranController.selectedSurahId,
                      ayahNumber,
                      lineId,
                    );
                  },
                  isBookmarked: _bookmarkController.isAyahBookmarked(
                    _quranController.selectedSurahId,
                    ayahNumber,
                    lineId,
                  ),
                  lineWords: ayah['LineWords'],
                  translation: ayah['MalTran'],
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  children: [
                    ...(ayah['LineWords'] as List<Map<String, dynamic>>).map(
                      (word) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child:
                            _buildArabicWord(word['ArabWord'], word['MalWord']),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => SelectableText(
                    ayah['MalTran'],
                    style: TextStyle(
                      fontSize: _settingsController.translationFontSize.value,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Color.fromRGBO(194, 194, 194, 1),
            thickness: 2,
            height: 32,
          ),
        ],
      ),
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
          const SizedBox(height: 4),
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

class HoverableAyah extends StatefulWidget {
  final Widget child;

  const HoverableAyah({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _HoverableAyahState createState() => _HoverableAyahState();
}

class _HoverableAyahState extends State<HoverableAyah> {
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
          color: _isHovered ? Colors.grey[200] : Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
