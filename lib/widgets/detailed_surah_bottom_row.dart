import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWidget extends StatelessWidget {
  final double scaleFactor;

  // ignore: prefer_const_constructors_in_immutables
  CustomWidget(this.scaleFactor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(115, 78, 9, 1),
      height: 50 * scaleFactor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              CustomDropdown(
                options: const ['Option 1', 'Option 2', 'Option 3'],
                selectedValue: 'Option 1',
                onChanged: (_) {},
                scaleFactor: scaleFactor,
              ),
              const SizedBox(width: 16),
              CustomDropdown(
                options: const ['1', '2', '3'],
                selectedValue: '1',
                onChanged: (_) {},
                scaleFactor: scaleFactor,
              ),
              const SizedBox(width: 16),
              CustomDropdown(
                options: const ['1 : 1', '1 : 2', '1  : 3'],
                selectedValue: '1 : 1',
                onChanged: (_) {},
                scaleFactor: scaleFactor,
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8), // Reduced padding
                  backgroundColor: const Color.fromRGBO(115, 78, 9, 1),
                  foregroundColor: const Color.fromRGBO(162, 132, 94, 1),
                  side: const BorderSide(
                    color: Color.fromRGBO(162, 132, 94, 1),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16), // Reduced icon size
              ),
              const SizedBox(width: 16), // Add some spacing between buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8), // Reduced padding
                  backgroundColor: const Color.fromRGBO(115, 78, 9, 1),
                  foregroundColor: const Color.fromRGBO(162, 132, 94, 1),
                  side: const BorderSide(
                    color: Color.fromRGBO(162, 132, 94, 1),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16), // Reduced icon size
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final double scaleFactor;

  const CustomDropdown({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.scaleFactor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * widget.scaleFactor),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(92, 62, 5, 1), // Darker brown color
        border: Border.all(
          color: const Color(0xFF825B11),
          width: 2 * widget.scaleFactor, // Border width
        ),
        borderRadius: BorderRadius.circular(10 * widget.scaleFactor),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: 30 * widget.scaleFactor,
          child: DropdownButton<String>(
            value: widget.selectedValue,
            icon: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Icon(
                Icons.arrow_drop_down_circle_outlined,
                color: const Color.fromRGBO(130, 91, 17, 1),
                size: 18 * widget.scaleFactor,
              ),
            ),
            style: GoogleFonts.notoSansMalayalam(
              color: const Color.fromRGBO(217, 217, 217, 1),
              fontSize: 12 * widget.scaleFactor,
            ),
            dropdownColor: const Color.fromRGBO(
                130, 90, 17, 1), // Matching darker brown color
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}
