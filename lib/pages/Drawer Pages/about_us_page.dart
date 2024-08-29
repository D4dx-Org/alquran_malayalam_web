import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Tabbar pages/Articles Tabbar Pages/muguvara.dart';
import '../Tabbar pages/Articles Tabbar Pages/publishersdata.dart';
import '../Tabbar pages/Articles Tabbar Pages/translator.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(115, 78, 9, 1), // Brown color
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 768;
                final horizontalPadding = isSmallScreen ? 8.0 : 16.0;
                final fontSize = isSmallScreen ? 12.0 : 14.0;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable:
                        !isSmallScreen, // Allow tabs to be scrollable on larger screens
                    indicatorWeight: 3, // Thicker indicator line
                    indicatorColor: Colors.white, // White indicator
                    indicatorSize: TabBarIndicatorSize
                        .label, // Indicator size matches label
                    labelPadding: EdgeInsets.symmetric(
                        horizontal:
                            horizontalPadding), // Adjust padding for small screens
                    tabs: const [
                      Tab(
                        text: 'വിവര്‍ത്തകന്‍',
                      ),
                      Tab(text: 'മുഖവുര'),
                      Tab(text: 'പ്രസാധകകുറിപ്പ്'),
                    ],
                    labelStyle: GoogleFonts.notoSansMalayalam(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize, // Adjust font size for small screens
                      color: Colors.white,
                    ),
                    unselectedLabelStyle: GoogleFonts.notoSansMalayalam(
                      fontWeight: FontWeight.normal,
                      fontSize: fontSize, // Adjust font size for small screens
                      color: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Tab1(),
            const Tab2(),
            const Tab3(),
          ],
        ),
      ),
    );
  }
}
