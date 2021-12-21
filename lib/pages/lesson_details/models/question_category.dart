class QuestionCategory {
  final int? id;
  final String? name;
  final int? parentId;
  final int? level;
  final int? order;

  const QuestionCategory({
    this.id,
    this.name,
    this.parentId,
    this.level,
    this.order,
  });

  static List<QuestionCategory> createListQuizCategoryFromJSON(List<dynamic> listDataJSON) {
    List<QuestionCategory> listItem = [];
    if (listDataJSON.isNotEmpty) {
      listItem = listDataJSON.map<QuestionCategory>((item) => QuestionCategory(
        id: item["id"],
        name: item["name"],
        parentId: item["parent_id"],
        level: item["level"],
        order: item["order"],
      )).toList();
      return listItem;
    } else {
      return listItem;
    }
  }
}
