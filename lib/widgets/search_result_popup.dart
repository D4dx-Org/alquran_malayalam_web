import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_web/controllers/search_controller.dart'; // Make sure to import the correct path

class SearchResultPopup extends StatelessWidget {
  final VoidCallback onClose;

  const SearchResultPopup({
    super.key,
    required this.onClose,
    required String searchText,
  });

  @override
  Widget build(BuildContext context) {
    final QuranSearchController searchController =
        Get.find<QuranSearchController>();

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
                child: ListView.builder(
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchController.searchResults[index];

                    return ListTile(
                      title: Text(
                          'Surah ${result['MSuraName']}, Ayah ${result['AyaNo']}'),
                      subtitle: Text(result['MalTran']),
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
