class Article {
  static const db_aid = "aid";
  static const db_title = "title";
  static const db_matter = "matter";

  int aId;
  String title;
  String matter;

  Article({
    required this.aId,
    this.title = '',
    this.matter = '',
  });

  factory Article.fromMap(Map<String, dynamic> map) =>
      Article(aId: map[db_aid], title: map[db_title], matter: map[db_matter]);
}
