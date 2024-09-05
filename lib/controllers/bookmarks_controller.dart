import 'package:get/get.dart';  
import 'package:shared_preferences/shared_preferences.dart';  

class BookmarkController extends GetxController {  
  final RxSet<String> _bookmarkedAyahs = <String>{}.obs;  
  late final SharedPreferences _sharedPreferences;  

  BookmarkController({required SharedPreferences sharedPreferences}) {  
    _sharedPreferences = sharedPreferences;  
    _loadBookmarks();  
  }  

  Set<String> get bookmarkedAyahs => _bookmarkedAyahs;  

  bool isAyahBookmarked(int surahId, int ayahNumber, String lineId) {  
    return _bookmarkedAyahs.contains('$surahId:$ayahNumber:$lineId');  
  }  

  void toggleBookmark(int surahId, int ayahNumber, String lineId) {  
    final bookmarkKey = '$surahId:$ayahNumber:$lineId';  
    if (_bookmarkedAyahs.contains(bookmarkKey)) {  
      _bookmarkedAyahs.remove(bookmarkKey);  
    } else {  
      _bookmarkedAyahs.add(bookmarkKey);  
    }  
    _saveBookmarks();  
  }  

  void addBookmark(int surahId, int ayahNumber, String lineId) {  
    final bookmarkKey = '$surahId:$ayahNumber:$lineId';  
    _bookmarkedAyahs.add(bookmarkKey);  
    _saveBookmarks();  
  }  

  void removeBookmark(int surahId, int ayahNumber, String lineId) {  
    final bookmarkKey = '$surahId:$ayahNumber:$lineId';  
    _bookmarkedAyahs.remove(bookmarkKey);  
    _saveBookmarks();  
  }  

  void clearAllBookmarks() {  
    _bookmarkedAyahs.clear();  
    _saveBookmarks();  
  }  

  List<Map<String, dynamic>> getBookmarkedAyahsList() {  
    return _bookmarkedAyahs.map((bookmark) {  
      final parts = bookmark.split(':');  
      if (parts.length == 3) {  
        return {  
          'surahId': int.tryParse(parts[0]) ?? 0,  
          'ayahNumber': int.tryParse(parts[1]) ?? 0,  
          'lineId': parts[2],  
        };  
      } else {  
        // Handle old format or invalid bookmarks  
        return {  
          'surahId': int.tryParse(parts[0]) ?? 0,  
          'ayahNumber': int.tryParse(parts[1]) ?? 0,  
          'lineId': '',  
        };  
      }  
    }).toList();  
  }  

  void _saveBookmarks() {  
    _sharedPreferences.setStringList('bookmarkedAyahs', _bookmarkedAyahs.toList());  
  }  

  void _loadBookmarks() {  
    final savedBookmarks = _sharedPreferences.getStringList('bookmarkedAyahs');  
    if (savedBookmarks != null) {  
      _bookmarkedAyahs.addAll(savedBookmarks);  
    }  
  }  

  @override  
  void onInit() {  
    super.onInit();  
    _loadBookmarks();  
  }  
}