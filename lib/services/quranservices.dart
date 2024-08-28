import 'dart:convert';
import 'package:http/http.dart' as http;

class Quranservices {
  final String baseurl = "http://alquranmalayalam.net/alquran-api/articles/1";
  final String baseurl1 = "http://alquranmalayalam.net/alquran-api/articles/7";

  Future<List<String>> fetchMatter() async {
    final response = await http.get(Uri.parse("$baseurl"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['matter']);
    } else {
      throw Exception('Failed to load matter');
    }
  }

  Future<List<String>> fetchMatter1() async {
    final response = await http.get(Uri.parse("$baseurl1"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['matter1']);
    } else {
      throw Exception('Failed to load matter');
    }
  }
}
