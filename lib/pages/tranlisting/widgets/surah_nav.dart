import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';

class SuraNavWidget extends StatelessWidget {
  final IndexController suraSelController = Get.find();

  SuraNavWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_circle_left,
            ),
            color: const Color(0xFFFFFFFF),
            tooltip: 'Prev.Surah',
            iconSize: 28,
            onPressed: (suraSelController.selectedSurah.value!.suraId == 1)
                ? null
                : () {
                    suraSelController.getNavSurah(-1);
                  },
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
          Container(
            width: 230,
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 6),
            margin: const EdgeInsets.only(top: 2.0, bottom: 9.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border:
                  Border.all(color: Colors.black.withOpacity(0.06), width: 0),
            ),
            child: Obx(
              () => DropdownButton<Surah>(
                icon: const Icon(Icons.arrow_drop_down, size: 20),
                iconEnabledColor: const Color(0xFF303030),
                underline: const SizedBox(),
                isDense: true,
                items: suraSelController.surahs
                    .map((surah) => DropdownMenuItem<Surah>(
                          value: surah,
                          child: Text(
                            '${surah.suraId} - ${surah.mSuraName}',
                            style: TextStyle(
                                fontFamily: 'NotoSansMalayalam',
                                //fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                height: 0.5),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  suraSelController.selectSurah(value!);
                },
                isExpanded: false,
                value: suraSelController.selectedSurah.value,
                hint: Text(
                  (suraSelController.selectedSurah != null)
                      ? suraSelController.selectedSurah.value!.mSuraName
                      : 'Select Surah',
                  style: const TextStyle(color: Color(0xFF303030)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_circle_right,
            ),
            color: const Color(0xFFFFFFFF),
            tooltip: 'Next.Surah',
            iconSize: 28,
            onPressed: (suraSelController.selectedSurah.value!.suraId == 114)
                ? null
                : () {
                    suraSelController.getNavSurah(1);
                  },
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
        ]);
  }
}
