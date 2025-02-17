// lib/pages/reading_page.dart

import 'dart:async';
import 'dart:math';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/models/content_peice.dart';
import 'package:alquran_web/widgets/audio_player/audio_player_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:developer' as developer;

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
  final FocusNode _pageFocusNode = FocusNode(debugLabel: 'ReadingPageFocus');

  // List to hold TapGestureRecognizers
  final List<TapGestureRecognizer> _tapGestureRecognizers = [];

  @override
  void initState() {
    super.initState();
    developer.log('Reading page initialized', name: 'ReadingPage');
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
    _pageFocusNode.dispose();

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
      return;
    }

    _debounce?.cancel();
    final scrollPosition = readingController.scrollController.position.pixels;

    if (scrollPosition <= 200) {
      _loadPreviousPage();
    }

    _debounce = Timer(
      const Duration(milliseconds: 50),
      () {
        if (!_isLoading && readingController.scrollController.hasClients) {
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
    double oldScrollHeight =
        readingController.scrollController.position.extentAfter;
    await readingController.fetchVerses(direction: 'previous');

    if (mounted) {
      setState(() => _isLoading = false);

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
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);
    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return SelectionArea(
      child: Focus(
        focusNode: _pageFocusNode,
        onFocusChange: (hasFocus) {
          developer.log('Reading page focus changed: hasFocus=$hasFocus',
              name: 'ReadingPage');
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Obx(() {
                      if (!readingController.isInitialized.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (readingController.isLoading.value &&
                          readingController.versesContent.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
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
            return ListView.builder(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentPiece(ContentPiece piece) {
    if (piece.isSurahName) {
      return VisibilityDetector(
        key: Key('surah_${piece.surahId}'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction > 0.5) {
            readingController.updateVisibleSurah(piece.surahId);
          }
        },
        child: Padding(
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
      final currentSurahId = piece.surahId;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Obx(
              () => MouseRegion(
                cursor: SystemMouseCursors.text,
                child: SelectableText.rich(
                  TextSpan(
                    style: settingsController.quranFontStyle.value.copyWith(
                      height: 2.5,
                    ),
                    children: _buildTextSpans(piece.text, currentSurahId),
                  ),
                  textAlign: TextAlign.center,
                  onSelectionChanged: (selection, cause) {
                    developer.log(
                      'Text selection changed: ${selection.toString()}',
                      name: 'ReadingPage',
                    );
                  },
                  contextMenuBuilder: (context, editableTextState) {
                    return AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: editableTextState,
                    );
                  },
                  enableInteractiveSelection: true,
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

  List<TextSpan> _buildTextSpans(String text, int surahId) {
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
          developer.log('Verse number tap down: ${details.globalPosition}',
              name: 'ReadingPage');
          _onVerseNumberTapped(verseNumberText, surahId);
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

  void _onVerseNumberTapped(String verseNumberText, int surahId) {
    String arabicNumber =
        verseNumberText.replaceAll(RegExp(r'[\uFD3F\uFD3E\s]'), '');
    String ayaNumber = _convertArabicNumbersToEnglish(arabicNumber);

    audioController.playAya('$surahId:$ayaNumber');

    Get.snackbar(
      'Playing Audio',
      'Playing Surah $surahId, Verse $ayaNumber',
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    );
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
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
