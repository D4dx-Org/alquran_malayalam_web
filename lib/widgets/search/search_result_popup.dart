import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/search_controller.dart';
import 'dart:developer' as developer;

class SearchResultPopup extends StatelessWidget {
  final String searchText;
  final VoidCallback onClose;
  final QuranSearchController searchController =
      Get.find<QuranSearchController>();

  SearchResultPopup({
    super.key,
    required this.searchText,
    required this.onClose,
  }) {
    developer.log('Search result popup created with text: $searchText',
        name: 'SearchResultPopup');
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building search result popup', name: 'SearchResultPopup');

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
                child: Text(
                  'Results for "$searchText"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  developer.log('Close button pressed',
                      name: 'SearchResultPopup');
                  onClose();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Obx(() {
            if (searchController.isLoading.value) {
              developer.log('Search is loading', name: 'SearchResultPopup');
              return const Center(child: CircularProgressIndicator());
            } else if (searchController.searchResults.isEmpty) {
              developer.log('No search results found',
                  name: 'SearchResultPopup');
              return const Center(child: Text('No results found'));
            } else {
              developer.log(
                  'Found ${searchController.searchResults.length} results',
                  name: 'SearchResultPopup');
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
                        developer.log(
                            'Search result tapped: ${result['MSuraName']}, Aya ${result['AyaNo']}',
                            name: 'SearchResultPopup');
                        onClose();
                        await searchController.navigateToSearchResult(
                            Get.context!, result);
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
