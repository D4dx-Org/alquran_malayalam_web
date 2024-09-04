import 'package:alquran_web/services/quran_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab3> {
  late Future<List<String>> publishernoteData;

  @override
  void initState() {
    super.initState();
    publishernoteData = _fetchMugavuraData();
  }

  Future<List<String>> _fetchMugavuraData() async {
    final quranServices = QuranService();
    quranServices.ArticleId = 8;
    return await quranServices.fetchAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: publishernoteData,
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
