class SearchResult {
  final String verseKey;
  final int verseId;
  final String text;
  final List<Word> words;

  SearchResult({
    required this.verseKey,
    required this.verseId,
    required this.text,
    required this.words,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      verseKey: json['verse_key'],
      verseId: json['verse_id'],
      text: json['text'],
      words:
          (json['words'] as List).map((word) => Word.fromJson(word)).toList(),
    );
  }
}

class Word {
  final String charType;
  final String text;
  final bool? highlight;

  Word({
    required this.charType,
    required this.text,
    this.highlight,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      charType: json['char_type'],
      text: json['text'],
      highlight: json['highlight'],
    );
  }
}
