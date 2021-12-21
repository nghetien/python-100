class CourseItem {
  final int id;
  final int level;
  final String itemType;
  final String name;
  final String? contentType;
  final String? quizType;
  final int uCoin;
  final bool? isPreview;
  final bool? isFree;
  final int? lessonItemId;
  final int? parentId;
  final String status;
  final bool? isLessonGroup;
  final String? userStatus;
  final int? userStartedAt;
  final double? userPercentComplete;
  final int? userLastJoinedAt;
  final List<CourseItem>? items;

  CourseItem({
    required this.id,
    required this.level,
    required this.itemType,
    required this.name,
    required this.contentType,
    this.quizType,
    required this.uCoin,
    required this.isPreview,
    required this.isFree,
    this.lessonItemId,
    this.parentId,
    required this.status,
    this.isLessonGroup,
    this.userStatus,
    this.userStartedAt,
    this.userPercentComplete,
    this.userLastJoinedAt,
    this.items,
  });

  static List<CourseItem> createListCourseItem(List<dynamic> dataAPI) {
    List<CourseItem> listItem = dataAPI.map((item) {
      List<CourseItem> loopCourseItem = [];
      if (item["items"].isNotEmpty) {
        loopCourseItem = CourseItem.createListCourseItem(item["items"]);
      }
      return CourseItem(
        id: item["id"],
        level: item["level"],
        itemType: item["item_type"],
        name: item["name"],
        contentType: item["content_type"],
        quizType: item["quiz_type"],
        uCoin: item["ucoin"],
        isPreview: item["is_preview"],
        isFree: item["is_free"],
        lessonItemId: item["lesson_item_id"],
        parentId: item["parent_id"],
        status: item["status"],
        isLessonGroup: item["is_lesson_group"],
        userStatus: item["user_status"],
        userStartedAt: item["user_started_at"],
        userPercentComplete: item["user_percent_complete"],
        userLastJoinedAt: item["user_last_joined_at"],
        items: loopCourseItem,
      );
    }).toList();
    return listItem;
  }

}
