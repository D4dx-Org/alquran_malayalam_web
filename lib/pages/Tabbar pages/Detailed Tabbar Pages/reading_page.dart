// lib/pages/reading_page.dart

import 'dart:async';
import 'dart:math';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/models/content_peice.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  ReadingPageState createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  final ReadingController readingController = Get.find<ReadingController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final AudioController audioController = Get.find<AudioController>();
  bool _isLoading = false;
  Timer? _debounce;
  bool _scrollControllerDisposed = false;

  // List to hold TapGestureRecognizers
  final List<TapGestureRecognizer> _tapGestureRecognizers = [];

  @override
  void initState() {
    super.initState();
    _initializeScrollController();
    _initializeReadingPage();
  }

  Future<void> _initializeReadingPage() async {
    // Wait for the reading controller to be fully initialized
    if (!readingController.isInitialized.value) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !readingController.isInitialized.value;
      });
    }
  }

  void _initializeScrollController() {
    if (_scrollControllerDisposed ||
        readingController.scrollController.hasClients == false) {
      readingController.scrollController = ScrollController();
      readingController.scrollController.addListener(_onScroll);
      _scrollControllerDisposed = false;
    }
  }

  @override
  void dispose() {
    readingController.scrollController.removeListener(_onScroll);
    readingController.scrollController.dispose();
    _scrollControllerDisposed = true;
    _debounce?.cancel();

    for (var recognizer in _tapGestureRecognizers) {
      recognizer.dispose();
    }
    _tapGestureRecognizers.clear();

    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    _scrollControllerDisposed = true;
  }

  @override
  void activate() {
    super.activate();
    _initializeScrollController();
  }

  /// Handles scroll events to load next or previous pages.
  void _onScroll() {
    if (_scrollControllerDisposed) {
      _initializeScrollController();
    }

    // Cancel existing debounce timer
    _debounce?.cancel();

    // Immediate check for previous page loading
    final scrollPosition = readingController.scrollController.position.pixels;
    if (scrollPosition <= 200) {
      _loadPreviousPage();
    }

    // Debounce next page loading
    _debounce = Timer(
      const Duration(milliseconds: 50), // Reduced from 200ms
      () {
        if (!_isLoading) {
          double viewportHeight =
              readingController.scrollController.position.viewportDimension;
          double maxScroll =
              readingController.scrollController.position.maxScrollExtent;
          double visiblePortion = viewportHeight / (maxScroll + viewportHeight);

          if (visiblePortion > 0.1 || scrollPosition >= maxScroll - 200) {
            _loadNextPage();
          }
        }
      },
    );
  }

  /// Loads the next page of verses.
  Future<void> _loadNextPage() async {
    if (_isLoading) return;
    setState(
      () {
        _isLoading = true;
      },
    );

    await readingController.fetchVerses(direction: 'next');

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _loadPreviousPage() async {
    if (_isLoading || readingController.minPageLoaded <= 1) return;

    setState(() => _isLoading = true);

    // Cache current position
    double oldScrollHeight =
        readingController.scrollController.position.extentAfter;

    // Preload threshold - start loading when approaching page boundary
    await readingController.fetchVerses(direction: 'previous');

    setState(() => _isLoading = false);

    // Adjust scroll position after content loads
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_scrollControllerDisposed &&
          readingController.scrollController.hasClients) {
        double newScrollHeight =
            readingController.scrollController.position.extentAfter;
        double scrollOffset = newScrollHeight - oldScrollHeight;
        readingController.scrollController
            .jumpTo(readingController.scrollController.offset + scrollOffset);
      }
    });
  }

  /// Determines the scale factor based on screen width for responsive design.
  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 +
        (screenWidth - 1440) / 10000; // Dynamic scaling for larger screens
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return Scaffold(
      body: GestureDetector(
        onTap: () => readingController.focusNode.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Obx(() {
                    if (!readingController.isInitialized.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (readingController.isLoading.value &&
                        readingController.versesContent.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Stack(
                        children: [
                          _buildMainContent(horizontalPadding),
                          if (readingController.isBuffering.value)
                            const Positioned(
                              top: 16,
                              right: 16,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            AudioPlayerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ScrollConfiguration(
        behavior: NoScrollbarScrollBehavior(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) {
                readingController.focusNode.unfocus();
              },
              child: ListView.builder(
                controller: readingController.scrollController,
                itemCount: readingController.versesContent.length + 1,
                itemBuilder: (context, index) {
                  if (index == readingController.versesContent.length) {
                    return SizedBox(
                      height: max(
                        MediaQuery.of(context).size.height * 0.2,
                        constraints.maxHeight,
                      ),
                    );
                  }
                  return _buildContentPiece(
                    readingController.versesContent[index],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentPiece(ContentPiece piece) {
    if (piece.isSurahName) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            piece.text,
            style: const TextStyle(
              fontFamily: 'SuraNames',
              fontSize: 60,
            ),
          ),
        ),
      );
    } else if (piece.isBismilla) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            piece.text,
            style: TextStyle(fontFamily: 'Amiri_Script', fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (piece.isDivider) {
      return const Divider(
        color: Colors.grey,
        thickness: 2,
        endIndent: 20,
        indent: 20,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Obx(
              () => Focus(
                focusNode: readingController.focusNode,
                child: SelectableText.rich(
                  TextSpan(
                    style: settingsController.quranFontStyle.value.copyWith(
                      height: 2.5,
                    ),
                    children: _buildTextSpans(piece.text),
                  ),
                  textAlign: TextAlign.center,
                  onTap: () {
                    readingController.handleTextSelection();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    }
  }

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    int lastIndex = 0;

    RegExp regex = RegExp(r'(\uFD3F[^\uFD3F\uFD3E]+\uFD3E)');
    Iterable<RegExpMatch> matches = regex.allMatches(text);

    for (final match in matches) {
      if (match.start > lastIndex) {
        String beforeText = text.substring(lastIndex, match.start);
        spans.add(TextSpan(text: beforeText));
      }

      String verseNumberText = match.group(0)!;
      TapGestureRecognizer recognizer = TapGestureRecognizer()
        ..onTapDown = (TapDownDetails details) {
          readingController.focusNode.unfocus();
          _onVerseNumberTapped(verseNumberText);
        };
      _tapGestureRecognizers.add(recognizer);

      spans.add(TextSpan(
        text: verseNumberText,
        style: TextStyle(
          fontFamily: 'Uthmanic_Script',
        ),
        recognizer: recognizer,
      ));

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      String remainingText = text.substring(lastIndex);
      spans.add(TextSpan(text: remainingText));
    }

    return spans;
  }

  void _onVerseNumberTapped(String verseNumberText) {
    // Extract the verse number from the text
    // Assuming verseNumberText is like '\uFD3F١\uFD3E', extract '١' and convert it back to the actual number
    String arabicNumber =
        verseNumberText.replaceAll(RegExp(r'[\uFD3F\uFD3E\s]'), '');
    String ayaNumber = _convertArabicNumbersToEnglish(arabicNumber);

    // Access the current surah ID
    int surahId = readingController.currentSurahId; // Ensure this is available

    // Now you can perform actions like playing the audio
    String verseKey = '$surahId:$ayaNumber';
    // Play the audio for the verse
    audioController.playAya(verseKey);
  }

  String _convertArabicNumbersToEnglish(String arabicNumber) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return arabicNumber
        .split('')
        .map((digit) => englishNumbers[arabicNumbers.indexOf(digit)])
        .join();
  }
}

/// Custom ScrollBehavior that hides the scrollbar
class NoScrollbarScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Return the child without wrapping it in a Scrollbar
  }
}
