import 'package:alquran_web/widgets/appbar/detailed_appbar.dart';
import 'package:alquran_web/pages/Drawer%20Pages/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import '../articles/introduction_page.dart';
import '../articles/publishers_data_page.dart';
import '../articles/translator_page.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
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
          TranslatorPage(),
          IntroductionPage(),
          PublishersDataPage(),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
