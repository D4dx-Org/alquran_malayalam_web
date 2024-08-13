import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/pages/tranlisting/widgets/row_buttons.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/tranlisting/tranlisting_controller.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/tranlisting/widgets/surah_title.dart';

class TranListingPage extends StatelessWidget {
  List<Surah> surahs = [];
  final TranListingController controller = Get.put(TranListingController());

  TranListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0C98B5),
          foregroundColor: Color(0xFFFFFFFF),
          title: Text(
            "Al Quran Malayalam",
          ),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.low_priority),
                color: Color(0xFFFFFFFF),
                onPressed: () {
                  AyahPickerDialog ayahPickerDialog = AyahPickerDialog(
                      onOkPressed: () async {
                        Get.back();
                        controller.loadtranLineList(controller.curSuraId.value,
                            ayaNo: controller.indexController.selAyahNo.value);
                      },
                      cSurah: controller.indexController.selectedSurah.value!);
                  ayahPickerDialog.showAyaNoDialog();
                })
          ],
        ),
        floatingActionButton: Obx(() => AnimatedOpacity(
              duration: Duration(milliseconds: 1000), //show/hide animation
              opacity: !controller.scroll_visibility.value
                  ? 1.0
                  : 0.0, //set obacity to 1 on visible, or hide
              child: FloatingActionButton(
                onPressed: () {
                  controller.tranLineListScrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn //scroll type
                      );
                },
                child: Icon(Icons.arrow_upward),
                backgroundColor: Color(0xFF0C98B5),
                mini: true,
              ),
            )),
        body: GetBuilder<TranListingController>(
          init: controller,
          builder: (_) => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : TranListing(tranLines: controller.tranLineList),
        ));
  }
}

class TranListing extends StatelessWidget {
  final List<TranLine> tranLines;
  final TranListingController tranListingController = Get.find();
  TranListing({required this.tranLines, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _tranListingWidget(),
        Visibility(
            visible: !tranListingController.scroll_visibility.value,
            child: Positioned(
              left: Get.width / 2 - 65,
              top: 0.0,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.only(left: 5, top: 5),
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors
                              .transparent), //color is transparent so that it does not blend with the actual color specified
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                      color: Color.fromARGB(123, 236, 236,
                          236) // Specifies the background color and the opacity
                      ),
                  child: Text(tranListingController.selSurah.aSuraName,
                      style: TextStyle(
                          fontFamily: 'AmiriQuran',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Color(0xFF0C98B5))),
                )
              ]),
            )),
      ],
    );
  }

  Widget _tranListingWidget() {
    var initial;
    var distance;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Visibility(
              visible: tranListingController.scroll_visibility.value,
              child: SuraTitleWidget(),
            ),
            Flexible(
                child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    //   padding: const EdgeInsets.only(top: 5),
                    height: Get.height -
                        (tranListingController.scroll_visibility.value
                            ? 144
                            : 93),
                    width: double.maxFinite,
                    child: Container(
                      width: Get.width - 20,
                      height: (Get.height -
                          (tranListingController.scroll_visibility.value
                              ? 200
                              : 240)),
                      //padding: const EdgeInsets.only(top: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: tranLines.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 2,
                          color: Color(0xFF0C98B5),
                        ),
                        controller:
                            tranListingController.tranLineListScrollController,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TranLineView(
                            tranLine: tranLines[index],
                            index: index,
                          );
                        },
                      ),
                    ))
              ],
            )),
          ]),
      onPanStart: (DragStartDetails details) {
        initial = details.globalPosition.dx;
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (initial != null) {
          distance = details.globalPosition.dx - initial;
        }
      },
      onPanEnd: (DragEndDetails details) {
        initial = 0.0;
        if (distance != null && distance > 40) {
          if (!tranListingController.isPanStarted) {
            tranListingController.isSuraChanged = true;
            tranListingController.indexController.getNavSurah(-1);
          }
        } else if (distance != null && distance < -40) {
          if (!tranListingController.isPanStarted) {
            tranListingController.isSuraChanged = true;
            tranListingController.indexController.getNavSurah(1);
          }
        }
        //+ve distance signifies a drag from left to right(start to end)
        //-ve distance signifies a drag from right to left(end to start)
      },
    );
  }
}

