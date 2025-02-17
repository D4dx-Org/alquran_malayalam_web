import 'package:alquran_web/services/quran_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late Future<List<String>> mugavuraData;

  @override
  void initState() {
    super.initState();
    mugavuraData = _fetchMugavuraData();
  }

  Future<List<String>> _fetchMugavuraData() async {
    final quranServices = QuranService();
    quranServices.ArticleId = 7; // Set the article ID to 7
    return await quranServices.fetchAbout();
  }

  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 + (screenWidth - 1440) / 10000;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Scaffold(
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
      ),
    );
  }
}
