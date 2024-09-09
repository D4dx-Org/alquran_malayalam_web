import 'package:alquran_web/controllers/audio_controller.dart';
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
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: () {
                // Implement settings logic
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.grey),
              onPressed: () {
                // Implement previous verse logic
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
                // Implement next verse logic
              },
            ),
            Expanded(
              child: Obx(() => LinearProgressIndicator(
                    value: audioController.position.value.inSeconds /
                        (audioController.duration.value.inSeconds == 0
                            ? 1
                            : audioController.duration.value.inSeconds),
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
                  )),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                audioController.hidePlayer;
              },
            ),
          ],
        ),
      );
    });
  }
}
