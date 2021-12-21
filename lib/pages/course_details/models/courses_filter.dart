class CoursesFilter {
  final String keyword;
  final String tag;
  final String category;
  final int page;
  final int pageSize;

  CoursesFilter({
    this.keyword = "",
    this.tag = "",
    this.category = "",
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> get getJSon {
    return {
      "keyword": keyword,
      "tag": tag,
      "category": category,
      "page": page.toString(),
      "pageSize": pageSize.toString(),
    };
  }

  static Map<String, dynamic> getInstant() {
    return CoursesFilter(
      keyword: "",
      tag: "",
      category: "",
      page: 1,
      pageSize: 10,
    ).getJSon;
  }
}
