// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class IndexFloatingTabbar extends StatefulWidget {
//   final TabController controller;
//   final bool isDarkMode;
//   final ScrollController scrollController;

//   const IndexFloatingTabbar({
//     super.key,
//     required this.controller,
//     required this.isDarkMode,
//     required this.scrollController,
//   });

//   @override
//   _IndexFloatingTabbarState createState() => _IndexFloatingTabbarState();
// }

// class _IndexFloatingTabbarState extends State<IndexFloatingTabbar> {
//   static const selectedColor = Colors.white;
//   static const unselectedColor = Colors.grey;
//   static const activeIndicatorColor =
//       Color.fromARGB(255, 139, 69, 19); // brown color

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabBarColor = widget.isDarkMode
//         ? Colors.grey[800]
//         : const Color.fromARGB(255, 243, 244, 246);
//     final screenWidth = MediaQuery.of(context).size.width;

//     final tabs = [
//       _TabData("Surat", "assets/icons/Surat_Page_Icon.svg"),
//       _TabData("Juz", "assets/icons/Juz_Icon.svg"),
//       _TabData("Bookmarks", "assets/icons/Bookmarks_Icon.svg"),
//     ];

//     return Container(
//       width: screenWidth -
//           60, // Adjust the width to be smaller than the screen width
//       height: 60,
//       margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           for (int i = 0; i < tabs.length; i++) ...[
//             if (i > 0) const SizedBox(width: 16),
//             _buildTab(tabs[i], i, screenWidth),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTab(_TabData tabData, int index, double screenWidth) {
//     final isSelected = widget.controller.index == index;
//     final tabWidth = screenWidth >= 600
//         ? 125.0
//         : 100.0; // Adjust the width based on screen size

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: GestureDetector(
//         onTap: () {
//           widget.controller.animateTo(index);
//         },
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(10),
//             splashColor: activeIndicatorColor.withOpacity(0.3),
//             highlightColor: activeIndicatorColor.withOpacity(0.1),
//             onTap: () {
//               widget.controller.animateTo(index);
//             },
//             child: Container(
//               height: 40,
//               width: tabWidth,
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? const Color.fromRGBO(115, 78, 9, 1)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: isSelected ? activeIndicatorColor : unselectedColor,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     tabData.iconPath,
//                     colorFilter: ColorFilter.mode(
//                       isSelected
//                           ? selectedColor
//                           : const Color.fromRGBO(117, 117, 117, 1),
//                       BlendMode.srcIn,
//                     ),
//                     height: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     tabData.text,
//                     style: TextStyle(
//                       color: isSelected
//                           ? selectedColor
//                           : const Color.fromRGBO(51, 51, 51, 1),
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                       fontSize: screenWidth >= 600
//                           ? 14
//                           : 12, // Adjust the font size based on screen size
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TabData {
//   final String text;
//   final String iconPath;

//   _TabData(this.text, this.iconPath);
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IndexFloatingTabbar extends StatefulWidget {
  final TabController controller;
  final bool isDarkMode;
  final ScrollController scrollController;

  const IndexFloatingTabbar({
    super.key,
    required this.controller,
    required this.isDarkMode,
    required this.scrollController,
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
    final tabBarColor = widget.isDarkMode
        ? Colors.grey[800]
        : const Color.fromARGB(255, 243, 244, 246);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final tabs = [
      _TabData("Surat", "assets/icons/Surat_Page_Icon.svg"),
      _TabData("Juz", "assets/icons/Juz_Icon.svg"),
      _TabData("Bookmarks", "assets/icons/Bookmarks_Icon.svg"),
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
          widget.controller.animateTo(index);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: activeIndicatorColor.withOpacity(0.3),
            highlightColor: activeIndicatorColor.withOpacity(0.1),
            onTap: () {
              widget.controller.animateTo(index);
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
