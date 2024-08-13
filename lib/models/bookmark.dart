class Bookmark {
  static const db_bid = "id";
  static const db_suraId = "SuraId";
  static const db_suraName = "SuraName";
  static const db_ayaNo = "AyaNo";

  int bId;
  int suraId;
  int ayaNo;
  String suraName;

  Bookmark({
    required this.bId,
    required this.suraId,
    required this.ayaNo,
    required this.suraName,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) => Bookmark(
        bId: map[db_bid],
        suraId: map[db_suraId],
        ayaNo: map[db_ayaNo],
        suraName: map[db_suraName],
      );
}
