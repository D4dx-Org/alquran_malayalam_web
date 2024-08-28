// import 'package:alquran_web/services/quranservices.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// class Tab2 extends StatefulWidget {
//   const Tab2({Key? key}) : super(key: key);

//   @override
//   _Tab2State createState() => _Tab2State();
// }

// class _Tab2State extends State<Tab2> {
//   late Future<List<String>> mugavuraData;

//   @override
//   void initState() {
//     super.initState();
//     mugavuraData = QuranServices().fetchAbout();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<String>>(
//         future: mugavuraData,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: HtmlWidget(snapshot.data![index]),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:alquran_web/services/quranservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  late Future<List<String>> mugavuraData;

  @override
  void initState() {
    super.initState();
    mugavuraData = _fetchMugavuraData();
  }

  Future<List<String>> _fetchMugavuraData() async {
    final quranServices = QuranServices();
    quranServices.ArticleId = 7; // Set the article ID to 7
    return await quranServices.fetchAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: mugavuraData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(snapshot.data![index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
