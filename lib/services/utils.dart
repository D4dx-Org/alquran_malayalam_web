import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JuzJsonParser {
  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('json/juz-to-chapter-verse-mappings.json');
    return json.decode(jsonString);
  }
}
