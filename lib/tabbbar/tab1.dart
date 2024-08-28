import 'package:alquran_web/services/alquranservices1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  late Quranservices1 _quranServices1;
  String matter = '';

  @override
  void initState() {
    super.initState();
    _quranServices1 = Quranservices1();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final matter1Data = await _quranServices1.fetchMatter1();
      if (matter1Data is String) {
        matter = matter;
      } else {
        matter = '';
      }
      print('Matter data: $matter');
    } catch (e) {
      print('Error fetching data: $e');
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
                padding: EdgeInsets.all(16.0),
                child: isSmallScreen
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 110,
                            backgroundImage:
                                AssetImage('assets/picture/image.jpg'),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'പ്രൊഫ. വി. മുഹമ്മദ്',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 24.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              matter.isNotEmpty ? matter : '',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 110,
                                  backgroundImage:
                                      AssetImage('assets/picture/image.jpg'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
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
                          Padding(
                            padding: EdgeInsets.only(left: 50, top: 10),
                            child: HtmlWidget(
                              matter.isNotEmpty ? matter : '',
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
