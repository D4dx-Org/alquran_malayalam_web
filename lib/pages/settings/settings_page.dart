import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/settings/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0C98B5),
          foregroundColor: Color(0xFFFFFFFF),
          centerTitle: false,
          title: const Text(
            'Settings',
            style: TextStyle(fontSize: 18.0),
          ),
          elevation: 0,
        ),
        body: GetBuilder<SettingsController>(
          init: controller,
          builder: (_) => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SettingsView(),
        ));
  }
}

class SettingsView extends StatelessWidget {
  final SettingsController controller = Get.find();
  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 24, left: 16),
                    child: Text(
                      'FONT SIZE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(170, 170, 170, 1),
                        fontFamily: 'Lato',
                        fontSize: 14,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16),
                    child: TextButton(
                      child: const Text('Reset',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF0C98B5),
                            fontFamily: 'Lato',
                            fontSize: 14,
                          )),
                      onPressed: () {
                        controller.resetFontSize();
                      },
                    )),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                // margin: const EdgeInsets.only(top: 16),

                width: 340,
                height: 280,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Container(
                    width: Get.width - 32,
                    // height: Get.height - 200,
                    //padding: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Column(children: <Widget>[
                      Flexible(
                          child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: <Widget>[
                            _getFontSizeUI(),
                          ])),
                    ]))),
          ])),
        ]);
  }

  Widget _getFontSizeUI() {
    return Container(
      width: 340,
      height: 280,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SliderItemView(labelText: "Arabic"),
          SliderItemView(labelText: "Malayalam"),
        ],
      ),
    );
  }
}

class SliderItemView extends StatelessWidget {
  String labelText;
  final SettingsController controller = Get.find();

  SliderItemView({
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, bottom: 5),
              child: Text(
                labelText,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontFamily: 'Lato',
                  fontSize: 16,
                ),
              )),
          Row(
            children: [
              Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Color.fromRGBO(196, 196, 196, 1),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove,
                    ),
                    color: const Color(0xFF303030),
                    tooltip: 'Decrease',
                    iconSize: 16,
                    onPressed: () {
                      controller.changeValue(labelText, -1);
                    },
                  )),
              Expanded(
                  child: Obx(
                () => Slider(
                  activeColor: const Color(0xFF0C98B5),
                  inactiveColor: const Color(0xFFC4C4C4),
                  thumbColor: const Color(0xFF0C98B5),
                  value: controller.curFontSize(labelText),
                  min: controller
                      .getMinFontSize(labelText), //initialized it to a double
                  max: controller
                      .getMaxFontSize(labelText), //initialized it to a double
                  divisions: 20,
                  label: controller.getFontSize(labelText),
                  onChanged: (double value) {
                    controller.setFontSize(labelText, value);
                  },
                ),
              )),
              Obx(
                () => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(controller.getFontSize(labelText),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xFF0C98B5),
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ))),
              ),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color.fromRGBO(196, 196, 196, 1),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                  ),
                  color: const Color(0xFF303030),
                  tooltip: 'Increase',
                  iconSize: 16,
                  onPressed: () {
                    controller.changeValue(labelText, 1);
                  },
                ),
              )
            ],
          ),
        ]));
  }
}
