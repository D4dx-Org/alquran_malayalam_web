import 'package:alquran_web/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  int _currentIndex = 0; // To manage the IndexedStack
  List<Map<String, dynamic>> surahs = [];

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    setState(() {
      _currentIndex = 0; // Show loading spinner
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    surahs = List.generate(
      114,
      (index) {
        // Generate dummy data for Surah
        final surahNumber = index + 1;
        final isMakkiya = (surahNumber % 2 ==
            0); // Example logic: Even numbers are Makkiya, odd are Madani
        return {
          'number': surahNumber,
          'name':
              'Surah $surahNumber', // Replace with actual names if available
          'arabicName': 'سورة',
          'verses':
              '${surahNumber * 2} Ayat', // Example: Number of Ayat is twice the Surah number
          'type': isMakkiya ? 'Makkiya' : 'Madani',
        };
      },
    );

    setState(() {
      _currentIndex = 1; // Show the list view
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int crossAxisCount = 3;

    if (screenWidth < 480) {
      crossAxisCount = 1;
    } else if (screenWidth < 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    // double childAspectRatio;

    // if (screenWidth < 480) {
    //   childAspectRatio = 4; // Taller cards for smaller screens
    // } else if (screenWidth < 800) {
    //   childAspectRatio = 4.5; // Medium-sized cards for medium screens
    // } else if (screenWidth < 1025) {
    //   childAspectRatio = 4.3; // Shorter cards for larger screens
    // } else {
    //   childAspectRatio = 5;
    // }
    double childAspectRatio = screenWidth / screenHeight;

    if (screenWidth < 480) {
      childAspectRatio =
          childAspectRatio * 5; // Taller cards for smaller screens
    } else if (screenWidth < 800) {
      childAspectRatio =
          childAspectRatio * 3; // Medium-sized cards for medium screens
    } else if (screenWidth < 1025) {
      childAspectRatio =
          childAspectRatio * 2; // Shorter cards for larger screens
    } else {
      childAspectRatio = childAspectRatio * 3;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return _buildSurahCard(surah);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio:
                    childAspectRatio, // Maintain the original aspect ratio
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
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
