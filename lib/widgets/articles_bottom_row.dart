import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesBottomRow extends StatelessWidget {
  final double scaleFactor;
  final TabController tabController;

  const ArticlesBottomRow(BuildContext context, this.scaleFactor,
      {required this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.symmetric(horizontal: 16.0 * scaleFactor),
            tabs: const [
              Tab(
                text: 'വിവര്‍ത്തകന്‍',
              ),
              Tab(
                text: 'മുഖവുര',
              ),
              Tab(
                text: 'പ്രസാധകകുറിപ്പ്',
              ),
            ],
            labelStyle: GoogleFonts.notoSansMalayalam(
              fontWeight: FontWeight.bold,
              fontSize: 14.0 * scaleFactor,
              color: Colors.white,
            ),
            unselectedLabelStyle: GoogleFonts.notoSansMalayalam(
              fontWeight: FontWeight.normal,
              fontSize: 14.0 * scaleFactor,
              color: const Color.fromRGBO(217, 217, 217, 1),
            ),
          ),
        ),
      ],
    );
  }
}
