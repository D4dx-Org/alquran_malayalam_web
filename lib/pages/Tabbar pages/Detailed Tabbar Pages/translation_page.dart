import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/widgets/ayah_action_bar.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final _quranController = Get.find<QuranController>();
  final _settingsController = Get.find<SettingsController>();
  final _bookmarkController = Get.find<BookmarkController>();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
      _loadMoreAyahLines();
    }
  }

  Future<void> _loadMoreAyahLines() async {
    setState(() => _isLoading = true);
    await _quranController.fetchMoreAyahLines();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Obx(
          () => SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      _quranController.selectedSurah,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      _quranController.selectedSurah,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._quranController.ayahLines.map((ayah) => _buildAyah(ayah)),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAyah(Map<String, dynamic> ayah) {
    int ayahNumber = int.tryParse(ayah['AyaNo']) ?? 0;
    String lineId = ayah['LineId'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AyahActionBar(
                      ayahNumber: ayahNumber,
                      lineId: lineId,
                      onPlayPressed: () {
                        debugPrint("Play button Pressed");
                      },
                      onBookmarkPressed: () {
                        _bookmarkController.toggleBookmark(
                          _quranController.selectedSurahId,
                          ayahNumber,
                          lineId,
                        );
                      },
                      onSharePressed: () {
                        debugPrint("Share button Pressed");
                      },
                      isBookmarked: _bookmarkController.isAyahBookmarked(
                        _quranController.selectedSurahId,
                        ayahNumber,
                        lineId,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            ...(ayah['LineWords'] as List<Map<String, dynamic>>)
                                .reversed
                                .map(
                                  (word) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _buildArabicWord(word['ArabWord']),
                                        _buildTranslation(word['MalWord']),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () => Text(
                        ayah['MalTran'],
                        style: TextStyle(
                          fontSize:
                              _settingsController.translationFontSize.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          color: Color.fromRGBO(230, 230, 230, 1),
          thickness: 1,
          height: 32,
        ),
      ],
    );
  }

  Widget _buildArabicWord(String word) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(230, 230, 230, 1),
        ),
        color: const Color.fromRGBO(249, 249, 249, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () => Text(
          word,
          style: TextStyle(
            fontSize: _settingsController.quranFontSize.value,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTranslation(String translation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Obx(
        () => Text(
          translation,
          style: TextStyle(
            fontSize: _settingsController.translationFontSize.value,
          ),
        ),
      ),
    );
  }
}
