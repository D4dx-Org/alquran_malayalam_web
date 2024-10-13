import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 1), () {}); // Delay for 3 seconds
    Get.offAllNamed(Routes.HOME); // Navigate to home and clear the stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/favicon.png', width: 150, height: 150),
            Text(
              "അല്‍-ഖുര്‍ആന്‍",
              style: GoogleFonts.anekMalayalam(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(115, 78, 9, 1)),
            ),
            Text(
              "വാക്കര്‍ത്ഥത്തോടുകൂടിയ പരിഭാഷ",
              style: GoogleFonts.anekMalayalam(
                color: const Color.fromRGBO(74, 74, 74, 1),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
