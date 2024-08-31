import 'package:alquran_web/widgets/ayah_action_bar.dart';
import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'الفاتحة',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'അൽഫാതിഹ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
            _buildVerse(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerse() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AyahActionBar(
                    onPlayPressed: () {
                      debugPrint("Play button Pressed");
                    },
                    onBookmarkPressed: () {
                      debugPrint("Bookmark button Pressed");
                    },
                    onSharePressed: () {
                      debugPrint("Share button Pressed");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildArabicWord('بِسْمِ'),
                  _buildArabicWord('اللَّهِ'),
                  _buildArabicWord('الرَّحْمَٰنِ'),
                  _buildArabicWord('الرَّحِيمِ'),
                  _buildArabicWord('الرَّحِيمِ'),
                  _buildArabicWord('الرَّحِيمِ'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTranslation('നാമത്തിൽ'),
                  _buildTranslation('അല്ലാഹുവിന്റെ'),
                  _buildTranslation('പരമകാരുണികനായ'),
                  _buildTranslation('ദയാപരനുമായ'),
                  _buildTranslation('ദയാപരനുമായ'),
                  _buildTranslation('ദയാപരനുമായ'),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '1.കാരുണ്യവാനും കരുണാനിധിയുമായ അല്ലാഹുവിന്റെ നാമത്തിൽ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArabicWord(String word) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(230, 230, 230, 1),
        ),
        color: Color.fromRGBO(249, 249, 249, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        word,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTranslation(String translation) {
    return Text(
      translation,
      style: const TextStyle(fontSize: 14),
    );
  }
}
