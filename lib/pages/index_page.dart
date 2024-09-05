import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/pages/Tabbar%20pages/Index%20Tabbar%20Pages/surah_list_page.dart';
import 'package:alquran_web/pages/Tabbar%20pages/Index%20Tabbar%20Pages/bookmarks.dart';
import 'package:alquran_web/pages/Tabbar%20pages/Index%20Tabbar%20Pages/juz_list_page.dart';
import 'package:alquran_web/widgets/horizontal_cardview.dart';
import 'package:alquran_web/widgets/index_appbar.dart';
import 'package:alquran_web/widgets/index_floating_tabbar.dart';
import 'package:alquran_web/widgets/navigation_drawer_widget.dart';
import 'package:alquran_web/widgets/search_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _quranController = Get.find<
        QuranController>(); // Assuming you're using Get for dependency injection
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IndexAppbar(),
      body: SelectionArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SearchWidget(
                      width: MediaQuery.of(context).size.width,
                      onChanged: (value) {
                        // Handle search text changes
                      },
                      onClear: () {
                        // Handle clear button press
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
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
