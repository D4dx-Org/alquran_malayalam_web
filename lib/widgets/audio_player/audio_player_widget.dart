import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/widgets/audio_player/audio_player_settings_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatelessWidget {
  final AudioController audioController = Get.find<AudioController>();

  AudioPlayerWidget({super.key});

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 + (screenWidth - 1440) / 10000;
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

    return Obx(() {
      if (!audioController.isVisible.value) {
        return const SizedBox.shrink(); // Hide the widget when not visible
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AudioPlayerSettingsPopup(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.grey),
                  onPressed: () {
                    if (audioController.isPlayingSurah.value) {
                      audioController.playPreviousAyaInSurah();
                    } else {
                      audioController.playPreviousAya();
                    }
                  },
                ),
                Obx(() => IconButton(
                      icon: Icon(
                        audioController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.brown,
                      ),
                      onPressed: audioController.togglePlayPause,
                    )),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.grey),
                  onPressed: () {
                    if (audioController.isPlayingSurah.value) {
                      audioController.playNextAyaInSurah();
                    } else {
                      audioController.playNextAya();
                    }
                  },
                ),
                Expanded(
                  child: Obx(() => LinearProgressIndicator(
                        value: audioController.position.value.inSeconds /
                            (audioController.duration.value.inSeconds == 0
                                ? 1
                                : audioController.duration.value.inSeconds),
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.brown),
                      )),
                ),
                _buildSpeedDropdown(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () async {
                    await audioController.hidePlayer();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      'Current: ${audioController.currentAya.value}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    )),
                Obx(() => Text(
                      audioController.isPlayingSurah.value
                          ? 'Playing Surah ${audioController.currentSurahNumber.value}'
                          : 'Single Aya Mode',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    )),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSpeedDropdown() {
    return DropdownButton<double>(
      value: audioController.playbackSpeed.value,
      onChanged: (double? newValue) {
        if (newValue != null) {
          audioController.setPlaybackSpeed(newValue);
        }
      },
      items: [1.0, 1.5].map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text('${value}x'),
        );
      }).toList(),
    );
  }
}
