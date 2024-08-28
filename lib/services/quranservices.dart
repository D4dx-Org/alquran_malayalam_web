// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // class QuranServices {
// //   final String baseurl = "http://alquranmalayalam.net/alquran-api/articles/1";

// //   Future<List<String>> fetchbiodata() async {
// //     final response = await http.get(Uri.parse("$baseurl"));
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return List<String>.from(data.map((item) => item['matter']));
// //     } else {
// //       throw Exception('Failed to load biodata');
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class QuranServices {
//   final String baseUrl = "http://alquranmalayalam.net/alquran-api";

//   Future<List<String>> fetchAbout() async {

//     final translatorresponse = await http.get(Uri.parse("$baseUrl/articles/1"));
//     final mugavuraresponse = await http.get(Uri.parse("$baseUrl/articles/7"));
//     final publishernote = await http.get(Uri.parse("$baseUrl/articles/8"));

//     if (translatorresponse.statusCode == 200 &&
//         mugavuraresponse.statusCode == 200 &&
//         publishernote.statusCode == 200) {
//       final translatordata = jsonDecode(translatorresponse.body);
//       final mugavuradata = jsonDecode(mugavuraresponse.body);
//       final publishernotedata = jsonDecode(publishernote.body);

//       return [
//         translatordata.map((item) => item['matter']),
//         mugavuradata.map((item) => item['matter']),
//         publishernotedata.map((item) => item['matter']),
//       ];
//     } else {
//       throw Exception('Failed to load Publishersbio');
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranServices {
  final String baseUrl = "http://alquranmalayalam.net/alquran-api";
   int ArticleId = 1; // Changed variable name to match the API endpoint

  Future<List<String>> fetchAbout() async {
    final response = await http.get(Uri.parse("$baseUrl/articles/$ArticleId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item['matter'] as String).toList();
    } else {
      throw Exception('Failed to load Publishersbio');
    }
  }
}
