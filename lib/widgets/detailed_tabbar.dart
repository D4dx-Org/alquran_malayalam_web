
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailedTabbar extends StatefulWidget {
  final TabController controller;
  final ScrollController scrollController;

  const DetailedTabbar({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FloatingTabBarState createState() => _FloatingTabBarState();
}

class _FloatingTabBarState extends State<DetailedTabbar> with SingleTickerProviderStateMixin {
  static const selectedColor = Color.fromARGB(255, 27, 147, 176);
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isMinimized = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.offset > 20 && !_isMinimized) {
      _animationController.forward();
      setState(() => _isMinimized = true);
    } else if (widget.scrollController.offset <= 20 && _isMinimized) {
      _animationController.reverse();
      setState(() => _isMinimized = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tabBarColor = Color.fromARGB(255, 243, 244, 246);
    const unselectedTextColor = Colors.black;
    const activeIndicatorColor = Colors.white;

    final tabs = [
      _TabData("Translation", "assets/icons/Translation_Tabbar_Icon.svg"),
      _TabData("Reading", "assets/icons/Reading_Tabbar_Icon.svg"),
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 40 + (10 * _animation.value),
          margin: EdgeInsets.symmetric(
            horizontal: 30 + (20 * (1 - _animation.value)),
            vertical: 8 * _animation.value,
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
            indicatorPadding: EdgeInsets.all(6 * _animation.value),
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            tabs: tabs
                .asMap()
                .entries
                .map((entry) => _buildTab(entry.value, entry.key))
                .toList(),
            labelColor: selectedColor,
            unselectedLabelColor: unselectedTextColor,
            labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16 * _animation.value),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16 * _animation.value),
          ),
        );
      },
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
          SizedBox(width: 8 * _animation.value),
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: _animation.value,
              child: Text(
                tabData.text,
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
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
