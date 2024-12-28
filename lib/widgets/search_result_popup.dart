import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/search_controller.dart';

class SearchResultPopup extends StatelessWidget {
  final VoidCallback onClose;

  const SearchResultPopup({
    super.key,
    required this.onClose,
    required String searchText,
  });

  // Function to check if text contains Arabic characters
  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final QuranSearchController searchController =
        Get.find<QuranSearchController>();
    Get.find<QuranController>();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      height: 300,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                      'Results for "${searchController.currentSearchQuery}"',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Obx(() {
            if (searchController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (searchController.searchResults.isEmpty) {
              return const Center(child: Text('No results found'));
            } else {
              return Expanded(
                child: ListView.separated(
                  itemCount: searchController.searchResults.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final result = searchController.searchResults[index];
                    final bool isArabicText =
                        _containsArabic(result['MalTran']);

                    return ListTile(
                      title: Text(
                        ' ${result['MSuraName']}, ആയ ${result['AyaNo']}',
                      ),
                      subtitle: Text(
                        result['MalTran'],
                        style: TextStyle(
                          fontFamily: isArabicText
                              ? 'Uthmanic_Script'
                              : 'NotoSansMalayalam',
                          fontSize: isArabicText ? 24 : null,
                          height: isArabicText ? 2.0 : null,
                        ),
                        textDirection: isArabicText
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        textAlign:
                            isArabicText ? TextAlign.right : TextAlign.left,
                      ),
                      onTap: () async {
                        // Use the new navigation method
                        await searchController.navigateToSearchResult(
                            context, result);
                      },
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
