import 'package:alquran_web/widgets/settings_widget.dart';  
import 'package:alquran_web/widgets/surah_bottom_row.dart';  
import 'package:flutter/material.dart';  
import 'package:flutter_svg/svg.dart';  
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
      const Size.fromHeight(150); // 80 for top row + 50 for bottom row  
}  

class _DetailedAppbarState extends State<DetailedAppbar> {  
  @override  
  Widget build(BuildContext context) {  
    final screenWidth = MediaQuery.of(context).size.width;  

    // Calculate icon sizes based on screen width  
    final scaleFactor = (screenWidth / 1440).clamp(0.7, 1.0);  
    final iconScaleFactor = (screenWidth / 1440).clamp(0.9, 1.2);  
    final menuIconSize = 24.0 * iconScaleFactor;  
    final settingsIconSize = 24.0 * iconScaleFactor;  
    final logoSize = 64.0 * scaleFactor;  

    return Column(  
      children: [  
        Container(  
          color: const Color.fromRGBO(115, 78, 9, 1),  
          child: Padding(  
            padding: EdgeInsets.symmetric(horizontal: 32.0 * scaleFactor),  
            child: AppBar(  
              backgroundColor: Colors.transparent,  
              toolbarHeight: 80 * scaleFactor,  
              leadingWidth: 60 * scaleFactor,  
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
                        color: Colors.white,  
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
                                  fontSize: 18 * scaleFactor,  
                                  fontWeight: FontWeight.w300,  
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
        ),  
        Container(  
          color: const Color.fromRGBO(115, 78, 9, 1),  
          child: Padding(  
            padding: EdgeInsets.symmetric(  
                horizontal: 32 * scaleFactor, vertical: 8 * scaleFactor),  
            child: _buildBottomRow(context, scaleFactor, widget.tabController),  
          ),  
        ),  
      ],  
    );  
  }  

  Widget _buildBottomRow(BuildContext context, double scaleFactor, TabController tabController) {  
    switch (widget.currentPage) {  
      case AppPage.detailedsurah:  
        return SurahBottomRow(scaleFactor, tabController: tabController);  
      case AppPage.articles:  
        return _buildarticlesBottomRow(context, scaleFactor);  
      default:  
        return SizedBox.shrink();  
    }  
  }  

  Widget _buildarticlesBottomRow(BuildContext context, double scaleFactor) {  
    return Container(  
      color: Colors.brown[100],  
      height: 50 * scaleFactor,  
      child: Padding(  
        padding: EdgeInsets.symmetric(horizontal: 16.0 * scaleFactor),  
        child: TextField(  
          decoration: InputDecoration(  
            hintText: 'Search...',  
            border: InputBorder.none,  
            icon: Icon(Icons.search, size: 24 * scaleFactor),  
          ),  
        ),  
      ),  
    );  
  }  
}