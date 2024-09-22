import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonParser {
  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('json/juz-to-chapter-verse-mappings.json');
    return json.decode(jsonString);
  }

  Future<Map<int, List<int>>> parseJsonData() async {
    final jsonData = await loadJsonData();
    final parsedData = <int, List<int>>{};

    jsonData.forEach((key, value) {
      final pageNumber = int.parse(key);
      final SurahNumber =
          (value as List<dynamic>).map((item) => int.parse(item)).toList();
      parsedData[pageNumber] = SurahNumber;
    });

    return parsedData;
  }

  Future<Map<String, dynamic>> loadPageToChapterJsonData() async {
    final jsonString =
        await rootBundle.loadString('json/juz-to-chapter-verse-mappings.json');
    return json.decode(jsonString);
  }
}
