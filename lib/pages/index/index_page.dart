import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';
import 'package:alquran_malayalam/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/widgets/drawer.dart';

class IndexPage extends StatelessWidget {
  List<Surah> surahs = [];
  final IndexController controller = Get.put(IndexController());
  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF0C98B5),
          foregroundColor: Color(0xFFFFFFFF),
          title: Text(
            "Al Quran Malayalam",
          ),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  Get.toNamed(AppRoutes.BOOKMARKS, preventDuplicates: true);
                }),
            Obx(() => IconButton(
                  icon: (!controller.isSearching.value)
                      ? const Icon(
                          Icons.search,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    if (!controller.isSearching.value) {
                      controller.isSearching.value = true;
                    } else {
                      controller.isSearching.value = false;
                    }
                  },
                )),
          ],
        ),
        body: GetBuilder<IndexController>(
          init: controller,
          builder: (_) => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Obx(
                      () => (!controller.isSearching.value)
                          ? Container()
                          : SearchWidget(),
                    ),
                    Expanded(
                      child: SurahListing(
                        surahs: controller.surahs,
                      ),
                    )
                  ],
                ),
        ));
  }
}

class SurahListing extends StatelessWidget {
  final List<Surah> surahs;
  final IndexController controller = Get.find();
  SurahListing({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5.0),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return SurahItemView(
          surah: surahs[index],
          index: index,
        );
      },
    );
  }
}

class SurahItemView extends StatelessWidget {
  final Surah surah;
  final index;
  final IndexController controller = Get.find();
  SurahItemView({required this.surah, required this.index});

  @override
  Widget build(BuildContext context) {
    int j = index;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
          color: (j % 2 == 0) ? Colors.white24 : Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 4, right: 1),
            leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: const ExactAssetImage('assets/img/numbg.png'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    surah.suraId.toString(),
                    style: const TextStyle(
                        fontFamily: 'NotoSansMalayalam',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF303030)),
                  ),
                ),
              ),
            ]),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (index == 0)
                        ? const Padding(padding: EdgeInsets.only(top: 8.0))
                        : const Padding(padding: EdgeInsets.only(top: 0.0)),
                    Text(
                      surah.mSuraName,
                      style: const TextStyle(
                          fontFamily: 'NotoSansMalayalam',
                          fontSize: 14.0,
                          color: Color(0xFF303030),
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image(
                            image: (surah.suraType == 'مَكِّيَة')
                                ? const ExactAssetImage('assets/img/macca.png')
                                : const ExactAssetImage(
                                    'assets/img/madina.png'),
                          ),
                          Text(
                            ' . ${surah.totalAyas} Verses',
                            style: const TextStyle(
                              fontFamily: 'NotoSansMalayalam',
                              fontSize: 12.0,
                              height: 1.5,
                              color: Color(0xFF8789A3),
                            ),
                          ),
                        ]),
                  ],
                ),
                Text(
                  surah.aSuraName.replaceAll(' سورة ', ' '),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 20.0,
                      height: 2.0,
                      color: Color(0xFF303030),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: Container(
                // color: Color(0xFFFFFBEE),
                child: IconButton(
                    icon: const Icon(Icons.low_priority),
                    color:
                        Color(0xFF0C98B5), // Color.fromARGB(255, 244, 203, 53),
                    onPressed: () {
                      AyahPickerDialog ayahPickerDialog = AyahPickerDialog(
                          onOkPressed: () async {
                            Get.back();
                            controller.selectSurah(surah);
                            controller.loadSuraDetailPage(surah.suraId,
                                ayaNo: controller.selAyahNo.value);
                          },
                          cSurah: surah);
                      ayahPickerDialog.showAyaNoDialog();
                    })),
          )),
      onTap: () async {
        controller.selectSurah(surah);
        controller.loadSuraDetailPage(surah.suraId);
      },
    );
  }
}
