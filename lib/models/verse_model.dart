class QuranVerse {
  final String verseNumber;
  final String arabicText;
  final String translation;

  QuranVerse({
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      verseNumber: json['verse_number'].toString(),
      arabicText: json['verse'],
      translation: json['translation'],
    );
  }
}
