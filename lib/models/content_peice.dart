class ContentPiece {
  final String text;
  final bool isBismilla;
  final bool isSurahName;
    final bool isDivider; 


  ContentPiece({
    required this.text,
    this.isBismilla = false,
    this.isSurahName = false,
    this.isDivider = false,
  });
}
