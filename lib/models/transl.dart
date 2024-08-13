import 'package:alquran_malayalam/models/lineword.dart';

class TranLine {
  static const db_lineid = "line_id";
  static const db_surano = "sura_no";
  static const db_ayano = "aya_no";
  static const db_malaymean = "malay_meaning";
  static const db_malwords = "malwords";
  static const db_arabwords = "arabwords";

  int lineId;
  int suraNo;
  int ayaNo;
  String malTran;
  String arabWords;
  String malWords;

  TranLine({
    required this.lineId,
    required this.suraNo,
    required this.ayaNo,
    this.malTran = '',
    this.arabWords = '',
    this.malWords = '',
  });

  factory TranLine.fromMap(Map<String, dynamic> map) => TranLine(
        lineId: map[db_lineid],
        suraNo: map[db_surano],
        ayaNo: map[db_ayano],
        malTran: map[db_malaymean],
        arabWords: map[db_arabwords],
        malWords: map[db_malwords],
      );
}
