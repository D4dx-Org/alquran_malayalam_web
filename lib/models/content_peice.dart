class ContentPiece {
  final String text;
  final bool isBismilla;
  final bool isSurahName;
  final bool isDivider;
  final int? surahId; // Add surahId as an optional field

  ContentPiece({
    required this.text,
    this.isBismilla = false,
    this.isSurahName = false,
    this.isDivider = false,
    this.surahId, // Initialize surahId
  });
}
