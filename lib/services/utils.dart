import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JuzJsonParser {
  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString = await rootBundle
        .loadString('assets/juz-to-chapter-verse-mappings.json');
    return json.decode(jsonString);
  }
}
