import 'package:alquran_web/pages/Tabbar%20pages/Detailed%20Tabbar%20Pages/reading_page.dart';
import 'package:alquran_web/pages/Tabbar%20pages/Detailed%20Tabbar%20Pages/translation_page.dart';
import 'package:alquran_web/widgets/detailed_appbar.dart';
import 'package:alquran_web/widgets/detailed_tabbar.dart';
import 'package:alquran_web/widgets/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class DetailedSurahPage extends StatefulWidget {
  const DetailedSurahPage({super.key});

  @override
  State<DetailedSurahPage> createState() => _DetailedSurahPageState();
}

class _DetailedSurahPageState extends State<DetailedSurahPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  TabController get tabController => _tabController;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: DetailedAppbar(
        currentPage: AppPage.detailedsurah,
        tabController: tabController,
      ),
      drawer: const NavigationDrawerWidget(),
      body: Column(
        children: [
          if (screenWidth < 600)
            DetailedTabbar(
              controller: tabController,
            )
          else
            SizedBox(
              width: screenWidth * 0.5,
              child: DetailedTabbar(
                controller: tabController,
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                TranslationPage(),
                ReadingPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
