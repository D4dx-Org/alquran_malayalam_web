class ContentPiece {
  final String text;
  final bool isBismilla;
  final bool isSurahName;
  final bool isDivider;
  final int? surahId;
  final int? verseId;

  ContentPiece({
    required this.text,
    this.isBismilla = false,
    this.isSurahName = false,
    this.isDivider = false,
    this.surahId,
    this.verseId,
  });
}
