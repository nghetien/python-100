class Comment {
  final int? blogPostId;
  final String content;
  final String contentFormat;
  final String? courseId;
  final int createdAt;
  final int id;
  final String? image;
  final int lastReplyAt;
  final int? lessonItemId;
  final int? numLikes;
  final int numReplies;
  final int? parentId;
  final int questionId;
  final int? quizSubmissionId;
  final List<Comment>? replies;
  final int? score;
  final String status;
  final int? submissionId;
  final String? title;
  final String type;
  final String? userAvatar;
  final int userId;
  final String? userName;

  const Comment({
    this.blogPostId,
    required this.content,
    required this.contentFormat,
    this.courseId,
    required this.createdAt,
    required this.id,
    this.image,
    required this.lastReplyAt,
    this.lessonItemId,
    this.numLikes,
    required this.numReplies,
    this.parentId,
    required this.questionId,
    this.quizSubmissionId,
    this.replies,
    this.score,
    required this.status,
    this.submissionId,
    this.title,
    required this.type,
    this.userAvatar,
    required this.userId,
    this.userName,
  });

  static Comment sampleComment({
    required String content,
    String? avatar,
    String? nameUser,
  }) {
    return Comment(
      content: content,
      contentFormat: "",
      createdAt: 0,
      id: -1,
      lastReplyAt: 0,
      questionId: -1,
      status: "",
      type: "",
      userId: -1,
      numReplies: 0,
      userAvatar: avatar,
      userName: nameUser,
    );
  }

  static Comment createAComment(Map<String, dynamic> data) {
    List<Comment> listComment = [];
    if (data["replies"] != null && data["replies"].isNotEmpty) {
      for (Map<String, dynamic> item in data["replies"]) {
        listComment.add(Comment.createAComment(item));
      }
    }
    return Comment(
      blogPostId: data["blog_post_id"],
      content: data["content"],
      contentFormat: data["content_format"],
      courseId: data["course_id"],
      createdAt: data["created_at"],
      id: data["id"],
      image: data["image"],
      lastReplyAt: data["last_reply_at"],
      lessonItemId: data["lesson_item_id"],
      numLikes: data["num_likes"],
      numReplies: data["num_replies"],
      parentId: data["parent_id"],
      questionId: data["question_id"],
      quizSubmissionId: data["quiz_submission_id"],
      replies: listComment,
      score: data["score"],
      status: data["status"],
      submissionId: data["submission_id"],
      title: data["title"],
      type: data["type"],
      userAvatar: data["user_avatar"],
      userId: data["user_id"],
      userName: data["user_name"],
    );
  }

  static List<Comment> createListComment(List<dynamic> listData) {
    List<Comment> listComment = [];
    for (Map<String, dynamic> item in listData) {
      listComment.add(Comment.createAComment(item));
    }
    return listComment;
  }
}
