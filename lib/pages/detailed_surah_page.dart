import 'package:alquran_web/widgets/detailed_appbar.dart';
import 'package:alquran_web/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class DetailedSurahPage extends StatelessWidget {
  const DetailedSurahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DetailedAppbar(
        currentPage: AppPage.detailedsurah,
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
