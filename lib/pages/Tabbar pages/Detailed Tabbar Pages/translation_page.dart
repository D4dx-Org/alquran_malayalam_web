import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/widgets/ayah_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final _quranController = Get.find<QuranController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAyah(Map<String, dynamic> ayah) {
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
                  Row(
                    children: [
                      AyahActionBar(
                        onPlayPressed: () {
                          debugPrint("Play button Pressed");
                        },
                        onBookmarkPressed: () {
                          debugPrint("Bookmark button Pressed");
                        },
                        onSharePressed: () {
                          debugPrint("Share button Pressed");
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...(ayah['LineWords'] as List<Map<String, dynamic>>)
                          .reversed
                          .map((word) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildArabicWord(word['ArabWord']),
                                  _buildTranslation(word['MalWord']),
                                ],
                              )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      ayah['MalTran'],
                      style: const TextStyle(fontSize: 16),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(230, 230, 230, 1),
          ),
          color: const Color.fromRGBO(249, 249, 249, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          word,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTranslation(String translation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        translation,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
