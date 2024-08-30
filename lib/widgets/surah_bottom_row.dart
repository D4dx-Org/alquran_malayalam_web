
// SurahBottomRow.dart  
import 'package:alquran_web/controllers/quran_controller.dart';  
import 'package:flutter/material.dart';  
import 'package:get/get.dart';  
import 'package:google_fonts/google_fonts.dart';  

class SurahBottomRow extends StatelessWidget {  
  final double scaleFactor;  
  final _quranController = Get.find<QuranController>();  

  SurahBottomRow(this.scaleFactor, {super.key});  

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
              Obx(  
                () => CustomDropdown(  
                  options: _quranController.surahNames,  
                  selectedValue: _quranController.selectedSurah,  
                  onChanged: (value) {  
                    if (value != null) {  
                      _quranController.updateSelectedSurah(value);  
                    }  
                  },  
                  scaleFactor: scaleFactor,  
                ),  
              ),  
              const SizedBox(width: 16),  
              Obx(  
                () => CustomDropdown(  
                  options: _quranController.surahIds.map((id) => id.toString()).toList(),  
                  selectedValue: _quranController.selectedSurahId.toString(),  
                  onChanged: (value) {  
                    if (value != null) {  
                      _quranController.updateSelectedSurahId(int.parse(value));  
                    }  
                  },  
                  scaleFactor: scaleFactor,  
                ),  
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
                  padding: const EdgeInsets.all(8),  
                  backgroundColor: const Color.fromRGBO(115, 78, 9, 1),  
                  foregroundColor: const Color.fromRGBO(162, 132, 94, 1),  
                  side: const BorderSide(  
                    color: Color.fromRGBO(162, 132, 94, 1),  
                    width: 2,  
                  ),  
                ),  
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),  
              ),  
              const SizedBox(width: 16),  
              ElevatedButton(  
                onPressed: () {},  
                style: ElevatedButton.styleFrom(  
                  shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(12),  
                  ),  
                  padding: const EdgeInsets.all(8),  
                  backgroundColor: const Color.fromRGBO(115, 78, 9, 1),  
                  foregroundColor: const Color.fromRGBO(162, 132, 94, 1),  
                  side: const BorderSide(  
                    color: Color.fromRGBO(162, 132, 94, 1),  
                    width: 2,  
                  ),  
                ),  
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),  
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
        color: const Color.fromRGBO(92, 62, 5, 1),  
        border: Border.all(  
          color: const Color(0xFF825B11),  
          width: 2 * widget.scaleFactor,  
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
            dropdownColor: const Color.fromRGBO(130, 90, 17, 1),  
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
