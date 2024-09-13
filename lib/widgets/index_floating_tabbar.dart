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
  static const activeIndicatorColor = Color.fromARGB(255, 139, 69, 19);

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
      _TabData("Surat", "icons/Surat_Page_Icon.svg"),
      _TabData("Juz", "icons/Juz_Icon.svg"),
      _TabData("Bookmarks", "icons/Bookmarks_Tabbar_Icon.svg"),
    ];

    double fontSize;
    double iconSize;
    double padding;

    if (screenWidth < 350) {
      fontSize = 10;
      iconSize = 15;
      padding = 0;
    } else if (screenWidth < 450) {
      fontSize = 10;
      iconSize = 15;
      padding = 2;
    } else if (screenWidth < 600) {
      fontSize = 12;
      iconSize = 18;
      padding = 6;
    } else {
      fontSize = 14;
      iconSize = 20;
      padding = 8;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            _buildTab(tabs[i], i, fontSize, iconSize, padding),
          ],
        ],
      ),
    );
  }

  Widget _buildTab(_TabData tabData, int index, double fontSize,
      double iconSize, double padding) {
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
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(115, 78, 9, 1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? activeIndicatorColor : unselectedColor,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add a SizedBox to vertically center the icon
                        SizedBox(
                          height: iconSize,
                          child: SvgPicture.asset(
                            tabData.iconPath,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? selectedColor
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit
                                .scaleDown, // Add this to scale down the icon
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tabData.text,
                          style: TextStyle(
                            color: isSelected
                                ? selectedColor
                                : const Color.fromRGBO(51, 51, 51, 1),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
