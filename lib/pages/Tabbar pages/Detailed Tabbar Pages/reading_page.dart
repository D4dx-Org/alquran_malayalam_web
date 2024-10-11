// lib/pages/reading_page.dart

import 'dart:async';
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

  // FocusNode to manage focus and selection
  final FocusNode _focusNode = FocusNode();

  // List to hold TapGestureRecognizers
  final List<TapGestureRecognizer> _tapGestureRecognizers = [];

  @override
  void initState() {
    super.initState();
    _initializeScrollController();
    readingController.fetchVerses(direction: 'replace');
  }

  void _initializeScrollController() {
    readingController.scrollController = ScrollController();
    readingController.scrollController.addListener(_onScroll);
    _scrollControllerDisposed = false;
  }

  @override
  void dispose() {
    readingController.scrollController.removeListener(_onScroll);
    readingController.scrollController.dispose();
    _scrollControllerDisposed = true;
    _debounce?.cancel();
    _focusNode.dispose(); // Dispose the FocusNode

    // Dispose of all TapGestureRecognizers
    for (var recognizer in _tapGestureRecognizers) {
      recognizer.dispose();
    }
    _tapGestureRecognizers.clear();

    super.dispose();
  }

  /// Handles scroll events to load next or previous pages.
  void _onScroll() {
    // Reinitialize the scroll controller if disposed
    if (_scrollControllerDisposed) {
      _initializeScrollController();
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 200),
      () {
        if (!_isLoading) {
          if (readingController.scrollController.position.pixels >=
              readingController.scrollController.position.maxScrollExtent -
                  200) {
            _loadNextPage();
          } else if (readingController.scrollController.position.pixels <=
              readingController.scrollController.position.minScrollExtent +
                  200) {
            _loadPreviousPage();
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
    if (_isLoading) return;

    if (readingController.minPageLoaded <= 1) {
      debugPrint('Already at the first page.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Save the current scroll offset
    double oldScrollHeight =
        readingController.scrollController.position.extentAfter;

    await readingController.fetchVerses(direction: 'previous');

    setState(() {
      _isLoading = false;
    });

    // After the content is prepended, adjust the scroll position
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollControllerDisposed) {
        _initializeScrollController();
      }

      double newScrollHeight =
          readingController.scrollController.position.extentAfter;
      double scrollOffset = newScrollHeight - oldScrollHeight;
      readingController.scrollController
          .jumpTo(readingController.scrollController.offset + scrollOffset);
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
        onTap: () => _focusNode.unfocus(), // Cancel selection on screen tap
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Obx(() {
                    return readingController.isLoading.value &&
                            readingController.versesContent.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: ScrollConfiguration(
                                behavior: NoScrollbarScrollBehavior(),
                                child: ListView.builder(
                                  controller:
                                      readingController.scrollController,
                                  itemCount: readingController
                                          .versesContent.length +
                                      1, // Add 1 to account for the extra SizedBox
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        readingController
                                            .versesContent.length) {
                                      return SizedBox(
                                        height: screenHeight *
                                            0.2, // Adjust the height as needed
                                      );
                                    }
                                    final ContentPiece piece =
                                        readingController.versesContent[index];
                                    return _buildContentPiece(piece);
                                  },
                                ),
                              ),
                            ),
                          );
                  }),
                ),
              ),
            ),
            AudioPlayerWidget(), // Add the AudioPlayerWidget here
          ],
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
                focusNode: _focusNode,
                child: SelectableText.rich(
                  TextSpan(
                    style: settingsController.quranFontStyle.value.copyWith(
                      height: 2.5,
                    ),
                    children: _buildTextSpans(piece.text),
                  ),
                  textAlign: TextAlign.center,
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

    // Regular expression to match the verse numbers enclosed in Unicode characters
    RegExp regex = RegExp(r'(\uFD3F[^\uFD3F\uFD3E]+\uFD3E)');
    Iterable<RegExpMatch> matches = regex.allMatches(text);

    for (final match in matches) {
      // Add text before the match
      if (match.start > lastIndex) {
        String beforeText = text.substring(lastIndex, match.start);
        spans.add(TextSpan(text: beforeText));
      }

      // Add the matched verse number with Uthmani font and a TapGestureRecognizer
      String verseNumberText = match.group(0)!;
      TapGestureRecognizer recognizer = TapGestureRecognizer()
        ..onTap = () {
          // Handle verse number tap here
          _onVerseNumberTapped(verseNumberText);
        };
      _tapGestureRecognizers.add(recognizer);

      spans.add(TextSpan(
        text: verseNumberText,
        style: TextStyle(
          fontFamily: 'Uthmanic_Script', // Specify the Uthmani font here
        ),
        recognizer: recognizer,
      ));

      lastIndex = match.end;
    }

    // Add remaining text after the last match
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
