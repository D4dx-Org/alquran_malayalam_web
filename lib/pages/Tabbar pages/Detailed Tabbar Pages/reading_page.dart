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
  final ReadingController readingController = Get.put(ReadingController());
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
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Obx(() {
            return readingController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            children: [
                              _buildHeader(),
                              Text(
                                readingController.versesText.value,
                                style: settingsController.quranFontStyle.value
                                    .copyWith(
                                  height:
                                      2.5, // Adjust this value for line spacing
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 2,
                                endIndent: 20,
                                indent: 20,
                              ),
                              SizedBox(height: 50),
                              if (_isLoading)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                            ],
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
