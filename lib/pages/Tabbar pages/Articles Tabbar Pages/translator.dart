import 'package:alquran_web/services/quran_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  late QuranService _quranServices;
  List<String>? _translatorsnote;

  @override
  void initState() {
    super.initState();
    _quranServices = QuranService();
    _fetchPublishersBio();
  }

  Future<void> _fetchPublishersBio() async {
    try {
      final translatorsnote = await _quranServices.fetchAbout();
      setState(() {
        _translatorsnote = translatorsnote;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 768;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: isSmallScreen
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 110,
                            backgroundImage:
                                AssetImage('images/Author_Photo.jpg'),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'പ്രൊഫ. വി. മുഹമ്മദ്',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          if (_translatorsnote != null)
                            Align(
                              alignment: Alignment.center,
                              child: HtmlWidget(
                                _translatorsnote?.join('\n') ?? '',
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            )
                          else
                            const Text('Loading...'),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 110,
                                  backgroundImage:
                                      AssetImage('images/Author_Photo.jpg'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    'പ്രൊഫ. വി. മുഹമ്മദ്',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      height: 1.25,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50, top: 10),
                              child: _translatorsnote != null
                                  ? SingleChildScrollView(
                                      child: HtmlWidget(
                                        _translatorsnote?.join('\n') ?? '',
                                        textStyle:
                                            const TextStyle(fontSize: 14),
                                      ),
                                    )
                                  : const Text('Loading...'),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
