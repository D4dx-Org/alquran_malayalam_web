// // ignore_for_file: avoid_print

// import 'package:alquran_web/controllers/search_controller.dart';
// import 'package:alquran_web/widgets/search_result_popup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class SearchWidget extends StatefulWidget {
//   final double? width;
//   final Function(String)? onSearch;
//   final FocusNode? focusNode;

//   const SearchWidget({
//     super.key,
//     this.width,
//     this.onSearch,
//     this.focusNode,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _SearchWidgetState createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends State<SearchWidget> {
//   final TextEditingController _controller = TextEditingController();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   late FocusNode _focusNode;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   List<stt.LocaleName> _localeNames = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(_onSearchChanged);
//     _focusNode = widget.focusNode ?? FocusNode();
//     _focusNode.addListener(_onFocusChange);
//     _speech = stt.SpeechToText();
//     _initSpeechState();
//   }

//   @override
//   void dispose() {
//     _hideSearchResult();
//     _controller.removeListener(_onSearchChanged);
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     if (widget.focusNode == null) {
//       _focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _initSpeechState() async {
//     var available = await _speech.initialize();
//     if (available) {
//       _localeNames = await _speech.locales();
//       var malayalamSupported =
//           _localeNames.any((locale) => locale.localeId == 'ml-IN');
//       if (!malayalamSupported) {
//         print('Malayalam is not supported on this device');
//         // Handle the case when Malayalam is not supported
//       }
//     }
//   }

//   void _onFocusChange() {
//     if (!_focusNode.hasFocus) {
//       _hideSearchResult();
//     }
//   }

//   void _onSearchChanged() {
//     if (_controller.text.isNotEmpty) {
//       widget.onSearch?.call(_controller.text);
//       Get.find<QuranSearchController>().updateSearchQuery(_controller.text);
//       Get.find<QuranSearchController>().performSearch();
//       _showSearchResult(_controller.text);
//     } else {
//       _hideSearchResult();
//     }
//   }

//   void _showSearchResult(String searchText) {
//     _hideSearchResult();
//     _overlayEntry = _createOverlayEntry(searchText);
//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   void _hideSearchResult() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   OverlayEntry _createOverlayEntry(String searchText) {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;

//     return OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: _hideSearchResult,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Container(
//                 color: Colors.transparent,
//               ),
//             ),
//             Positioned(
//               width: size.width,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0.0, size.height + 5.0),
//                 child: GestureDetector(
//                   onTap: () {}, // Prevent taps on the popup from closing it
//                   child: Material(
//                     elevation: 4.0,
//                     child: SearchResultPopup(
//                       searchText: searchText,
//                       onClose: _hideSearchResult,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (status) => print('onStatus: $status'),
//         onError: (errorNotification) => print('onError: $errorNotification'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             setState(() {
//               _controller.text = result.recognizedWords;
//               _onSearchChanged();
//             });
//           },
//           localeId: 'ml-IN', // Specify Malayalam language
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         double maxWidth = widget.width ?? constraints.maxWidth;
//         double searchWidth = maxWidth > 600 ? 500 : maxWidth * 0.9;

//         return GestureDetector(
//           onTap: () {
//             if (_overlayEntry != null) {
//               _hideSearchResult();
//             }
//           },
//           child: CompositedTransformTarget(
//             link: _layerLink,
//             child: Container(
//               width: searchWidth,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: const Color.fromRGBO(130, 130, 130, 1),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _controller,
//                 focusNode: _focusNode,
//                 onChanged: (value) {
//                   widget.onSearch?.call(value);
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   suffixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
//                         onPressed: _listen,
//                         color: const Color.fromRGBO(115, 78, 9, 1),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.search),
//                         color: const Color.fromRGBO(115, 78, 9, 1),
//                         onPressed: () {
//                           widget.onSearch?.call(_controller.text);
//                           if (_controller.text.isNotEmpty) {
//                             _showSearchResult(_controller.text);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 15,
//                     horizontal: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: avoid_print

import 'package:alquran_web/controllers/quran_controller.dart';
import 'package:alquran_web/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:alquran_web/controllers/search_controller.dart';
import 'package:alquran_web/widgets/search_result_popup.dart';
import 'dart:async';

class SearchWidget extends StatefulWidget {
  final double? width;
  final Function(String)? onSearch;
  final FocusNode? focusNode;

  const SearchWidget({
    super.key,
    this.width,
    this.onSearch,
    this.focusNode,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late FocusNode _focusNode;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<stt.LocaleName> _localeNames = [];
  Timer? _listenTimer;
  Timer? _navigationDebounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _speech = stt.SpeechToText();
    _initSpeechState();
  }

  @override
  void dispose() {
    _hideSearchResult();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _speech.cancel();
    _listenTimer?.cancel();
    _navigationDebounceTimer?.cancel();
    super.dispose();
  }

  void _initSpeechState() async {
    var available = await _speech.initialize();
    if (available) {
      _localeNames = await _speech.locales();
      var malayalamSupported =
          _localeNames.any((locale) => locale.localeId == 'ml-IN');
      if (!malayalamSupported) {
        // print('Malayalam is not supported on this device');
        // Handle the case when Malayalam is not supported
      }
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _hideSearchResult();
    }
  }

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty && mounted) {
      widget.onSearch?.call(_controller.text);
      final searchController = Get.find<QuranSearchController>();
      searchController.updateSearchQuery(_controller.text);
      searchController.performSearch();
      _showSearchResult(_controller.text);

      // Add this line to check for surah:ayah pattern
      _checkAndNavigateToAyah(_controller.text);
    } else {
      _hideSearchResult();
    }
  }

  // Add this new method
  void _checkAndNavigateToAyah(String input) {
    final pattern = RegExp(r'^(\d+):(\d+)$');
    final match = pattern.firstMatch(input);

    if (match != null) {
      // Cancel any existing timer
      _navigationDebounceTimer?.cancel();

      // Start a new timer
      _navigationDebounceTimer = Timer(const Duration(seconds: 2), () {
        final surahNumber = int.parse(match.group(1)!);
        final ayahNumber = int.parse(match.group(2)!);

        if (surahNumber >= 1 && surahNumber <= 114) {
          final quranController = Get.find<QuranController>();
          final surahName = quranController.getSurahName(surahNumber);

          quranController.updateSelectedSurahId(surahNumber, ayahNumber);
          quranController.updateSelectedAyahNumber(ayahNumber);

          Get.toNamed(
            Routes.SURAH_DETAILED,
            arguments: {
              'surahId': surahNumber,
              'surahName': surahName,
              'ayahNumber': ayahNumber,
            },
          );

          // Clear the search field after navigation
          _controller.clear();
          _hideSearchResult();
        }
      });
    }
  }

  void _showSearchResult(String searchText) {
    _hideSearchResult();
    _overlayEntry = _createOverlayEntry(searchText);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSearchResult() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(String searchText) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideSearchResult,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: GestureDetector(
                  onTap: () {}, // Prevent taps on the popup from closing it
                  child: Material(
                    elevation: 4.0,
                    child: SearchResultPopup(
                      searchText: searchText,
                      onClose: _hideSearchResult,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('onStatus: $status'),
        onError: (errorNotification) => print('onError: $errorNotification'),
      );
      if (available && mounted) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _controller.text = result.recognizedWords;
                _onSearchChanged();
              });
            }
          },
          localeId: 'ml-IN', // Specify Malayalam language
        );

        // Start the timer
        _listenTimer = Timer(const Duration(seconds: 5), () {
          if (_isListening) {
            _stopListening();
          }
        });
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    if (mounted) {
      setState(() => _isListening = false);
    }
    _speech.stop();
    _listenTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = widget.width ?? constraints.maxWidth;
        double searchWidth = maxWidth > 600 ? 500 : maxWidth * 0.9;

        return GestureDetector(
          onTap: () {
            if (_overlayEntry != null) {
              _hideSearchResult();
            }
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              width: searchWidth,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromRGBO(130, 130, 130, 1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  widget.onSearch?.call(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        onPressed: _listen,
                        color: const Color.fromRGBO(115, 78, 9, 1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: const Color.fromRGBO(115, 78, 9, 1),
                        onPressed: () {
                          widget.onSearch?.call(_controller.text);
                          if (_controller.text.isNotEmpty) {
                            _showSearchResult(_controller.text);
                          }
                        },
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
