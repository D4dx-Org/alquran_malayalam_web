// import 'package:get/get.dart';
import 'package:alquran_web/models/verse_model.dart';
import 'package:alquran_web/services/quran_com_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ReadingController extends GetxController {  
  final QuranComService _quranComService = QuranComService();  
  var versesText = ''.obs; // Store the entire text as a single string  
  var currentPage = 1.obs;  
  var isLoading = false.obs;  

  Future<void> fetchVerses(int pageNumber) async {  
    isLoading.value = true;  

    try {  
      final fetchedVerses = await _quranComService.fetchAyahs(pageNumber);  
      versesText.value = _buildContinuousText(fetchedVerses);  
    } catch (e) {  
      debugPrint('Error fetching verses: $e');  
    } finally {  
      isLoading.value = false;  
    }  
  }  

  String _buildContinuousText(List<QuranVerse> verses) {  
    return verses.map((verse) {  
      return '${verse.arabicText} \uFD3F${_convertToArabicNumbers(verse.verseNumber.split(':').last)}\uFD3E ';  
    }).join();  
  }  

  void nextPage() {  
    currentPage.value++;  
    fetchVerses(currentPage.value);  
  }  

  void previousPage() {  
    if (currentPage.value > 1) {  
      currentPage.value--;  
      fetchVerses(currentPage.value);  
    }  
  }  

  String _convertToArabicNumbers(String number) {  
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];  
    return number  
        .split('')  
        .map((digit) => arabicNumbers[int.parse(digit)])  
        .join();  
  }  
}