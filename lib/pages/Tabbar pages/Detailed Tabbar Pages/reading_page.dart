import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/reading_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
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
  final _quranController = Get.find<QuranController>();

  final _scrollController = ScrollController();
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

  void _onScroll() {
    if (!_isLoading) {
      // Load next page when scrolling down
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
      // Load previous page when scrolling up
      else if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent) {
        _loadPreviousPage();
      }
    }
  }

  Future<void> _loadNextPage() async {
    setState(() {
      _isLoading = true;
    });

    await readingController.nextPage();

    setState(() {
      _isLoading = false;
    });
  }

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

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 +
        (screenWidth - 1440) / 10000; // Dynamic scaling for larger screens
  }

  @override
  Widget build(BuildContext context) {
    _printAllGlobalKeys();

    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return Scaffold(
      body: Obx(() {
        return readingController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: ScrollConfiguration(
                          behavior: NoScrollbarScrollBehavior(),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _getItemCount(),
                            itemBuilder: (context, index) {
                              return _buildListItem(index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }

  void _printAllGlobalKeys() {
    for (var key in readingController.verseKeys) {
      print('Global Key: ${key.value}'); // Print the key value
    }
  }

  int _getItemCount() {
    final verses = readingController.versesText.value
        .split(' \uFD3E '); // Split the verses based on the delimiter

    // Determine if header needs to be inserted and at what index
    int headerIndex = -1;
    for (int i = 0; i < readingController.verseKeys.length; i++) {
      if (readingController.verseKeys[i].value == 1) {
        headerIndex = i;
        break;
      }
    }

    // Additional items at the end (Divider and SizedBox)
    int footerItemCount = 2; // Divider and SizedBox
    if (_isLoading) {
      footerItemCount += 1; // For loading indicator
    }

    return verses.length +
        (headerIndex != -1 ? 1 : 0) +
        footerItemCount; // Total item count
  }

  Widget _buildListItem(int index) {
    final verses = readingController.versesText.value.split(' \uFD3E ');
    int headerIndex = -1;
    for (int i = 0; i < readingController.verseKeys.length; i++) {
      if (readingController.verseKeys[i].value == 1) {
        headerIndex = i;
        break;
      }
    }

    int totalItemsBeforeFooter =
        verses.length + (headerIndex != -1 ? 1 : 0); // Verses and header
// Divider and SizedBox
    if (_isLoading) {
// For loading indicator
    }

    if (index == headerIndex && headerIndex != -1) {
      // Return header
      return buildHeader();
    } else if (index >= totalItemsBeforeFooter) {
      // Footer items
      int footerIndex = index - totalItemsBeforeFooter;
      if (footerIndex == 0) {
        // Divider
        return const Divider(
          color: Colors.grey,
          thickness: 2,
          endIndent: 20,
          indent: 20,
        );
      } else if (footerIndex == 1) {
        // SizedBox(height: 50)
        return const SizedBox(height: 50);
      } else if (_isLoading && footerIndex == 2) {
        // Loading indicator
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      // Verse
      int verseIndex = index;
      if (headerIndex != -1 && index > headerIndex) {
        verseIndex = index - 1; // Adjust for the header
      }
      if (verseIndex < verses.length) {
        return KeyedSubtree(
          key: readingController.verseKeys[verseIndex],
          child: Text(
            verses[verseIndex],
            style: settingsController.quranFontStyle.value.copyWith(
              height: 2.5, // Adjust this value for line spacing
            ),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        // Should not reach here
        return const SizedBox.shrink();
      }
    }
  }

  Widget buildHeader() {
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
              double imageSize = settingsController.quranFontSize.value *
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
}

// Custom ScrollBehavior that hides the scrollbar
class NoScrollbarScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Return the child without wrapping it in a Scrollbar
  }
}
