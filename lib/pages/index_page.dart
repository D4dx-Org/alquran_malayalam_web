import 'package:alquran_web/widgets/horizontal_cardview.dart';
import 'package:alquran_web/widgets/index_appbar.dart';
import 'package:alquran_web/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IndexAppbar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchWidget(
              width: MediaQuery.of(context).size.width,
              onChanged: (value) {
                // Handle search text changes
                print('Search query: $value');
              },
              onClear: () {
                // Handle clear button press
                print('Search cleared');
              },
            ),
            SizedBox(height: 25),
            HorizontalCardWidget(),
          ],
        ),
      ),
    );
  }
}
