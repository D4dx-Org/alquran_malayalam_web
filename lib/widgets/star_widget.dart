import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class StarNumber extends StatelessWidget {
  final int number;
  final double size;
  final Color borderColor;
  final Color fillColor;
  final Color textColor;

  const StarNumber({
    super.key,
    required this.number,
    this.size = 37,
    this.borderColor = const Color.fromRGBO(115, 78, 9, 1),
    this.fillColor = const Color(0xFFF6F6F6),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(borderColor, fillColor),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Text(
              number.toString(),
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;

  _StarPainter(this.borderColor, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;
    double innerRadius = radius * 0.75; // Adjust this for pointiness

    Path path = Path();
    for (int i = 0; i < 16; i++) {
      // 16 points for an 8-sided star
      double r = (i % 2 == 0) ? radius : innerRadius;
      double angle = i * math.pi / 8 - math.pi / 2;
      double x = centerX + r * math.cos(angle);
      double y = centerY + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    Paint fillPaint = Paint()..color = fillColor;
    Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
