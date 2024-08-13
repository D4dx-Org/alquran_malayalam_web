import 'package:alquran_malayalam/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
      margin: const EdgeInsets.only(),
      child: Material(
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        elevation: 2.0,
        child: Container(
          height: 45.0,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFF0C98B5),
                    ),
                    hintText: 'Search text here',
                    border: InputBorder.none),
                onSubmitted: onSubmitted,
                controller: editingController,
              ))
            ],
          ),
        ),
      ),
    );
  }

  onSubmitted(String query) {
    if (query == '') return;
    Get.toNamed(AppRoutes.SEARCHRES,
        arguments: [query], preventDuplicates: false);
  }
}
