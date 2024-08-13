import 'dart:async';

import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class AyahPickerDialog {
  final VoidCallback onOkPressed;
  final Surah cSurah;
  final IndexController controller = Get.find();

  AyahPickerDialog({Key? key, required this.onOkPressed, required this.cSurah});
  Future showAyaNoDialog() async {
    if (controller.selAyahNo.value > cSurah.totalAyas) {
      controller.selAyahNo.value = 1;
    }
    await Get.dialog(AlertDialog(
      content: Align(
          heightFactor: 1,
          alignment: Alignment.center,
          child: Container(
              alignment: Alignment.center,
              height: 228,
              margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      offset: Offset(0, -4),
                      blurRadius: 12)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 500.0,
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 236, 235, 235),
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(
                      cSurah.mSuraName,
                      style: TextStyle(
                          fontFamily: 'NotoSansMalayalam',
                          fontSize: 15.0,
                          color: Color(0xFF0C98B5),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(() => NumberPicker(
                        minValue: 1,
                        maxValue: cSurah.totalAyas,
                        step: 1,
                        value: controller.selAyahNo.value,
                        selectedTextStyle: TextStyle(
                            fontFamily: 'NotoSansMalayalam',
                            fontSize: 18.0,
                            color: Color(0xFF0C98B5),
                            fontWeight: FontWeight.bold),
                        onChanged: (value) =>
                            controller.selAyahNo.value = value,
                      )),
                ],
              ))),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      buttonPadding: const EdgeInsets.all(10),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 100,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                color: const Color.fromRGBO(221, 221, 221, 1),
                width: 1,
              ),
            ),
            child: const Center(
                child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSansMalayalam',
                  decoration: TextDecoration.none),
            )),
          ),
        ),
        GestureDetector(
          onTap: () => onOkPressed(),
          child: Container(
            width: 100,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF0C98B5),
            ),
            child: const Center(
                child: Text(
              'View Page',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'NotoSansMalayalam',
                  decoration: TextDecoration.none),
            )),
          ),
        )
      ],
    )).then((value) {
      if (value != null) {
        print(value);
      }
    });
  }
}
