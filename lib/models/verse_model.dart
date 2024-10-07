import 'package:flutter/material.dart';

class QuranVerse {
  final String verseNumber;
  final String arabicText;
  final GlobalKey key;

  QuranVerse({
    required this.verseNumber,
    required this.arabicText,
  }) : key = GlobalKey(); // Initialize the GlobalKey

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      verseNumber: json['verse_number'].toString(),
      arabicText: json['verse'],
    );
  }
}
