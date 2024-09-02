
import 'package:alquran_web/widgets/detailed_appbar.dart';
import 'package:flutter/material.dart';
import '../Tabbar pages/Articles Tabbar Pages/muguvara.dart';
import '../Tabbar pages/Articles Tabbar Pages/publishersdata.dart';
import '../Tabbar pages/Articles Tabbar Pages/translator.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailedAppbar(
        currentPage: AppPage.articles,
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Tab1(),
          Tab2(),
          Tab3(),
        ],
      ),
    );
  }
}
