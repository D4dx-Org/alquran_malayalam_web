
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesBottomRow extends StatelessWidget {
  final double scaleFactor;

  const ArticlesBottomRow({required this.scaleFactor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(115, 78, 9, 1),
      height: 50 * scaleFactor,
      child: TabBar(
        isScrollable: true,
        indicatorWeight: 3,
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            child: Text(
              'Tab 1',
              style: GoogleFonts.notoSansMalayalam(
                fontWeight: FontWeight.bold,
                fontSize: 14 * scaleFactor,
                color: Colors.white,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Tab 2',
              style: GoogleFonts.notoSansMalayalam(
                fontWeight: FontWeight.bold,
                fontSize: 14 * scaleFactor,
                color: Colors.white,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Tab 3',
              style: GoogleFonts.notoSansMalayalam(
                fontWeight: FontWeight.bold,
                fontSize: 14 * scaleFactor,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
