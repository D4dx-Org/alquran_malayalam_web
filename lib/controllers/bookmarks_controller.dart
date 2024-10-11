// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkController extends GetxController {
  final RxSet<String> _bookmarkedAyas = <String>{}.obs;
  late final SharedPreferences _sharedPreferences;

  BookmarkController({required SharedPreferences sharedPreferences}) {
    _sharedPreferences = sharedPreferences;
    _loadBookmarks();
  }

  Set<String> get bookmarkedAyas => _bookmarkedAyas;

  bool isAyaBookmarked(int surahId, int AyaNumber, String lineId) {
    return _bookmarkedAyas.contains('$surahId:$AyaNumber:$lineId');
  }

  void toggleBookmark(int surahId, int AyaNumber, String lineId) {
    final bookmarkKey = '$surahId:$AyaNumber:$lineId';
    if (_bookmarkedAyas.contains(bookmarkKey)) {
      _bookmarkedAyas.remove(bookmarkKey);
    } else {
      _bookmarkedAyas.add(bookmarkKey);
    }
    _saveBookmarks();
  }

  void addBookmark(int surahId, int AyaNumber, String lineId) {
    final bookmarkKey = '$surahId:$AyaNumber:$lineId';
    _bookmarkedAyas.add(bookmarkKey);
    _saveBookmarks();
  }

  void removeBookmark(int surahId, int AyaNumber, String lineId) {
    final bookmarkKey = '$surahId:$AyaNumber:$lineId';
    _bookmarkedAyas.remove(bookmarkKey);
    _saveBookmarks();
  }

  void clearAllBookmarks() {
    _bookmarkedAyas.clear();
    _saveBookmarks();
  }

  List<Map<String, dynamic>> getBookmarkedAyasList() {
    return _bookmarkedAyas.map((bookmark) {
      final parts = bookmark.split(':');
      if (parts.length == 3) {
        return {
          'surahId': int.tryParse(parts[0]) ?? 0,
          'AyaNumber': int.tryParse(parts[1]) ?? 0,
          'lineId': parts[2],
        };
      } else {
        // Handle old format or invalid bookmarks
        return {
          'surahId': int.tryParse(parts[0]) ?? 0,
          'AyaNumber': int.tryParse(parts[1]) ?? 0,
          'lineId': '',
        };
      }
    }).toList();
  }

  void _saveBookmarks() {
    _sharedPreferences.setStringList(
        'bookmarkedAyas', _bookmarkedAyas.toList());
  }

  void _loadBookmarks() {
    final savedBookmarks = _sharedPreferences.getStringList('bookmarkedAyas');
    if (savedBookmarks != null) {
      _bookmarkedAyas.addAll(savedBookmarks);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
  }
}
