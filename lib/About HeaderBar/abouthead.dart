import 'package:alquran_web/About%20HeaderBar/publishernote.dart';
import 'package:alquran_web/About%20HeaderBar/translator.dart';
import 'package:alquran_web/About%20HeaderBar/mugavura.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(115, 78, 9, 1), // Brown color
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
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
                    tabs: [
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
                      color: Color.fromRGBO(217, 217, 217, 1),
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
            Tab2(),
            Tab3(),
          ],
        ),
      ),
    );
  }
}
