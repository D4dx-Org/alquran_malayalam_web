import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:alquran_web/widgets/audio_player_settings_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatelessWidget {
  final AudioController audioController = Get.find<AudioController>();

  AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!audioController.isVisible.value) {
        return const SizedBox.shrink(); // Hide the widget when not visible
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
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
                      builder: (_) => AudioPlayerSettingsPopup(
                   
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.grey),
                  onPressed: () {
                    if (audioController.isPlayingSurah.value) {
                      audioController.playPreviousAyahInSurah();
                    } else {
                      audioController.playPreviousAyah();
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
                      audioController.playNextAyahInSurah();
                    } else {
                      audioController.playNextAyah();
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
                      'Current: ${audioController.currentAyah.value}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    )),
                Obx(() => Text(
                      audioController.isPlayingSurah.value
                          ? 'Playing Surah ${audioController.currentSurahNumber.value}'
                          : 'Single Ayah Mode',
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
      items: [1.0, 1.5, 2.0].map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text('${value}x'),
        );
      }).toList(),
    );
  }
}