class TranLineView extends StatelessWidget {
  final TranLine tranLine;
  final index;
  final TranListingController controller = Get.find();
  RxBool isSelected = false.obs;
  TranLineView({required this.tranLine, required this.index});

  @override
  Widget build(BuildContext context) {
    int j = index;
    return controller.wrapScrollTag(
      index: j,
      child: ListTile(
          contentPadding: const EdgeInsets.only(left: 1, right: 1, bottom: 8),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  alignment: Alignment.topRight,
                  child: _viewTranLineWidget(tranLine, j)),
            ],
          ),
          onTap: (() => isSelected.value = !isSelected.value)),
    );
  }

  _viewTranLineWidget(TranLine inTranLine, int index) {
    List<String> arabWords = inTranLine.arabWords.split("#");
    List<String> malWords = inTranLine.malWords.split("#");
    bool malWordNull = (inTranLine.malWords == "");
    return Column(
      children: <Widget>[
        (index == 0 &&
                inTranLine.ayaNo == 1 &&
                inTranLine.suraNo != 1 &&
                inTranLine.suraNo != 9)
            ? _loadBismi()
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        (malWordNull)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Flexible(
                      //constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                      child: Text(
                        inTranLine.malTran,
                        style: TextStyle(
                          fontFamily: 'NotoSansMalayalam',
                          fontSize: controller.fontSizeMalayalam.value,
                          color: const Color(0xFF240F4F),
                          // fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    wordChip(arabWords[0], ''),
                  ])
            : Container(
                alignment: Alignment.topRight,
                child: Wrap(
                  spacing: 3.0, // gap between adjacent chips
                  runSpacing: 3.0, // gap between lines
                  textDirection: TextDirection.rtl,
                  children: _getWordChips(arabWords, malWords),
                ),
              ),
        Obx(() => isSelected.value ? RowButtonsRow(tranLine) : Container()),
        !(malWordNull)
            ? Container(
                padding: const EdgeInsets.only(top: 5.0),
                alignment: Alignment.topLeft,
                child: Text(
                  inTranLine.malTran,
                  style: TextStyle(
                    fontFamily: 'NotoSansMalayalam',
                    fontSize: controller.fontSizeMalayalam.value,
                    color: const Color(0xFF240F4F),
                    // fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ))
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }

  _loadBismi() {
    const String bismiAText = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
    const String bismiMText =
        'കാരുണ്യവാനും കരുണാവാരിധിയുമായ അല്ലാഹുവിന്റെ നാമത്തില്‍ ';

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 15.0),
        ),
        const Text(bismiAText,
            style: TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 20.0,
                fontWeight: FontWeight.w600)),
                Container(
        padding: const EdgeInsets.only(top: 15.0),
        ),
        const Text(
          bismiMText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'NotoSansMalayalam',
            fontSize: 14.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15.0),
        ),
      ],
    );
  }

  List<Widget> _getWordChips(List<String> arabWords, List<String> malWords) {
    var chipWidgets = <Widget>[];

    for (int i = 0; i < arabWords.length; i++) {
      chipWidgets.add(wordChip(arabWords[i], malWords[i]));
    }
    return chipWidgets;
  }

  wordChip(String arabWord, String malWord) {
    return Chip(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (malWord == "")
              ? Container(
                  constraints: const BoxConstraints(maxWidth: 140.0),
                  child: Text(
                    arabWord,
                    style: TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: controller.fontSizeArabic.value,
                        fontWeight: FontWeight.w600),
                    softWrap: true,
                    maxLines: 2,
                  ))
              : Text(
                  arabWord,
                  style: TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: controller.fontSizeArabic.value,
                      fontWeight: FontWeight.w600),
                ),
          Container(
            padding: const EdgeInsets.only(top:10.0),
            constraints: BoxConstraints(maxWidth: 82.0),
            child: Text(
              malWord,
              style: TextStyle(
                fontFamily: 'NotoSansMalayalam',
                fontSize: controller.fontSizeMalayalam.value - 2,
              ),
              softWrap: true,
              maxLines: 5,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      side:BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}
