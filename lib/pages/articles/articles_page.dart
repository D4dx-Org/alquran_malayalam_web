import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/article.dart';
import 'package:alquran_malayalam/pages/articles/articles_controller.dart';

class ArticlesPage extends StatelessWidget {
  final ArticlesController controller = Get.put(ArticlesController());
  Color headColor = const Color(0xFF0C98B5);

  ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          backgroundColor: headColor,
          title: (controller.selArticle.value != null)
              ? Text(controller.selArticle.value!.title)
              : Text('Article'),
          elevation: 0,
        ),
        body: GetBuilder<ArticlesController>(
          init: controller,
          builder: (_) => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ArticleView(),
        )));
  }
}

class ArticleView extends StatelessWidget {
  final ArticlesController artController = Get.find();
  ArticleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (artController.selArticle.value == null) return Container();
    return _viewArticleWidget(artController.selArticle.value!, context);
  }

  Widget _viewArticleWidget(Article inArticleObj, BuildContext bcontext) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                // margin: const EdgeInsets.only(top: 8),
                height: Get.height - 95,
                width: double.maxFinite,
                child: Container(
                    width: Get.width - 32,
                    height: Get.height - 200,
                    //padding: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Column(children: <Widget>[
                      Flexible(
                          child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: <Widget>[
                            _getBody(),
                          ])),
                    ])))
          ])),
        ]);
  }

  Widget _getBody() {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  _getTittle(artController.selArticle.value!.title),
          _getDescription(artController.selArticle.value!.matter),
        ],
      ),
    );
  }

  _getTittle(tittle) {
    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          tittle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SettingsHelpers.instance.getFontSizeMalayalam!,
            color: const Color(0xFF00918E),
          ),
        ));
  }

  _getDescription(description) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Html(data: description, style: {
        "h3": Style.fromTextStyle(TextStyle(
          fontFamily: 'NotoSansMalayalam',
          height: 2,
          fontSize: SettingsHelpers.instance.getFontSizeMalayalam!,
          color: const Color(0xFF00918E),
        )),
        "html": Style.fromTextStyle(TextStyle(
            fontFamily: 'NotoSansMalayalam',
            fontSize: artController.fontSizeMalayalam.value,
            height: 1.5,
            decoration: TextDecoration.none)),
      }),
    );
  }
}
