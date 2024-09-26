// lib/pages/reading_page.dart

import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/models/content_peice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  ReadingPageState createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  final ReadingController readingController = Get.find<ReadingController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch for the first page
    readingController.fetchVerses(readingController.currentPage.value);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handles scroll events to load next or previous pages.
  void _onScroll() {
    if (!_isLoading) {
      // Load next page when scrolling down
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // Threshold
        _loadNextPage();
      }
      // Load previous page when scrolling up
      else if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent) {
        // Threshold
        _loadPreviousPage();
      }
    }
  }

  /// Loads the next page of verses.
  Future<void> _loadNextPage() async {
    setState(() {
      _isLoading = true;
    });

    await readingController.nextPage();

    setState(() {
      _isLoading = false;
    });
  }

  /// Loads the previous page of verses.
  Future<void> _loadPreviousPage() async {
    if (readingController.currentPage.value > 1) {
      setState(() {
        _isLoading = true;
      });

      await readingController.previousPage();

      setState(() {
        _isLoading = false;
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

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Obx(() {
            return readingController.isLoading.value &&
                    readingController.versesContent.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: ScrollConfiguration(
                            behavior: NoScrollbarScrollBehavior(),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  readingController.versesContent.length +
                                      2, // +2 for footer items
                              itemBuilder: (context, index) {
                                if (index <
                                    readingController.versesContent.length) {
                                  final ContentPiece piece =
                                      readingController.versesContent[index];
                                  return _buildContentPiece(piece);
                                } else {
                                  // Footer items
                                  if (index ==
                                      readingController.versesContent.length) {
                                    // Divider
                                    return const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                      endIndent: 20,
                                      indent: 20,
                                    );
                                  } else if (index ==
                                      readingController.versesContent.length +
                                          1) {
                                    // SizedBox(height: 50)
                                    return const SizedBox(height: 50);
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }

  /// Builds each ContentPiece widget based on its type.
  Widget _buildContentPiece(ContentPiece piece) {
    if (piece.isBismilla) {
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
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Obx(
          () => Text(
            piece.text,
            style: settingsController.quranFontStyle.value.copyWith(
              height: 2.5, // Adjust this value for line spacing
            ),
            textAlign: TextAlign.center, // Arabic is RTL
          ),
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
