import 'package:alquran_web/widgets/appbar/articles_bottom_row.dart';
import 'package:alquran_web/widgets/settings/settings_widget.dart';
import 'package:alquran_web/widgets/appbar/surah_bottom_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum to represent different pages
enum AppPage { detailedsurah, articles }

class DetailedAppbar extends StatefulWidget implements PreferredSizeWidget {
  final AppPage currentPage;
  final TabController tabController;

  const DetailedAppbar({
    super.key,
    required this.currentPage,
    required this.tabController,
  });

  @override
  State<DetailedAppbar> createState() => _DetailedAppbarState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(150); // 80 for top row + 70 for bottom row
}

class _DetailedAppbarState extends State<DetailedAppbar> {
  double getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.05;
    if (screenWidth < 800) return 0.08;
    if (screenWidth < 1440) return 0.1;
    return 0.15 + (screenWidth - 1440) / 10000;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = getScaleFactor(screenWidth);

    final horizontalPadding = screenWidth > 1440
        ? (screenWidth - 1440) * 0.3 + 50
        : screenWidth > 800
            ? 50.0
            : screenWidth * scaleFactor;

    final iconScaleFactor = (screenWidth / 1440).clamp(0.9, 1.2);
    final menuIconSize = 24.0 * iconScaleFactor;
    final settingsIconSize = 24.0 * iconScaleFactor;
    final logoSize = 64.0 * (screenWidth / 1440).clamp(0.7, 1.0);

    return Column(
      children: [
        Container(
          color: const Color.fromRGBO(115, 78, 9, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 80 * (screenWidth / 1440).clamp(0.7, 1.0),
              leadingWidth: 100 * (screenWidth / 1440).clamp(0.7, 1.0),
              leading: IconButton(
                icon: Icon(
                  Icons.menu_sharp,
                  size: menuIconSize,
                  color: Colors.white,
                  weight: 100,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    "icons/Settings_Icon.svg",
                    height: settingsIconSize,
                    width: settingsIconSize,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsWidget();
                      },
                    );
                  },
                ),
              ],
              title: LayoutBuilder(
                builder: (context, constraints) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Get.offAllNamed('/home');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/AppBar_Icon.png',
                              height: logoSize,
                              width: logoSize,
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                                width:
                                    8 * (screenWidth / 1440).clamp(0.7, 1.0)),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "അല്‍-ഖുര്‍ആന്‍",
                                      style: GoogleFonts.anekMalayalam(
                                        fontSize: 35 *
                                            (screenWidth / 1440)
                                                .clamp(0.7, 1.0),
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "വാക്കര്‍ത്ഥത്തോടുകൂടിയ പരിഭാഷ",
                                      style: GoogleFonts.anekMalayalam(
                                        color: Colors.white,
                                        fontSize: 18 *
                                            (screenWidth / 1440)
                                                .clamp(0.7, 1.0),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              centerTitle: true,
            ),
          ),
        ),
        Container(
          color: const Color.fromRGBO(115, 78, 9, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8 * (screenWidth / 1440).clamp(0.7, 1.0)),
            child: _buildBottomRow(context, screenWidth, widget.tabController),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(
      BuildContext context, double screenWidth, TabController tabController) {
    final scaleFactor = (screenWidth / 1440).clamp(0.7, 1.0);
    switch (widget.currentPage) {
      case AppPage.detailedsurah:
        return SurahBottomRow(scaleFactor, tabController: tabController);
      case AppPage.articles:
        return ArticlesBottomRow(context, scaleFactor,
            tabController: tabController);
      }
  }
}
