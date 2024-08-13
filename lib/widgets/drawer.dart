import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/routes/routes.dart';

class MyDrawer extends StatelessWidget {
  Color iconColor = const Color(0xFF0C98B5); // Color(0xFF303030);
  Color menuColor = const Color(0xFF0C98B5);
  bool isEngSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 20.0,
        child: Column(children: <Widget>[
          Flexible(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 55),
                // padding: const EdgeInsets.only(left: 10, right: 10),
                color: const Color(0xFFF6F6F6),
                width: Get.width * 0.85,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage("assets/img/splashlogo.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Text(''),
                ),
              )),
          Expanded(
              flex: 3,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.home, color: iconColor),
                    title: Text(
                      'Index',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: menuColor),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment, color: iconColor),
                    title: Text(
                      "Preface",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: menuColor),
                    ),
                    onTap: () => _openArticlePage(7),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_pin, color: iconColor),
                    title: Text(
                      "Translator",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: menuColor),
                    ),
                    onTap: () => _openArticlePage(1),
                  ),
                  ListTile(
                    leading: Icon(Icons.comment, color: iconColor),
                    title: Text(
                      "Publisher Note",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: menuColor),
                    ),
                    onTap: () => _openArticlePage(8),
                  ),
                  Divider(color: Colors.black.withOpacity(0.8)),
                  ListTile(
                      leading: Icon(Icons.settings, color: iconColor),
                      title: Text("Settings",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: menuColor)),
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.SETTINGS);
                      }),
                  ListTile(
                      leading: Icon(Icons.contact_phone, color: iconColor),
                      title: Text(
                        "Contact",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: menuColor),
                      ),
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.INFO);
                      }),
                  Divider(color: Colors.black.withOpacity(0.8)),
                  ListTile(
                      //   title: _gotoJuzOrPage,
                      ),
                ],
              )),
        ]));
  }

  _openArticlePage(
    int articleId,
  ) {
    Get.toNamed(AppRoutes.ARTICLE,
        arguments: [articleId], preventDuplicates: false);
  }
}
