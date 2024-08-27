import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            height: 500,
            width: 400,
            child: Drawer(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color.fromRGBO(115, 78, 9, 1),
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
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                    title: const Text('Home'),
                    onTap: () {
                      Get.toNamed(Routes.HOME);
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
                      Get.toNamed(Routes.ABOUT_US);
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
                      Get.toNamed(Routes.CONTACT_US);
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
                      Get.toNamed(Routes.PRIVACY);
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('icons/Google_Play.svg'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/Apple_Store.svg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
