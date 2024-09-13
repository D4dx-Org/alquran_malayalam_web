
import 'package:alquran_web/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/controllers/search_controller.dart';

class SurahBottomRow extends StatefulWidget {
  final double scaleFactor;
  final TabController tabController;

  const SurahBottomRow(this.scaleFactor,
      {required this.tabController, Key? key})
      : super(key: key);

  @override
  _SurahBottomRowState createState() => _SurahBottomRowState();
}

class _SurahBottomRowState extends State<SurahBottomRow>
    with SingleTickerProviderStateMixin {
  final _quranController = Get.find<QuranController>();
  bool _showSearchBar = false;
  final FocusNode _searchFocusNode = FocusNode();

  bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600; // Adjust this breakpoint as needed
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _showSearchBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = isMobileScreen(context);

    return GestureDetector(
      onTap: () {
        if (_showSearchBar) {
          _searchFocusNode.unfocus();
        }
      },
      child: Container(
        color: const Color.fromRGBO(115, 78, 9, 1),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_showSearchBar && isMobile)
              Expanded(
                child: SearchWidget(
                  width: MediaQuery.of(context).size.width,
                  onSearch: (query) {
                    // This will be handled by the SearchWidget internally
                  },
                  focusNode: _searchFocusNode,
                ),
              )
            else ...[
              if (!_showSearchBar || !isMobile)
                Expanded(
                  child: Wrap(
                    spacing: 5.0,
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
                          scaleFactor: widget.scaleFactor,
                        ),
                      ),
                      Obx(
                        () => CustomDropdown(
                          options: List.generate(
                            _quranController.selectedSurahAyahCount,
                            (index) => '${index + 1}',
                          ),
                          selectedValue:
                              _quranController.selectedAyahNumber.toString(),
                          onChanged: (value) {
                            if (value != null) {
                              _quranController.updateSelectedAyahRange(
                                  '${_quranController.selectedSurahId} : $value');
                            }
                          },
                          scaleFactor: widget.scaleFactor,
                        ),
                      ),
                      Obx(
                        () => CustomDropdown(
                          options: List.generate(
                            _quranController.selectedSurahAyahCount,
                            (index) => '${index + 1}',
                          ),
                          selectedValue:
                              _quranController.selectedAyahNumber.toString(),
                          onChanged: (value) {
                            if (value != null) {
                              _quranController.updateSelectedAyahRange(
                                  '${_quranController.selectedSurahId} : $value');
                            }
                          },
                          scaleFactor: widget.scaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isMobile)
                Expanded(
                  child: SearchWidget(
                    width: MediaQuery.of(context).size.width * 0.7,
                    onSearch: (query) {
                      // This will be handled by the SearchWidget internally
                    },
                    focusNode: _searchFocusNode,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showSearchBar = !_showSearchBar;
                          if (_showSearchBar) {
                            _searchFocusNode.requestFocus();
                          } else {
                            _searchFocusNode.unfocus();
                          }
                        });
                      },
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
                        minimumSize: const Size(50, 40),
                      ),
                      child: Icon(
                        _showSearchBar ? Icons.close : Icons.search_outlined,
                      ),
                    ),
                    if (!_showSearchBar || !isMobile) ...[
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          _quranController.navigateToPreviousSurah();
                        },
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
                          minimumSize: const Size(50, 40),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _quranController.navigateToNextSurah();
                        },
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
                          minimumSize: const Size(50, 40),
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// CustomDropdown widget remains unchanged

class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final double scaleFactor;

  const CustomDropdown({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(92, 62, 5, 1),
        border: Border.all(
          color: const Color(0xFF825B11),
          width: 2 * scaleFactor,
        ),
        borderRadius: BorderRadius.circular(10 * scaleFactor),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: 30 * scaleFactor,
          child: DropdownButton<String>(
            value: selectedValue,
            icon: Padding(
              padding: EdgeInsets.only(left: 8.0 * scaleFactor),
              child: Icon(
                Icons.arrow_drop_down_circle_outlined,
                color: const Color.fromRGBO(130, 91, 17, 1),
                size: 20 * scaleFactor,
              ),
            ),
            style: GoogleFonts.notoSansMalayalam(
              color: const Color.fromRGBO(217, 217, 217, 1),
              fontSize: 14 * scaleFactor,
            ),
            dropdownColor: const Color.fromRGBO(130, 90, 17, 1),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
