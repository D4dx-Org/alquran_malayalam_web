import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/settings_controller.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SettingsController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              top: 5,
              right: 5,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
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
    final controller = Get.find<SettingsController>();

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Arabic Font', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            controller.setQuranFontFamily('Uthmani');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                controller.quranFontStyle.value.fontFamily ==
                                        'Uthmanic_Script'
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                          ),
                          child: const Text('Uthmani'),
                        )),
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            controller.setQuranFontFamily('Amiri');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                controller.quranFontStyle.value.fontFamily ==
                                        'Amiri'
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                          ),
                          child: const Text('Amiri'),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Quran Font Size :', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        controller.decreaseQuranFontSize();
                      },
                    ),
                    Obx(() => Text('${controller.quranFontSize.value.toInt()}',
                        style: const TextStyle(fontSize: 18))),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.increaseQuranFontSize();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Translation Font Size :',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        controller.decreaseTranslationFontSize();
                      },
                    ),
                    Obx(() => Text(
                        '${controller.translationFontSize.value.toInt()}',
                        style: const TextStyle(fontSize: 18))),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.increaseTranslationFontSize();
                      },
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Arabic Font', style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Obx(() => ElevatedButton(
                              onPressed: () {
                                controller.setQuranFontFamily('Uthmani');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: controller
                                            .quranFontStyle.value.fontFamily ==
                                        'Uthmanic_Script'
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                              ),
                              child: const Text('Uthmani'),
                            )),
                        const SizedBox(width: 10),
                        Obx(() => ElevatedButton(
                              onPressed: () {
                                controller.setQuranFontFamily('Amiri');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: controller
                                            .quranFontStyle.value.fontFamily ==
                                        'Amiri'
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                              ),
                              child: const Text('Amiri'),
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quran Font Size :',
                        style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            controller.decreaseQuranFontSize();
                          },
                        ),
                        Obx(() => Text(
                            '${controller.quranFontSize.value.toInt()}',
                            style: const TextStyle(fontSize: 18))),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.increaseQuranFontSize();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Translation Font Size :',
                        style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            controller.decreaseTranslationFontSize();
                          },
                        ),
                        Obx(() => Text(
                            '${controller.translationFontSize.value.toInt()}',
                            style: const TextStyle(fontSize: 18))),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.increaseTranslationFontSize();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
