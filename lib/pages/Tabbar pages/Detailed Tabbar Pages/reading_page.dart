// lib/pages/reading_page.dart

import 'dart:async';

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/models/content_peice.dart';
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
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    readingController.scrollController.addListener(_onScroll);
    readingController.fetchVerses(direction: 'replace');
  }

  @override
  void dispose() {
    readingController.scrollController.removeListener(_onScroll);
    readingController.scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Handles scroll events to load next or previous pages.
  void _onScroll() {
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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Obx(() {
            return readingController.isLoading.value &&
                    readingController.versesContent.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: ScrollConfiguration(
                        behavior: NoScrollbarScrollBehavior(),
                        child: ListView.builder(
                          controller: readingController.scrollController,
                          itemCount: readingController.versesContent.length +
                              1, // Add 1 to account for the extra SizedBox
                          itemBuilder: (context, index) {
                            if (index ==
                                readingController.versesContent.length) {
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
              () => Text(
                piece.text,
                style: settingsController.quranFontStyle.value.copyWith(
                  height: 2.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      );
    }
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
