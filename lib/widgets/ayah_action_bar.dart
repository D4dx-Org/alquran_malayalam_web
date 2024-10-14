// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';

class AyaActionBar extends StatelessWidget {
  final int AyaNumber;
  final String lineId;
  final VoidCallback onPlayPressed;
  final VoidCallback onBookmarkPressed;
  final bool isBookmarked;
  final List<Map<String, dynamic>> lineWords;
  final String translation;

  AyaActionBar({
    super.key,
    required this.AyaNumber,
    required this.lineId,
    required this.onPlayPressed,
    required this.onBookmarkPressed,
    required this.isBookmarked,
    required this.lineWords,
    required this.translation,
  });

  final AudioController audioController = Get.find<AudioController>();
  final QuranController quranController = Get.find<QuranController>();

  void _handlePlayPressed() {
    audioController.showPlayer();
    onPlayPressed();
  }

  void _handleSharePressed(BuildContext context) {
    final arabicWords = lineWords.map((word) => word['ArabWord']).join(' ');
    final wordMeanings = lineWords.map((word) => word['MalWord']).join(' ');
    final shareText =
        'Surah ${quranController.selectedSurah}, Aya $AyaNumber\n\n'
        'Arabic: $arabicWords\n\n'
        'Word Meanings: $wordMeanings\n\n'
        'Translation: $translation\n\n'
        'Check it out here: https://alquranmalayalam.net/newsite/#/surah_detailed/quran/${quranController.selectedSurahId}/$AyaNumber';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  Share.share(shareText);
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Copy to Clipboard'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${quranController.selectedSurahId}:$AyaNumber',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF734E09),
            ),
          ),
          const SizedBox(width: 16),
          _buildSvgIconButton('icons/PlayAyah_Icon.svg', _handlePlayPressed),
          const SizedBox(width: 16),
          _buildIconButton(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            onBookmarkPressed,
            isBookmarked,
          ),
          const SizedBox(width: 16),
          _buildSvgIconButton(
              'icons/ShareAyah_Icon.svg', () => _handleSharePressed(context)),
        ],
      ),
    );
  }

  Widget _buildSvgIconButton(String assetName, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        assetName,
        height: 14,
        width: 14,
        colorFilter: const ColorFilter.mode(
          Color(0xFF734E09),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, VoidCallback onPressed, bool isActive) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        size: 18,
        color: const Color(0xFF734E09),
      ),
    );
  }
}
