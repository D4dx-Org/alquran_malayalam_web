import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alquran_web/routes/app_pages.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(115, 78, 9, 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Al-Quran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 31,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Handle close button tap
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    if (Get.currentRoute == Routes.HOME) {
                      // Close the drawer if the user is already on the home page
                      Navigator.of(context).pop();
                    } else {
                      Get.toNamed(Routes.HOME);
                    }
                  },
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  title: const Text('About'),
                  onTap: () {
                    if (Get.currentRoute == Routes.ABOUT_US) {
                      // Close the drawer if the user is already on the home page
                      Navigator.of(context).pop();
                    } else {
                      Get.toNamed(Routes.ABOUT_US);
                    }
                  },
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  title: const Text('Contact'),
                  onTap: () {
                    if (Get.currentRoute == Routes.CONTACT_US) {
                      // Close the drawer if the user is already on the home page
                      Navigator.of(context).pop();
                    } else {
                      Get.toNamed(Routes.CONTACT_US);
                    }
                  },
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    if (Get.currentRoute == Routes.PRIVACY) {
                      // Close the drawer if the user is already on the home page
                      Navigator.of(context).pop();
                    } else {
                      Get.toNamed(Routes.PRIVACY);
                    }
                  },
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('icons/Google_Play.svg'),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/Apple_Store.svg'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
