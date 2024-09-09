
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/controllers/quran_controller.dart';

class AyahActionBar extends StatelessWidget {
  final int ayahNumber;
  final String lineId;
  final VoidCallback onPlayPressed;
  final VoidCallback onBookmarkPressed;
  final Function(String) onSharePressed;
  final bool isBookmarked;
  final List<Map<String, dynamic>> lineWords;
  final String translation;

  AyahActionBar({
    Key? key,
    required this.ayahNumber,
    required this.lineId,
    required this.onPlayPressed,
    required this.onBookmarkPressed,
    required this.onSharePressed,
    required this.isBookmarked,
    required this.lineWords,
    required this.translation,
  }) : super(key: key);

  final AudioController audioController = Get.find<AudioController>();
  final QuranController quranController = Get.find<QuranController>();

  void _handlePlayPressed() {
    audioController.showPlayer();
    onPlayPressed();
  }

  void _handleSharePressed() {
    final arabicWords = lineWords.map((word) => word['ArabWord']).join(' ');
    final wordMeanings = lineWords.map((word) => word['MalWord']).join(' ');
    final shareText = 'Surah ${quranController.selectedSurah}, Ayah $ayahNumber\n\n'
        'Arabic: $arabicWords\n\n'
        'Word Meanings: $wordMeanings\n\n'
        'Translation: $translation';
    onSharePressed(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${quranController.selectedSurahId}:$ayahNumber',
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
          _buildSvgIconButton('icons/ShareAyah_Icon.svg', _handleSharePressed),
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
