
// import 'package:flutter/material.dart';

// class SearchResultPopup extends StatelessWidget {
//   final String searchText;

//   const SearchResultPopup({Key? key, required this.searchText}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Results for "$searchText"',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListView(
//             shrinkWrap: true,
//             children: [
//               // Replace this with actual search results
//               ListTile(title: Text('Result 1 for $searchText')),
//               ListTile(title: Text('Result 2 for $searchText')),
//               ListTile(title: Text('Result 3 for $searchText')),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SearchResultPopup extends StatelessWidget {
  final String searchText;
  final VoidCallback onClose;

  const SearchResultPopup({
    Key? key,
    required this.searchText,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: [
              // Replace this with actual search results
              ListTile(title: Text('Result 1 for $searchText')),
              ListTile(title: Text('Result 2 for $searchText')),
              ListTile(title: Text('Result 3 for $searchText')),
            ],
          ),
        ],
      ),
    );
  }
}
