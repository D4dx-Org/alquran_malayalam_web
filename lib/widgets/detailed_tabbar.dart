import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailedTabbar extends StatefulWidget {
  final TabController controller;

  const DetailedTabbar({
    super.key,
    required this.controller,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FloatingTabBarState createState() => _FloatingTabBarState();
}

class _FloatingTabBarState extends State<DetailedTabbar>
    with SingleTickerProviderStateMixin {
  static const selectedColor = Color.fromRGBO(115, 78, 9, 1);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const tabBarColor = Color.fromARGB(255, 243, 244, 246);
    const unselectedTextColor = Colors.black;
    const activeIndicatorColor = Colors.white;

    final tabs = [
      _TabData("Translation", "icons/Translation_Tabbar_Icon.svg"),
      _TabData("Reading", "icons/Reading_Tabbar_Icon.svg"),
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: tabBarColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: widget.controller,
        indicator: BoxDecoration(
          color: activeIndicatorColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(6),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        tabs: tabs
            .asMap()
            .entries
            .map((entry) => _buildTab(entry.value, entry.key))
            .toList(),
        labelColor: selectedColor,
        unselectedLabelColor: unselectedTextColor,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      ),
    );
  }

  Widget _buildTab(_TabData tabData, int index) {
    final isSelected = widget.controller.index == index;
    const unselectedTextColor = Colors.black;

    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            tabData.iconPath,
            colorFilter: ColorFilter.mode(
              isSelected ? selectedColor : Colors.grey,
              BlendMode.srcIn,
            ),
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(
            tabData.text,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabData {
  final String text;
  final String iconPath;

  _TabData(this.text, this.iconPath);
}
