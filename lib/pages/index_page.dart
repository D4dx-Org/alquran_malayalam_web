import 'package:alquran_web/pages/Tabbar pages/surah_list_page.dart';
import 'package:alquran_web/pages/Tabbar%20pages/bookmarks.dart';
import 'package:alquran_web/pages/Tabbar%20pages/juz_list_page.dart';
import 'package:alquran_web/widgets/horizontal_cardview.dart';
import 'package:alquran_web/widgets/index_appbar.dart';
import 'package:alquran_web/widgets/index_floating_tabbar.dart';
import 'package:alquran_web/widgets/navigation_drawer_widget.dart';
import 'package:alquran_web/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
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
      appBar: const IndexAppbar(),
      body: NestedScrollView(
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
                  const HorizontalCardWidget(),
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
          children: [
            const SurahListPage(),
            JuzListPage(),
            const BookmarksPage(),
          ],
        ),
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
