import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/pages/home_pages/surah_list_page.dart';
import 'package:alquran_web/pages/home_pages/bookmarks.dart';
import 'package:alquran_web/pages/home_pages/juz_list_page.dart';
import 'package:alquran_web/pages/home_pages/widgets/horizontal_cardview.dart';
import 'package:alquran_web/widgets/appbar/index_appbar.dart';
import 'package:alquran_web/widgets/index_tabbar.dart';
import 'package:alquran_web/pages/Drawer%20Pages/navigation_drawer_widget.dart';
import 'package:alquran_web/widgets/search/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late QuranController _quranController;
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _quranController = Get.find<QuranController>();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IndexAppbar(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  SearchWidget(
                    width: MediaQuery.of(context).size.width,
                    onSearch: (searchText) {
                      // Perform search operation here
                    },
                  ),
                  const SizedBox(height: 25),
                  HorizontalCardWidget(quranController: _quranController),
                  const SizedBox(height: 25),
                  IndexFloatingTabbar(
                    controller: _tabController,
                    isDarkMode: false,
                    onTabChanged: (index) {
                      _tabController.animateTo(index);
                    },
                  ),
                  const SizedBox(height: 25)
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            SurahListPage(),
            JuzListPage(),
            BookmarksPage(),
          ],
        ),
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
