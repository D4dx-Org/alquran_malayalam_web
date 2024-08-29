import 'package:alquran_web/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class IndexAppbar extends StatelessWidget implements PreferredSizeWidget {
  const IndexAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate icon sizes based on screen width
    final scaleFactor = (screenWidth / 1440).clamp(0.7, 1.0);
    final iconScaleFactor =
        (screenWidth / 1440).clamp(0.9, 1.2); // Larger scale factor for icons
    final menuIconSize = 24.0 * iconScaleFactor;
    final settingsIconSize = 24.0 * iconScaleFactor;
    final logoSize = 64.0 * scaleFactor;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80 * scaleFactor,
          leadingWidth: 60 * scaleFactor,
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0 * scaleFactor),
            child: IconButton(
              icon: Icon(
                Icons.menu_sharp,
                size: menuIconSize,
                color: const Color.fromRGBO(130, 130, 130, 1),
                weight: 100,
              ),
              onPressed: () {
                             Scaffold.of(context).openDrawer();

              },
            ),
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
            SizedBox(width: 8 * scaleFactor),
          ],
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/AppBar_Icon.png',
                    height: logoSize,
                    width: logoSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8 * scaleFactor),
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
                                fontSize: 35 * scaleFactor,
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
                              fontSize: 18 * scaleFactor,
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
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
