import 'dart:developer';

import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:alquran_web/services/quran_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranSearchController extends GetxController {
  final QuranService quranService = QuranService();
  final QuranComService quranComService = QuranComService();
  final searchQuery = ''.obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isNavigating = false.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  Future<void> navigateToSearchResult(
      BuildContext context, Map<String, dynamic> result) async {
    if (isNavigating.value) return;

    try {
      isNavigating.value = true;
      final quranController = Get.find<QuranController>();

      final int surahId = int.parse(result['SuraNo'].toString());
      final int ayaNumber = int.parse(result['AyaNo'].toString());

      // Ensure data is loaded before navigation
      final bool dataLoaded =
          await quranController.ensureAyaIsLoaded(surahId, ayaNumber);

      if (!dataLoaded) {
        throw Exception('Failed to load required data');
      }

      // Update controllers synchronously
      quranController.updateSelectedSurahId(surahId, ayaNumber);
      // Update reading controller to refresh the surah dropdown
      quranController.readingController.navigateToSpecificSurah(surahId);

      // Wait for state to settle
      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        await Get.toNamed(
          Routes.SURAH_DETAILED,
          arguments: {
            'surahId': surahId,
            'surahName': result['MSuraName'],
            'AyaNumber': ayaNumber,
          },
        );

        // Ensure scroll happens after navigation
        await quranController.scrollToAya(ayaNumber, '1');
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to navigate to the selected verse. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isNavigating.value = false;
    }
  }

  Future<void> handleSearchNavigation(String input) async {
    final pattern = RegExp(r'^(\d+):(\d+)$');
    final match = pattern.firstMatch(input);

    if (match != null && !isNavigating.value) {
      try {
        isNavigating.value = true;
        final surahNumber = int.parse(match.group(1)!);
        final ayaNumber = int.parse(match.group(2)!);

        if (surahNumber < 1 || surahNumber > 114) {
          throw Exception('Invalid surah number');
        }

        final quranController = Get.find<QuranController>();

        // Load data first
        await quranController.ensureAyaIsLoaded(surahNumber, ayaNumber);

        // Then navigate
        final surahName = quranController.getSurahName(surahNumber);
        await Get.toNamed(
          Routes.SURAH_DETAILED,
          arguments: {
            'surahId': surahNumber,
            'surahName': surahName,
            'AyaNumber': ayaNumber,
          },
        );
      } catch (e) {
        debugPrint('Search navigation error: $e');
        Get.snackbar(
          'Error',
          'Invalid verse reference or navigation failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isNavigating.value = false;
      }
    }
  }

  Future<void> performSearch() async {
    if (searchQuery.isEmpty) return;

    isLoading.value = true;
    try {
      if (_containsArabic(searchQuery.value)) {
        // Handle Arabic search using QuranComService
        final arabicResults =
            await quranComService.searchAyas(searchQuery.value);

        // Convert the results to match the expected format for UI
        searchResults.value =
            await Future.wait(arabicResults.map((verse) async {
          // Get surah details to get the name
          final surahNumber = int.parse(verse.verseKey.split(':')[0]);
          final surahDetails =
              await quranComService.getSurahDetails(surahNumber);

          return {
            "SuraNo": surahNumber,
            "AyaNo": int.parse(verse.verseKey.split(':')[1]),
            "MSuraName":
                surahDetails['name'], // Arabic name from QuranComService
            "MalTran": verse.text, // Arabic text
            "LineWords": verse.words
                .map((word) => {
                      "ArabWord": word.text,
                      "MalWord":
                          "", // Empty as we don't have Malayalam translation here
                    })
                .toList(),
          };
        }));
      } else {
        // Handle Malayalam/default search using QuranService
        searchResults.value =
            await quranService.fetchSearchResult(searchQuery.value);
      }
    } catch (e) {
      log('Search error: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String get currentSearchQuery => searchQuery.value;
}
