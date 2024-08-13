import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/article.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/services/articles_services.dart';

class ArticlesController extends GetxController {
  Rx<double> fontSizeMalayalam =
      SettingsHelpers.instance.getFontSizeMalayalam!.obs;

  ArticlesServices articlesServices = ArticlesServices();
  bool isLoading = true;
  late RxInt selArticleId = 0.obs;
  String audioCode = '';
  List<Article> articlesList = [];

  Rxn<Article> selArticle = Rxn<Article>();

  Rx<bool> showPlayer = false.obs;
  String localFilePath = '';
  late String audiofolder;

  @override
  void onInit() {
    super.onInit();
    loadDB();
    // selArticleId.listen((articleId) async {
    //   await loadArticle(articleId);
    // });
  }

  void loadDB() async {
    var data = Get.arguments;
    selArticleId.value = data[0];
    await loadArticle(selArticleId.value);
  }

  /// Article loading
  loadArticle(int inArticleId) async {
    try {
      //   isLoading = true;
      update();
      selArticle.value = await articlesServices.getArticle(inArticleId);
      isLoading = false;
      update();
    } catch (e) {
      // print(e);
    }
  }
}
