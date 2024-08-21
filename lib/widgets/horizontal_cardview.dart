import 'package:flutter/material.dart';

class HorizontalCardWidget extends StatelessWidget {
  const HorizontalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate card dimensions based on screen width
    final double cardWidth = screenWidth < 600 ? 120.0 : 150.0;
    final double cardHeight = screenWidth < 600 ? 30.0 : 35.0;

    return Container(
      width: screenWidth,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          height: cardHeight + 16, // Add padding to height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(226, 226, 226, 1),
                  ),
                  child: Center(
                    child: Text(
                      'Card ${index + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(130, 130, 130, 1),
                        fontSize: screenWidth < 600 ? 12 : 14,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
