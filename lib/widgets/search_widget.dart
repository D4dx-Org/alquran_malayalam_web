import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final double? width;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SearchWidget({
    super.key,
    this.width,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = width ?? constraints.maxWidth;
        double searchWidth = maxWidth > 600 ? 500 : maxWidth * 0.9;

        return Container(
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
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                color: const Color.fromRGBO(115, 78, 9, 1),
                onPressed: () {
                  onClear?.call();
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
