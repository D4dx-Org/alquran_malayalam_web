import 'package:alquran_web/controllers/search_controller.dart';
import 'package:alquran_web/widgets/search_result_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  final double? width;
  final Function(String)? onSearch;
  final FocusNode? focusNode; // Add this line

  const SearchWidget({
    super.key,
    this.width,
    this.onSearch,
    this.focusNode, // Add this line
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late FocusNode _focusNode; // Add this line

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode = widget.focusNode ?? FocusNode(); // Add this line
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _hideSearchResult();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange); // Add this line
    if (widget.focusNode == null) {
      // Add this block
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _hideSearchResult();
    }
  }

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty) {
      widget.onSearch?.call(_controller.text);
      Get.find<QuranSearchController>().updateSearchQuery(_controller.text);
      Get.find<QuranSearchController>().performSearch();
      _showSearchResult(_controller.text);
    } else {
      _hideSearchResult();
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
                focusNode: _focusNode, // Add this line
                onChanged: (value) {
                  widget.onSearch?.call(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color.fromRGBO(115, 78, 9, 1),
                    onPressed: () {
                      widget.onSearch?.call(_controller.text);
                      if (_controller.text.isNotEmpty) {
                        _showSearchResult(_controller.text);
                      }
                    },
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
