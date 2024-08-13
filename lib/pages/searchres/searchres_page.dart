import 'package:alquran_malayalam/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_malayalam/helpers/settings_helpers.dart';

import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/pages/searchres/searchres_controller.dart';
import 'package:alquran_malayalam/routes/routes.dart';

class SearchResPage extends StatelessWidget {
  final SearchResController controller = Get.put(SearchResController());

  SearchResPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0C98B5),
          foregroundColor: Color(0xFFFFFFFF),
          title: Text("Search"),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Get.toNamed(AppRoutes.BOOKMARKS, preventDuplicates: true);
                })
          ],
        ),
        body: GetBuilder<SearchResController>(
          init: controller,
          builder: (_) => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SearchResListing(
                  tranLineList: controller.tranLineList,
                ),
        ));
  }
}

class SearchResListing extends StatelessWidget {
  final List<TranLine> tranLineList;

  final SearchResController controller = Get.find();

  SearchResListing({Key? key, required this.tranLineList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchWidget(),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: (controller.tranLineList.isNotEmpty)
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'Search Results:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(48, 48, 48, 1),
                        fontFamily: 'Lato',
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ))
              : Container(),
        ),
        Expanded(
          child: Center(
            child: ListView.builder(
                itemCount:
                    int.parse("${controller.tranLineList.length}") * 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 != 0) {
                    return Divider(
                      height: 10.0,
                      color: const Color(0xFF240F4F),
                    );
                  } else {
                    int j = index ~/ 2;
                    TranLine cTranLine = controller.tranLineList[j];
                    return ListTile(
                      title: _viewTranLinewidget(cTranLine, j),
                      trailing: IconButton(
                        icon: const Icon(Icons.link),
                        color: Color(0xFF0C98B5),
                        onPressed: () => controller.showSuraTranLines(
                            cTranLine.suraNo, cTranLine.ayaNo),
                      ),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }

  _viewTranLinewidget(TranLine inTranLine, int index) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5.0),
          alignment: Alignment.topLeft,
          child: GestureDetector(
            child: Text(
              inTranLine.suraNo.toString() + ':' + inTranLine.malTran,
              style: TextStyle(
                fontFamily: 'NotoSansMalayalam',
                fontSize: controller.fontSizeMalayalam.value,
                color: const Color(0xFF240F4F),
                // fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
            ),
            onTap: () => controller.showSuraTranLines(
                inTranLine.suraNo, inTranLine.ayaNo),
          ),
        )
      ],
    );
  }
}
