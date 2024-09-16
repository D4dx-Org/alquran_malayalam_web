import 'package:alquran_web/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/settings_controller.dart';

class AudioPlayerSettingsPopup extends StatelessWidget {
  const AudioPlayerSettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AudioController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth;
        if (MediaQuery.of(context).size.width > 650) {
          maxWidth = 500; // Set a fixed width for larger screens
        } else {
          maxWidth = MediaQuery.of(context).size.width * 0.8;
        }

        return Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 5,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: contentBox(
                      context, MediaQuery.of(context).size.width < 550),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget contentBox(BuildContext context, bool isSmallScreen) {
    final controller = Get.find<AudioController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isSmallScreen)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Text("Continuous Ayah Play")],
                )
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Text("Continuous Ayah Play"),
                     Obx(() => Checkbox(  
                value: controller.shouldPlayNextAyah.value,  
                onChanged: (value) {  
                  controller.shouldPlayNextAyah.value = value ?? false;  
                },  
              )),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}
