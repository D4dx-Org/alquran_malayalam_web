import 'package:alquran_web/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class IndexAppbar extends StatelessWidget implements PreferredSizeWidget {
  const IndexAppbar({super.key});

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 80 * (screenWidth / 1440).clamp(0.7, 1.0),
        leadingWidth: 100 * (screenWidth / 1440).clamp(0.7, 1.0),
        leading: IconButton(
          icon: Icon(
            Icons.menu_sharp,
            size: menuIconSize,
            color: const Color.fromRGBO(130, 130, 130, 1),
            weight: 300,
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
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed('/home');
                  },
                  child: Image.asset(
                    'images/AppBar_Icon.png',
                    height: logoSize,
                    width: logoSize,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 8 * (screenWidth / 1440).clamp(0.7, 1.0)),
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
                              fontSize:
                                  35 * (screenWidth / 1440).clamp(0.7, 1.0),
                              fontWeight: FontWeight.w900,
                              color: const Color.fromRGBO(115, 78, 9, 1)),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "വാക്കര്‍ത്ഥത്തോടുകൂടിയ പരിഭാഷ",
                          style: GoogleFonts.anekMalayalam(
                            color: const Color.fromRGBO(74, 74, 74, 1),
                            fontSize: 18 * (screenWidth / 1440).clamp(0.7, 1.0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
