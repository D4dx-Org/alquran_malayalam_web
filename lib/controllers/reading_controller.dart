// import 'package:alquran_web/models/verse_model.dart';
// import 'package:alquran_web/services/quran_com_services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:alquran_web/services/json_utils.dart';

// class ReadingController extends GetxController {
//   final QuranComService _quranComService = QuranComService();
//   final JsonParser _jsonParser = JsonParser();
//   var versesText = ''.obs; // Store the entire text as a single string
//   var currentPage = 1.obs;
//   var currentSurahId = 1.obs;
//   var isLoading = false.obs;

//   // Map to store the page-to-Surah mapping
//   late Map<int, List<int>> pageToSurahMap;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadPageToSurahMapping();
//   }

//   Future<void> _loadPageToSurahMapping() async {
//     pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
//   }

//   Future<void> fetchVerses(int pageNumber) async {
//     isLoading.value = true;

//     try {
//       // Determine the Surah ID based on the current page number
//       currentSurahId.value = _getSurahIdFromPageNumber(pageNumber);

//       // Fetch verses for the current Surah ID and page number
//       final fetchedVerses =
//           await _quranComService.fetchAyahs(pageNumber, currentSurahId.value);
//       versesText.value = _buildContinuousText(fetchedVerses);
//     } catch (e) {
//       debugPrint('Error fetching verses: $e');
//     } finally {
//       isLoading.value = false;
//       print(
//           'Fetching verses for Surah ID: ${currentSurahId.value}, Page: ${currentPage.value}');
//     }
//   }

//   int _getSurahIdFromPageNumber(int pageNumber) {
//     // Use the pageToSurahMap to determine the Surah ID for the given page number
//     final surahNumbers = pageToSurahMap[pageNumber];
//     if (surahNumbers != null && surahNumbers.isNotEmpty) {
//       return surahNumbers.first;
//     }
//     return 1; // Default to Surah 1 if the page number is not found in the map
//   }

//   void nextPage() {
//     currentPage.value++;
//     fetchVerses(currentPage.value);
//   }

//   void previousPage() {
//     if (currentPage.value > 1) {
//       currentPage.value--;
//       fetchVerses(currentPage.value);
//     }
//   }

//   Future<void> nextSurah() async {
//     // Determine the next Surah ID based on the current Surah ID
//     final nextSurahId = _getNextSurahId(currentSurahId.value);
//     if (nextSurahId != null) {
//       currentSurahId.value = nextSurahId;
//       currentPage.value = _getFirstPageForSurah(nextSurahId);
//       await fetchVerses(currentPage.value);
//       print('Current Surah ID: ${currentSurahId.value}');
//     }
//   }

//   Future<void> previousSurah() async {
//     // Determine the previous Surah ID based on the current Surah ID
//     final previousSurahId = _getPreviousSurahId(currentSurahId.value);
//     if (previousSurahId != null) {
//       currentSurahId.value = previousSurahId;
//       currentPage.value = _getFirstPageForSurah(previousSurahId);
//       await fetchVerses(currentPage.value);
//       print('Current Surah ID: ${currentSurahId.value}');
//     }
//   }

//   int? _getNextSurahId(int currentSurahId) {
//     // Iterate through the pageToSurahMap to find the next Surah ID
//     for (final entry in pageToSurahMap.entries) {
//       if (entry.value.contains(currentSurahId)) {
//         final index = entry.value.indexOf(currentSurahId);
//         if (index < entry.value.length - 1) {
//           return entry.value[index + 1];
//         }
//       }
//     }
//     return null; // No next Surah ID found
//   }

//   int? _getPreviousSurahId(int currentSurahId) {
//     // Iterate through the pageToSurahMap to find the previous Surah ID
//     for (final entry in pageToSurahMap.entries) {
//       if (entry.value.contains(currentSurahId)) {
//         final index = entry.value.indexOf(currentSurahId);
//         if (index > 0) {
//           return entry.value[index - 1];
//         }
//       }
//     }
//     return null; // No previous Surah ID found
//   }

//   int _getFirstPageForSurah(int surahId) {
//     // Iterate through the pageToSurahMap to find the first page for the given Surah ID
//     for (final entry in pageToSurahMap.entries) {
//       if (entry.value.contains(surahId)) {
//         return entry.key;
//       }
//     }
//     return 1; // Default to page 1 if the Surah ID is not found
//   }

