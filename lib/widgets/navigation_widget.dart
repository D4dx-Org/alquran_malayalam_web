import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alquran_web/routes/app_pages.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5,
          left: 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: contentBox(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget contentBox(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(115, 78, 9, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
