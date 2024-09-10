// import 'package:alquran_web/controllers/audio_controller.dart';
// import 'package:alquran_web/controllers/bookmarks_controller.dart';
// import 'package:alquran_web/widgets/audio_player_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:alquran_web/controllers/quran_controller.dart';
// import 'package:alquran_web/controllers/settings_controller.dart';
// import 'package:alquran_web/widgets/ayah_action_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:share_plus/share_plus.dart';

// class TranslationPage extends StatefulWidget {
//   const TranslationPage({super.key});

//   @override
//   State<TranslationPage> createState() => _TranslationPageState();
// }

// class _TranslationPageState extends State<TranslationPage> {
//   final _quranController = Get.find<QuranController>();
//   final _settingsController = Get.find<SettingsController>();
//   final _bookmarkController = Get.find<BookmarkController>();
//   final _audioController = Get.find<AudioController>();
//   final _scrollController = ScrollController();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (!_isLoading &&
//         _scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent) {
//       _loadMoreAyahLines();
//     }
//   }

//   Future<void> _loadMoreAyahLines() async {
//     if (_isEndOfSurah()) return;

//     setState(() => _isLoading = true);
//     await _quranController.fetchMoreAyahLines();
//     setState(() => _isLoading = false);
//   }

//   bool _isEndOfSurah() {
//     return _quranController.ayahLines.isNotEmpty &&
//         _quranController.ayahLines.last['AyaNo'] ==
//             _quranController.selectedSurahAyahCount.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32.0),
//               child: Obx(
//                 () => ListView.builder(
//                   controller: _scrollController,
//                   itemCount: _quranController.ayahLines.length + 3,
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       return _buildHeader();
//                     } else if (index == _quranController.ayahLines.length + 1) {
//                       return _isEndOfSurah()
//                           ? _buildEndOfSurahMessage()
//                           : const SizedBox.shrink();
//                     } else if (index == _quranController.ayahLines.length + 2) {
//                       return _isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : const SizedBox.shrink();
//                     } else {
//                       return _buildAyah(_quranController.ayahLines[index - 1]);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//           AudioPlayerWidget(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Text(
//               _quranController
//                   .getArabicSurahName(_quranController.selectedSurahId),
//               style:
//                   GoogleFonts.amiri(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 _quranController.selectedSurah,
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 '(${_quranController.getSurahMalMean(_quranController.selectedSurahId)})',
//                 style:
//                     const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildAyah(Map<String, dynamic> ayah) {
//     int ayahNumber = int.tryParse(ayah['AyaNo'] ?? '') ?? 0;
//     String lineId = ayah['LineId'] ?? '';
//     String verseKey = "${_quranController.selectedSurahId}:$ayahNumber";

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Obx(() => AyahActionBar(
//                           ayahNumber: ayahNumber,
//                           lineId: lineId,
//                           onPlayPressed: () {
//                             _audioController.playAyah(verseKey);
//                           },
//                           onBookmarkPressed: () {
//                             _bookmarkController.toggleBookmark(
//                               _quranController.selectedSurahId,
//                               ayahNumber,
//                               lineId,
//                             );
//                           },
//                           onSharePressed: (String shareText) {
//                             Share.share(shareText);
//                           },
//                           isBookmarked: _bookmarkController.isAyahBookmarked(
//                             _quranController.selectedSurahId,
//                             ayahNumber,
//                             lineId,
//                           ),
//                           lineWords: ayah['LineWords'],
//                           translation: ayah['MalTran'],
//                         )),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         child: Wrap(
//                           alignment: WrapAlignment.end,
//                           children: [
//                             ...(ayah['LineWords'] as List<Map<String, dynamic>>)
//                                 .reversed
//                                 .map(
//                                   (word) => Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         _buildArabicWord(word['ArabWord']),
//                                         _buildTranslation(word['MalWord']),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Obx(
//                       () => Text(
//                         ayah['MalTran'],
//                         style: TextStyle(
//                           fontSize:
//                               _settingsController.translationFontSize.value,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const Divider(
//           color: Color.fromRGBO(230, 230, 230, 1),
//           thickness: 1,
//           height: 32,
//         ),
//       ],
//     );
//   }

//   Widget _buildArabicWord(String word) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color.fromRGBO(230, 230, 230, 1),
//         ),
//         color: const Color.fromRGBO(249, 249, 249, 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Obx(
//         () => Text(
//           word,
//           style: GoogleFonts.amiri(
//             fontSize: _settingsController.quranFontSize.value,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTranslation(String translation) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Obx(
//         () => Text(
//           translation,
//           style: TextStyle(
//             fontSize: _settingsController.translationFontSize.value,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEndOfSurahMessage() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: Center(
//         child: Text(
//           "End of Surah",
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.normal,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/bookmarks_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/settings_controller.dart';
import 'package:alquran_web/widgets/audio_player_widget.dart';
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
  final _audioController = Get.find<AudioController>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Obx(
                () => ListView.builder(
                  controller: _scrollController,
                  itemCount: _quranController.ayahLines.length + 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader();
                    } else if (index == _quranController.ayahLines.length + 1) {
                      return _isEndOfSurah()
                          ? _buildEndOfSurahMessage()
                          : const SizedBox.shrink();
                    } else if (index == _quranController.ayahLines.length + 2) {
                      return _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    } else {
                      return _buildAyah(_quranController.ayahLines[index - 1]);
                    }
                  },
                ),
              ),
            ),
          ),
          AudioPlayerWidget(),
        ],
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
                  .getArabicSurahName(_quranController.selectedSurahId),
              style: _settingsController.quranFontStyle.value,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _quranController.selectedSurah,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                '(${_quranController.getSurahMalMean(_quranController.selectedSurahId)})',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAyah(Map<String, dynamic> ayah) {
    int ayahNumber = int.tryParse(ayah['AyaNo'] ?? '') ?? 0;
    String lineId = ayah['LineId'] ?? '';
    String verseKey = "${_quranController.selectedSurahId}:$ayahNumber";

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
                                        horizontal: 4.0),
                                    child: _buildArabicWord(
                                        word['ArabWord'], word['MalWord']),
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
          color: Color.fromRGBO(194, 194, 194, 1),
          thickness: 2,
          height: 32,
        ),
      ],
    );
  }

  Widget _buildArabicWord(String arabicWord, String translation) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            () => Text(
              arabicWord,
              style: _settingsController.quranFontStyle.value,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
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

  Widget _buildEndOfSurahMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          "End of Surah",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
