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

  bool isAyahBookmarked(int surahId, int ayahNumber) {  
    return _bookmarkedAyahs.contains('$surahId:$ayahNumber');  
  }  

  void toggleBookmark(int surahId, int ayahNumber) {  
    final bookmarkKey = '$surahId:$ayahNumber';  
    if (_bookmarkedAyahs.contains(bookmarkKey)) {  
      _bookmarkedAyahs.remove(bookmarkKey);  
    } else {  
      _bookmarkedAyahs.add(bookmarkKey);  
    }  
    _saveBookmarks();  
  }  

  void addBookmark(int surahId, int ayahNumber) {  
    final bookmarkKey = '$surahId:$ayahNumber';  
    _bookmarkedAyahs.add(bookmarkKey);  
    _saveBookmarks();  
  }  

  void removeBookmark(int surahId, int ayahNumber) {  
    final bookmarkKey = '$surahId:$ayahNumber';  
    _bookmarkedAyahs.remove(bookmarkKey);  
    _saveBookmarks();  
  }  

  void clearAllBookmarks() {  
    _bookmarkedAyahs.clear();  
    _saveBookmarks();  
  }  

  List<Map<String, int>> getBookmarkedAyahsList() {  
    return _bookmarkedAyahs.map((bookmark) {  
      final parts = bookmark.split(':');  
      return {  
        'surahId': int.parse(parts[0]),  
        'ayahNumber': int.parse(parts[1]),  
      };  
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