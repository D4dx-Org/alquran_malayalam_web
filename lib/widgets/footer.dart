import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 115, 78, 9),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'COPYRIGHT © 2017.AL-QURAN. ',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PRIVACY);
            },
            child: Text(
              'PRIVACY POLICY',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            ' - DEVELOPED BY D4MEDIA',
            style: TextStyle(
                fontSize: 14, color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }
}
