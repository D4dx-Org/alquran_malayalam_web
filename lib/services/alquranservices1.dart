import 'dart:convert';
import 'package:http/http.dart' as http;

class Quranservices1 {
  final String baseurl = "http://alquranmalayalam.net/alquran-api/articles/1";

  Future<List<String>> fetchTitle1() async {
    return _fetchData('title1');
  }

  Future<List<String>> fetchMatter1() async {
    return _fetchData('matter1');
  }

  Future<List<String>> _fetchData(String key) async {
    try {
      final response = await http.get(Uri.parse(baseurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Full Response: ${response.body}'); // Print full response for debugging

        if (data is List) {
          // If the root of the response is a list, try to get the first item
          if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
            var item = data[0];
            if (item.containsKey(key)) {
              var value = item[key];
              if (value is String) {
                return [value];
              } else if (value is List) {
                return List<String>.from(value);
              } else {
                print(
                    "'$key' is neither a String nor a List: ${value.runtimeType}");
                return [];
              }
            } else {
              print("'$key' doesn't exist in the response item");
              return [];
            }
          } else {
            print("Response is an empty list or first item is not a Map");
            return [];
          }
        } else if (data is Map<String, dynamic>) {
          // If the root of the response is a map, try to access the key directly
          if (data.containsKey(key)) {
            var value = data[key];
            if (value is String) {
              return [value];
            } else if (value is List) {
              return List<String>.from(value);
            } else {
              print(
                  "'$key' is neither a String nor a List: ${value.runtimeType}");
              return [];
            }
          } else {
            print("'$key' doesn't exist in the response");
            return [];
          }
        } else {
          print("Unexpected response structure");
          return [];
        }
      } else {
        throw Exception('Failed to load $key: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching $key: $e');
      return []; // Return an empty list in case of any error
    }
  }
}
