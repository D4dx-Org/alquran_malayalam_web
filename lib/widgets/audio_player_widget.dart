import 'package:flutter/material.dart';  
import 'package:get/get.dart';  
import 'package:alquran_web/controllers/audio_controller.dart';  

class AudioPlayerWidget extends StatelessWidget {  
  final AudioController audioController = Get.put(AudioController());  

  AudioPlayerWidget({Key? key}) : super(key: key);  

  @override  
  Widget build(BuildContext context) {  
    return Container(  
      padding: const EdgeInsets.all(16),  
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
        children: [  
          Obx(() => Text(  
            'Ayah ${audioController.currentAyah.value}',  
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  
          )),  
          const SizedBox(height: 8),  
          Obx(() => Slider(  
            value: audioController.position.value.inSeconds.toDouble(),  
            max: audioController.duration.value.inSeconds.toDouble(),  
            onChanged: (value) {  
              audioController.seek(Duration(seconds: value.toInt()));  
            },  
          )),  
          Row(  
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
            children: [  
              Obx(() => Text(  
                _formatDuration(audioController.position.value),  
                style: const TextStyle(fontSize: 12),  
              )),  
              Obx(() => Text(  
                _formatDuration(audioController.duration.value),  
                style: const TextStyle(fontSize: 12),  
              )),  
            ],  
          ),  
          const SizedBox(height: 8),  
          Row(  
            mainAxisAlignment: MainAxisAlignment.center,  
            children: [  
              IconButton(  
                icon: const Icon(Icons.skip_previous),  
                onPressed: () {  
                  // Implement previous ayah logic  
                },  
              ),  
              Obx(() => IconButton(  
                icon: Icon(audioController.isPlaying.value  
                    ? Icons.pause  
                    : Icons.play_arrow),  
                onPressed: audioController.togglePlayPause,  
              )),  
              IconButton(  
                icon: const Icon(Icons.skip_next),  
                onPressed: () {  
                  // Implement next ayah logic  
                },  
              ),  
            ],  
          ),  
        ],  
      ),  
    );  
  }  

  String _formatDuration(Duration duration) {  
    String twoDigits(int n) => n.toString().padLeft(2, "0");  
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));  
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));  
    return "$twoDigitMinutes:$twoDigitSeconds";  
  }  
}