import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'star_widget.dart';

// ignore: must_be_immutable
class SurahCardWidget extends StatelessWidget {
  final Map<String, dynamic> surah;

   SurahCardWidget({super.key, required this.surah});

 List<Map<String, dynamic>> surahs = [];



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: StarNumber(
            number: surah['number'],
          ),
          title: Text(
            surah['name'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              SvgPicture.asset(
                surah['type'] == 'Makkiya'
                    ? "icons/Makiyyah_Icon.svg"
                    : "icons/Madaniyya_Icon.svg",
                height: 11, // Adjust size as needed
                width: 9,
              ),
              const SizedBox(width: 8),
              Text(
                surah['verses'],
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
            ],
          ),
          trailing: Text(
            surah['arabicName'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
