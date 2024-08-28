import 'package:alquran_web/tabbbar/headbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}
