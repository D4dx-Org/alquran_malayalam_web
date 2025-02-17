import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:alquran_web/controllers/search_controller.dart';
import 'package:alquran_web/widgets/search_result_popup.dart';
import 'dart:async';
import 'dart:developer' as developer;

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
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
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
        // Handle the case when Malayalam is not supported
      }
    }
  }

  void _onFocusChange() {
    developer.log(
        'Search widget focus changed: hasFocus=${_focusNode.hasFocus}',
        name: 'SearchWidget');
    if (!_focusNode.hasFocus) {
      _hideSearchResult();
    }
  }

  void _onSearchChanged() {
    developer.log('Search text changed: ${_controller.text}',
        name: 'SearchWidget');
    if (_controller.text.isNotEmpty) {
      // Use the new direct navigation handler for format "surah:aya"
      final searchController = Get.find<QuranSearchController>();
      searchController.handleSearchNavigation(_controller.text);
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

  void _showListeningOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Mic is On',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideListeningOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('onStatus: $status'),
        onError: (errorNotification) =>
            debugPrint('onError: $errorNotification'),
      );
      if (available && mounted) {
        setState(() {
          _isListening = true;
        });
        _showListeningOverlay(); // Show the listening overlay
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
      setState(() {
        _isListening = false;
      });
    }
    _speech.stop();
    _hideListeningOverlay(); // Hide the listening overlay
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
            developer.log('Search widget tapped', name: 'SearchWidget');
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
                onTap: () {
                  developer.log('TextField tapped', name: 'SearchWidget');
                },
                onChanged: (value) {
                  developer.log('TextField value changed: $value',
                      name: 'SearchWidget');
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
