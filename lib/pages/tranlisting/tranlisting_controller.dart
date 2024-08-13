import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/services/bookmark_services.dart';
import 'package:alquran_malayalam/services/tranlisting_services.dart';
import 'package:flutter/material.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/services/dbservice.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TranListingController extends GetxController {
  DBService dbService = DBService();
  TranListingServices tranListingServices = TranListingServices();
  RxList<TranLine> tranLineList = <TranLine>[].obs;
  bool isLoading = true;
  Rx<bool> scroll_visibility = true.obs;
  Rx<double> fontSizeArabic = SettingsHelpers.instance.getFontSizeArabic!.obs;
  Rx<double> fontSizeMalayalam =
      SettingsHelpers.instance.getFontSizeMalayalam!.obs;
  int curAyaNo = 1;
  late RxInt curSuraId = 0.obs;
  RxInt curPageNo = 1.obs;
  final int _perPage = 7;

  var tranLineListScrollController = AutoScrollController();
  bool isPanStarted = false;
  bool showBackTopBtn = false;
  final IndexController indexController = Get.find();
  late Surah selSurah = indexController.selectedSurah.value!;
  bool isSuraChanged = false;

  final searchEditController = TextEditingController();

  int maxPageNo = 1;
  bool isScrollLoading = false;

  int minScrolledPageNo = 1;
  int maxScrolledPageNo = 1;
  int initialAyahDiff = 0;
  List<TranLine> balSubLineList = [];

  @override
  void onInit() {
    super.onInit();
    loadDB();
    isSuraChanged = false;
    indexController.selectedSurah.listen((surah) {
      if (isSuraChanged) {
        selSurah = surah!;
        isSuraChanged = false;
        curAyaNo = 1;
        curPageNo.value = 1;
        indexController.selAyahNo.value = 1;
        maxPageNo = (surah.totalAyas / _perPage).ceil();
      }
      curSuraId.value = surah!.suraId;
      loadtranLineList(surah.suraId);
      try {
        tranLineListScrollController.jumpTo(
          0.0,
        );
      } catch (e) {
        // print('error caught: $e');
      }
    });

    tranLineListScrollController.addListener(() {
      if (!isLoading &&
          scroll_visibility.value &&
          tranLineListScrollController.position.pixels > 2) {
        scroll_visibility.value = false;
        update();
      } else if (!isLoading &&
          !scroll_visibility.value &&
          tranLineListScrollController.position.pixels <= 2) {
        scroll_visibility.value = true;
        update();
      }
      if (!isScrollLoading &&
          tranLineListScrollController.position.pixels >=
              tranLineListScrollController.position.maxScrollExtent - 10) {
        curPageNo.value = maxScrolledPageNo;
        curAyaNo = (curPageNo.value - 1) * 7 + 1;
        getNavPage(1);
      } else if (!isScrollLoading &&
          tranLineListScrollController.position.pixels <=
              tranLineListScrollController.position.minScrollExtent) {
        curPageNo.value = minScrolledPageNo;
        curAyaNo = (curPageNo.value - 1) * 7 + 1;
        getNavPage(-1);
      }
    });

    update();
  }

  @override
  void onClose() {
    tranLineListScrollController.dispose();
    super.onClose();
  }

  loadDB() async {
    var data = Get.arguments;
    if (data != null) {
      curSuraId.value = data[0];
      await indexController.selectSurah(indexController.getSurah(data[0]));
      maxPageNo = (selSurah.totalAyas / _perPage).ceil();
    }

    await dbService.openDB();
    if (data != null && data.length > 1) {
      curAyaNo = data[1];
      if (curAyaNo > 1) {
        curPageNo.value = (curAyaNo / _perPage).ceil();
        await loadtranLineList(curSuraId.value, ayaNo: curAyaNo);
        return;
      }
    }
    await loadtranLineList(curSuraId.value);
  }

  loadtranLineList(int suraNo, {int ayaNo = 1}) async {
    int indexToScroll = 0;
    isPanStarted = true;
    tranLineList.value = [];
    if (ayaNo >= 1) {
      curPageNo.value = (ayaNo / _perPage).ceil();
      minScrolledPageNo = curPageNo.value;
      curAyaNo = (curPageNo.value - 1) * 7 + 1;
      initialAyahDiff = ayaNo - curAyaNo;
      maxScrolledPageNo = curPageNo.value;
    }
    try {
      isLoading = true;
      List<TranLine> list = await tranListingServices.getTranLines(
          suraNo: suraNo,
          pageNo: curPageNo.value,
          perPage: _perPage,
          inStartAyaNo: curAyaNo);
      if (initialAyahDiff > 0) {
        indexToScroll = list.indexWhere((element) => element.ayaNo == ayaNo);
      }
      tranLineList.addAll(list);

      isLoading = false;
      if (indexToScroll > 0) {
        _scrollToIndex(indexToScroll);
      } else {
        tranLineListScrollController.scrollToIndex(0);
      }
      update();
      isPanStarted = false;
    } catch (e) {
      // print(e);
    }
  }

  loadTranLinesMore(int shift) async {
    int diff = 0;
    if (curPageNo.value == 1 && curAyaNo != 1) {
      diff = curAyaNo - 1;
      curAyaNo = curAyaNo - diff;
    }
    //shift -1 prepend , +1 append
    if (!isScrollLoading) {
      try {
        isScrollLoading = true;
        List<TranLine> list = await tranListingServices.getTranLines(
            suraNo: curSuraId.value,
            pageNo: curPageNo.value,
            perPage: _perPage + diff,
            inStartAyaNo: curAyaNo);

        if (shift == -1) {
          if (balSubLineList.isNotEmpty) {
            tranLineList.insertAll(0, balSubLineList);
            balSubLineList = [];
          }
          tranLineList.insertAll(0, list);
        } else {
          tranLineList.addAll(list);
        }
        if (shift == -1) {
          await tranLineListScrollController.animateTo(
            tranLineListScrollController.position.minScrollExtent + 10,
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
          );
        }
        update();
        isScrollLoading = false;
      } catch (e) {
        isScrollLoading = false;
        // print(e);
      }
    }
  }

  getNavPage(int shift) {
    int cPageNum = curPageNo.value;
    if (shift == -1 && cPageNum > 1 && curAyaNo > 7) {
      cPageNum--;
      curAyaNo = curAyaNo - 7;
      if (minScrolledPageNo > cPageNum) {
        minScrolledPageNo--;
      }
    } else if (shift == 1 && curPageNo < maxPageNo) {
      cPageNum++;
      curAyaNo = curAyaNo + 7;
      if (maxScrolledPageNo < cPageNum) {
        maxScrolledPageNo++;
      }
    }
    if (cPageNum != curPageNo.value) {
      curPageNo.value = cPageNum;
      loadTranLinesMore(shift);
    }
  }

  bookmarkAyahLine(TranLine tranLine) {
    String suraName =
        ' ${tranLine.suraNo}:${tranLine.ayaNo}  ${getSuraName(tranLine.suraNo)}';
    String linePart = tranLine.malTran.substring(
        0, (tranLine.malTran.length < 50) ? tranLine.malTran.length : 50);

    Bookmark tranbk = Bookmark(
      bId: -1,
      suraId: tranLine.suraNo,
      suraName: "$suraName#$linePart", // sura # linepart
      ayaNo: tranLine.ayaNo,
    );
    BookmarksServices bookmarksServices = BookmarksServices();
    bookmarksServices.createBookmark(tranbk);
    Get.snackbar('Verse Bookmarked', 'Bookmark added in Bookmarks page!',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future _scrollToIndex(int cIndex) async {
    await tranLineListScrollController.scrollToIndex(cIndex,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(seconds: 1));
    //tranLineListScrollController.highlight(cIndex);
  }

  wrapScrollTag({int? index, Widget? child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: tranLineListScrollController,
        index: index!,
        highlightColor: Colors.black.withOpacity(0.1),
        child: child,
      );

  String getSuraName(int inSuraId) {
    return Get.find<IndexController>().getSurah(inSuraId).aSuraName;
  }
}
