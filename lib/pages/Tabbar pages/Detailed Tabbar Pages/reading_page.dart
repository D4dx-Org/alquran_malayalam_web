import 'package:flutter/material.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Reading Page"),
      ),
    );
  }
}
