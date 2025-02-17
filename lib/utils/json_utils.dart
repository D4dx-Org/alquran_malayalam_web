import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonParser {
  Future<Map<int, List<int>>> parsePageToChapterJsonData() async {
    final jsonData = await loadPageToChapterJsonData();
    final parsedData = <int, List<int>>{};

    jsonData.forEach((key, value) {
      final pageNumber = int.parse(key);
      List<int> surahNumbers;

      if (value is List<dynamic>) {
        surahNumbers = value.map((item) => int.parse(item.toString())).toList();
      } else {
        throw Exception('Value is not a list: $value');
      }

      parsedData[pageNumber] = surahNumbers;
    });

    return parsedData;
  }

  Future<Map<String, dynamic>> loadPageToChapterJsonData() async {
    final jsonString =
        await rootBundle.loadString('json/page-to-chapter-mappings.json');
    return json.decode(jsonString);
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('json/juz-to-chapter-verse-mappings.json');
    return json.decode(jsonString);
  }
}
