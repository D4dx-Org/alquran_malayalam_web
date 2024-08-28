import 'package:alquran_web/services/quranservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  late Quranservices _quranServices;
  String matter1 = '';
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _quranServices = Quranservices();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final matter1Data = await _quranServices.fetchMatter1();
      setState(() {
        if (matter1Data.isNotEmpty) {
          matter1 = matter1Data.join('\n');
          isLoading = false;
          hasError = false;
        } else {
          matter1 = '';
          isLoading = false;
          hasError = false;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : hasError
                    ? const Center(
                        child: Text('Error loading content'),
                      )
                    : matter1.isNotEmpty
                        ? HtmlWidget(matter1)
                        : const Center(
                            child: Text('No content available'),
                          ),
          ),
        ),
      ),
    );
  }
}
