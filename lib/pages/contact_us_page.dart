import 'package:flutter/material.dart';

class ContactusPage extends StatelessWidget {
  const ContactusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text("Contact Us Page"),
      ),
    );
  }
}
