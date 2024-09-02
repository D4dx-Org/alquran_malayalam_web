import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AyahActionBar extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;

  const AyahActionBar({
    super.key,
    required this.onPlayPressed,
    required this.onBookmarkPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final _quranController = Get.find<QuranController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_quranController.selectedSurahId} : ${_quranController.selectedAyahNumber}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          _buildIconButton('icons/PlayAyah_Icon.svg', onPlayPressed),
          const SizedBox(width: 12),
          _buildIconButton('icons/SaveAsBookmark_Icon.svg', onBookmarkPressed),
          const SizedBox(width: 12),
          _buildIconButton('icons/ShareAyah_Icon.svg', onSharePressed),
        ],
      ),
    );
  }

  Widget _buildIconButton(String assetName, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        assetName,
        height: 14,
        width: 14,
        // ignore: deprecated_member_use
        color: const Color.fromRGBO(115, 78, 9, 1),
      ),
    );
  }
}
