class QuranVerse {
  final String verseNumber;
  final String arabicText;

  QuranVerse({
    required this.verseNumber,
    required this.arabicText,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      verseNumber: json['verse_number'].toString(),
      arabicText: json['verse'],
    );
  }
}
