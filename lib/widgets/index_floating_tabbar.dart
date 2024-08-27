import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IndexFloatingTabbar extends StatefulWidget {
  final TabController controller;
  final bool isDarkMode;
  final ValueChanged<int> onTabChanged;

  const IndexFloatingTabbar({
    super.key,
    required this.controller,
    required this.isDarkMode,
    required this.onTabChanged,
  });

  @override
  _IndexFloatingTabbarState createState() => _IndexFloatingTabbarState();
}

class _IndexFloatingTabbarState extends State<IndexFloatingTabbar> {
  static const selectedColor = Colors.white;
  static const unselectedColor = Colors.grey;
  static const activeIndicatorColor =
      Color.fromARGB(255, 139, 69, 19); // brown color

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final tabs = [
      _TabData("Surat", "assets/icons/Surat_Page_Icon.svg"),
      _TabData("Juz", "assets/icons/Juz_Icon.svg"),
      _TabData("Bookmarks", "icons/Bookmarks_Tabbar_Icon.svg"),
    ];

    double tabWidth;
    double fontSize;
    double iconSize;
    double padding;

    if (screenWidth < 350) {
      tabWidth = 80;
      fontSize = 10;
      iconSize = 15;
      padding = 0;
    } else if (screenWidth < 450) {
      // Large Mobile screen size
      tabWidth = 90;
      fontSize = 10;
      iconSize = 15;
      padding = 2;
    } else if (screenWidth < 600) {
      // Tablet screen size
      tabWidth = 100;
      fontSize = 12;
      iconSize = 18;
      padding = 6;
    } else {
      // Desktop screen size
      tabWidth = 125;
      fontSize = 14;
      iconSize = 20;
      padding = 8;
    }

    return Container(
      width:
          screenWidth, // Adjust the width to be smaller than the screen width
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            if (i > 0) SizedBox(width: 4),
            _buildTab(
                tabs[i], i, screenWidth, tabWidth, fontSize, iconSize, padding),
          ],
        ],
      ),
    );
  }

  Widget _buildTab(_TabData tabData, int index, double screenWidth,
      double tabWidth, double fontSize, double iconSize, double padding) {
    final isSelected = widget.controller.index == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: GestureDetector(
        onTap: () {
          widget.onTabChanged(index);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: activeIndicatorColor.withOpacity(0.3),
            highlightColor: activeIndicatorColor.withOpacity(0.1),
            onTap: () {
              widget.onTabChanged(index);
            },
            child: Container(
              height: 40,
              width: tabWidth,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(115, 78, 9, 1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? activeIndicatorColor : unselectedColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    tabData.iconPath,
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? selectedColor
                          : const Color.fromRGBO(117, 117, 117, 1),
                      BlendMode.srcIn,
                    ),
                    height: iconSize,
                  ),
                  SizedBox(width: 8),
                  Text(
                    tabData.text,
                    style: TextStyle(
                      color: isSelected
                          ? selectedColor
                          : const Color.fromRGBO(51, 51, 51, 1),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabData {
  final String text;
  final String iconPath;

  _TabData(this.text, this.iconPath);
}