//   String _buildContinuousText(List<QuranVerse> verses) {
//     return verses.map((verse) {
//       return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(verse.verseNumber.split(':').last)}\uFD3E ';
//     }).join();
//   }

//   String _convertToArabicNumbers(String number) {
//     const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
//     return number
//         .split('')
//         .map((digit) => arabicNumbers[int.parse(digit)])
//         .join();
//   }
// }

import 'package:alquran_web/models/verse_model.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/json_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingController extends GetxController {
  final QuranComService _quranComService = QuranComService();
  final JsonParser _jsonParser = JsonParser();
  var versesText = ''.obs; 
    var versesList = <String>[].obs; 
  var currentPage = 1.obs;
  var currentSurahId = 1.obs;
  var isLoading = false.obs;
  late Map<int, List<int>> pageToSurahMap;

  @override
  void onInit() {
    super.onInit();
    _loadPageToSurahMapping();
  }

  Future<void> _loadPageToSurahMapping() async {
    pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
  }

  Future<void> fetchVerses(int pageNumber) async {
    isLoading.value = true;

    try {
      // Determine the Surah ID based on the current page number
      currentSurahId.value = _getSurahIdFromPageNumber(pageNumber);

      // Fetch verses for the current Surah ID and page number
      final fetchedVerses = await _quranComService.fetchAyahs(pageNumber);
      versesText.value = _buildContinuousText(fetchedVerses);
    } catch (e) {
      debugPrint('Error fetching verses: $e');
    } finally {
      isLoading.value = false;
      print(
          'Fetching verses for Surah ID: ${currentSurahId.value}, Page: ${currentPage.value}');
    }
  }

  int _getSurahIdFromPageNumber(int pageNumber) {
    // Use the pageToSurahMap to determine the Surah ID for the given page number
    final surahNumbers = pageToSurahMap[pageNumber];
    if (surahNumbers != null && surahNumbers.isNotEmpty) {
      return surahNumbers.first;
    }
    return 1; // Default to Surah 1 if the page number is not found in the map
  }

  Future<void> nextPage() async {
    // Logic to go to the next page
    currentPage.value++;
    await fetchVerses(currentPage.value); // Assuming this is an async operation
  }

  Future<void> previousPage() async {
    // Logic to go to the previous page
    if (currentPage.value > 1) {
      currentPage.value--;
      await fetchVerses(
          currentPage.value); // Assuming this is an async operation
    }
  }

  Future<void> nextSurah() async {
    // Determine the next Surah ID based on the current Surah ID
    final nextSurahId = _getNextSurahId(currentSurahId.value);
    if (nextSurahId != null) {
      currentSurahId.value = nextSurahId;
      currentPage.value = _getFirstPageForSurah(nextSurahId);
      await fetchVerses(currentPage.value);
      print('Current Surah ID: ${currentSurahId.value}');
    }
  }

  Future<void> previousSurah() async {
    // Determine the previous Surah ID based on the current Surah ID
    final previousSurahId = _getPreviousSurahId(currentSurahId.value);
    if (previousSurahId != null) {
      currentSurahId.value = previousSurahId;
      currentPage.value = _getFirstPageForSurah(previousSurahId);
      await fetchVerses(currentPage.value);
      print('Current Surah ID: ${currentSurahId.value}');
    }
  }

  int? _getNextSurahId(int currentSurahId) {
    // Iterate through the pageToSurahMap to find the next Surah ID
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(currentSurahId)) {
        final index = entry.value.indexOf(currentSurahId);
        if (index < entry.value.length - 1) {
          return entry.value[index + 1];
        }
      }
    }
    return null; // No next Surah ID found
  }

  int? _getPreviousSurahId(int currentSurahId) {
    // Iterate through the pageToSurahMap to find the previous Surah ID
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(currentSurahId)) {
        final index = entry.value.indexOf(currentSurahId);
        if (index > 0) {
          return entry.value[index - 1];
        }
      }
    }
    return null; // No previous Surah ID found
  }

  int _getFirstPageForSurah(int surahId) {
    // Iterate through the pageToSurahMap to find the first page for the given Surah ID
    for (final entry in pageToSurahMap.entries) {
      if (entry.value.contains(surahId)) {
        return entry.key;
      }
    }
    return 1; // Default to page 1 if the Surah ID is not found
  }

  String _buildContinuousText(List<QuranVerse> verses) {
    return verses.map((verse) {
      return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(verse.verseNumber.split(':').last)}\uFD3E ';
    }).join();
  }

  String _convertToArabicNumbers(String number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }
}
