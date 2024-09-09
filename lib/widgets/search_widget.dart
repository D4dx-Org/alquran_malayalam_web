// import 'package:alquran_web/widgets/search_result_popup.dart';
// import 'package:flutter/material.dart';

// class SearchWidget extends StatefulWidget {
//   final double? width;
//   final Function(String)? onSearch;

//   const SearchWidget({
//     Key? key,
//     this.width,
//     this.onSearch,
//   }) : super(key: key);

//   @override
//   _SearchWidgetState createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends State<SearchWidget> {
//   final TextEditingController _controller = TextEditingController();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;

//   @override
//   void dispose() {
//     _hideSearchResult();
//     super.dispose();
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
//       builder: (context) => Positioned(
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: Offset(0.0, size.height + 5.0),
//           child: Material(
//             elevation: 4.0,
//             child: SearchResultPopup(searchText: searchText),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         double maxWidth = widget.width ?? constraints.maxWidth;
//         double searchWidth = maxWidth > 600 ? 500 : maxWidth * 0.9;

//         return CompositedTransformTarget(
//           link: _layerLink,
//           child: Container(
//             width: searchWidth,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: const Color.fromRGBO(130, 130, 130, 1),
//                 width: 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _controller,
//               onSubmitted: (value) {
//                 widget.onSearch?.call(value);
//                 _showSearchResult(value);
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   color: const Color.fromRGBO(115, 78, 9, 1),
//                   onPressed: () {
//                     widget.onSearch?.call(_controller.text);
//                     _showSearchResult(_controller.text);
//                   },
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 15,
//                   horizontal: 20,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:alquran_web/widgets/search_result_popup.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final double? width;
  final Function(String)? onSearch;

  const SearchWidget({
    Key? key,
    this.width,
    this.onSearch,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _hideSearchResult();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty) {
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
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: SearchResultPopup(
              searchText: searchText,
              onClose: _hideSearchResult,
            ),
          ),
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

        return CompositedTransformTarget(
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
        );
      },
    );
  }
}
