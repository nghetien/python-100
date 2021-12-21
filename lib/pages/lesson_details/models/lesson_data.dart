class LessonData{
  final int id;
  final String name;
  final String? courseId;
  final String? courseItemId;
  final String type;
  final String? quizType;
  final String? description;
  final String? shortDescription;
  final String? fileType;
  final String? fileUrl;
  final String? videoUrl;
  final int? videoDuration;
  final bool isGradedQuiz;
  final int uCoin;
  final double passPercentage;
  final int? numQuestions;
  final String? defaultCompiler;
  final String? content;
  final String? contentFormat;
  final String? slug;
  final bool isFree;
  final bool isPreview;
  final String? visibility;
  final String? approvalStatus;
  final String? approvalMsg;
  final String status;
  final List<dynamic>? tags;
  final String? extraInfo;
  final int? quizDuration;
  final String? source;
  final String? subject;
  final int? activeFromTime;
  final int? activeToTime;
  final String runningStatus;
  final bool? isPublicResult;
  final bool? joinWithKey;
  final String? joinKey;
  final bool? isShowAllQuestions;
  final String? quizMode;
  final int? interactionQuizId;
  final String? userStatus;
  final double? userPercentComplete;
  final double? startTime;
  final double? finishTime;
  final int? currentSubmission;
  final int? lastQuizSubmission;
  final int? serverTime;

  LessonData({
    required this.id,
    required this.name,
    this.courseId,
    this.courseItemId,
    required this.type,
    this.quizType,
    this.description,
    this.shortDescription,
    this.fileType,
    this.fileUrl,
    this.videoUrl,
    this.videoDuration,
    required this.isGradedQuiz,
    required this.uCoin,
    required this.passPercentage,
    this.numQuestions,
    this.defaultCompiler,
    this.content,
    this.contentFormat,
    this.slug,
    required this.isFree,
    required this.isPreview,
    this.visibility,
    this.approvalStatus,
    this.approvalMsg,
    required this.status,
    this.tags,
    this.extraInfo,
    this.quizDuration,
    this.source,
    this.subject,
    this.activeFromTime,
    this.activeToTime,
    required this.runningStatus,
    this.isPublicResult,
    this.joinWithKey,
    this.joinKey,
    this.isShowAllQuestions,
    this.quizMode,
    this.interactionQuizId,
    this.userStatus,
    this.userPercentComplete,
    this.startTime,
    this.finishTime,
    this.currentSubmission,
    this.lastQuizSubmission,
    this.serverTime,
  });

  static LessonData get emptyLessonData{
    return LessonData(
      id: -1,
      name: "",
      type: "",
      isGradedQuiz: false,
      uCoin: 0,
      passPercentage: 0,
      isFree: false,
      isPreview: false,
      status: "",
      runningStatus: "",
    );
}

  static LessonData createALessonDataFromJson(Map<String, dynamic> data){
    return LessonData(
      id: data["id"],
      name: data["name"],
      courseId: data["course_id"],
      courseItemId: data["course_item_id"],
      type: data["type"],
      quizType: data["quiz_type"],
      description: data["description"],
      shortDescription: data["short_description"],
      fileType: data["file_type"],
      fileUrl: data["file_url"],
      videoUrl: data["video_url"],
      videoDuration: data["video_duration"],
      isGradedQuiz: data["is_graded_quiz"],
      uCoin: data["ucoin"],
      passPercentage: data["pass_percentage"],
      numQuestions: data["num_questions"],
      defaultCompiler: data["default_compiler"],
      content: data["content"],
      contentFormat: data["content_format"],
      slug: data["slug"],
      isFree: data["is_free"],
      isPreview: data["is_preview"],
      visibility: data["visibility"],
      approvalStatus: data["approval_status"],
      approvalMsg: data["approval_msg"],
      status: data["status"],
      tags: data["tags"],
      extraInfo: data["extra_info"],
      quizDuration: data["quiz_duration"],
      source: data["source"],
      subject: data["subject"],
      activeFromTime: data["active_from_time"],
      activeToTime: data["active_to_time"],
      runningStatus: data["running_status"],
      isPublicResult: data["is_public_result"],
      joinWithKey: data["join_with_key"],
      joinKey: data["join_key"],
      isShowAllQuestions: data["is_show_all_questions"],
      quizMode: data["quiz_mode"],
      interactionQuizId: data["interaction_quiz_id"],
      userStatus: data["user_status"],
      userPercentComplete: data["user_percent_complete"],
      startTime: data["start_time"],
      finishTime: data["finish_time"],
      currentSubmission: data["current_submission"],
      lastQuizSubmission: data["last_quiz_submission"],
      serverTime: data["server_time"],
    );
  }

}