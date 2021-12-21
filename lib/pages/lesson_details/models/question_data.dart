import '../../pages.dart';

class QuestionData {
  final String? answers;
  final String? approvalMsg;
  final String? approvalStatus;
  final bool? availableForChallenge;
  final String? codeStuff;
  final String? compiler;
  final String? constraints;
  final String? difficultLevel;
  final double? difficulty;
  final String? displayType;
  final bool editable;
  final bool? enableOnQuiz;
  final String? extraInfo;
  final String? headline;
  final String? hint;
  final int id;
  final String? inputDesc;
  final List<dynamic>? languages;
  final int? maxSubmitTimes;
  final String name;
  final int numAcceptedSubmission;
  final int umAcceptedUsers;
  final int numSubmission;
  final int numSubmittedUsers;
  final String? optionDisplay;
  final String? options;
  final String? outputDesc;
  final String? programmingLanguages;
  final String? resourceLimit;
  final int? rootQuestionId;
  final List<QuestionTestCase>? sampleTestcases;
  final int score;
  final String? slug;
  final String? solutions;
  final String? source;
  final String? sourceDetail;
  final String statement;
  final String statementFormat;
  final String? statementLanguage;
  final String? statementMedia;
  final String status;
  final String? subject;
  final List<dynamic>? tags;
  final String? teacherAvatar;
  final int teacherId;
  final String? teacherName;
  final String type;
  final int uCoin;
  final String? userAnswerFormat;
  final String? userBestAnswer;
  final int? userBestScore;
  final String? userBestSourceCode;
  final String? userFileType;
  final String? userLanguageId;
  final int? userLastSubmittedAt;
  final String? userStatus;
  final int? variantQuestionId;
  final String visibility;

  const QuestionData({
    this.answers,
    this.approvalMsg,
    this.approvalStatus,
    this.availableForChallenge,
    this.codeStuff,
    this.compiler,
    this.constraints,
    this.difficultLevel,
    this.difficulty,
    this.displayType,
    required this.editable,
    this.enableOnQuiz,
    this.extraInfo,
    this.headline,
    this.hint,
    required this.id,
    this.inputDesc,
    this.languages,
    this.maxSubmitTimes,
    required this.name,
    required this.numAcceptedSubmission,
    required this.umAcceptedUsers,
    required this.numSubmission,
    required this.numSubmittedUsers,
    this.optionDisplay,
    this.options,
    this.outputDesc,
    this.programmingLanguages,
    this.resourceLimit,
    this.rootQuestionId,
    this.sampleTestcases,
    required this.score,
    this.slug,
    this.solutions,
    this.source,
    this.sourceDetail,
    required this.statement,
    required this.statementFormat,
    this.statementLanguage,
    this.statementMedia,
    required this.status,
    this.subject,
    this.tags,
    this.teacherAvatar,
    required this.teacherId,
    this.teacherName,
    required this.type,
    required this.uCoin,
    this.userAnswerFormat,
    this.userBestAnswer,
    this.userBestScore,
    this.userBestSourceCode,
    this.userFileType,
    this.userLanguageId,
    this.userLastSubmittedAt,
    this.userStatus,
    this.variantQuestionId,
    required this.visibility,
  });

  static QuestionData createAQuestionData(Map<String, dynamic> data) {
    return QuestionData(
      answers: data["answers"],
      approvalMsg: data["approval_msg"],
      approvalStatus: data["approval_status"],
      availableForChallenge: data["available_for_challenge"],
      codeStuff: data["code_stuff"],
      compiler: data["compiler"],
      constraints: data["constraints"],
      difficultLevel: data["difficult_level"],
      difficulty: data["difficulty"],
      displayType: data["display_type"],
      editable: data["editable"],
      enableOnQuiz: data["enable_on_quiz"],
      extraInfo: data["extra_info"],
      headline: data["headline"],
      hint: data["hint"],
      id: data["id"],
      inputDesc: data["input_desc"],
      languages: data["languages"],
      maxSubmitTimes: data["max_submit_times"],
      name: data["name"],
      numAcceptedSubmission: data["num_accepted_submission"],
      umAcceptedUsers: data["num_accepted_users"],
      numSubmission: data["num_submission"],
      numSubmittedUsers: data["num_submitted_users"],
      optionDisplay: data["option_display"],
      options: data["options"],
      outputDesc: data["output_desc"],
      programmingLanguages: data["programming_languages"],
      resourceLimit: data["resource_limit"],
      rootQuestionId: data["root_question_id"],
      sampleTestcases: QuestionTestCase.createListQuizTestCaseFromJSON(data["sample_testcases"] ?? []),
      score: data["score"],
      slug: data["slug"],
      solutions: data["solutions"],
      source: data["source"],
      sourceDetail: data["source_detail"],
      statement: data["statement"],
      statementFormat: data["statement_format"],
      statementLanguage: data["statement_language"],
      statementMedia: data["statement_media"],
      status: data["status"],
      subject: data["subject"],
      tags: data["tags"],
      teacherAvatar: data["teacher_avatar"],
      teacherId: data["teacher_id"],
      teacherName: data["teacher_name"],
      type: data["type"],
      uCoin: data["ucoin"],
      userAnswerFormat: data["user_answer_format"],
      userBestAnswer: data["user_best_answer"],
      userBestScore: data["user_best_score"],
      userBestSourceCode: data["user_best_source_code"],
      userFileType: data["user_file_type"],
      userLanguageId: data["user_language_id"],
      userLastSubmittedAt: data["user_last_submitted_at"],
      userStatus: data["user_status"],
      variantQuestionId: data["variant_question_id"],
      visibility: data["visibility"],
    );
  }

  static List<QuestionData> createListQuizDataFromJSON(List<dynamic> listDataJSON) {
    List<QuestionData> listItem = [];
    if (listDataJSON.isNotEmpty) {
      listItem = listDataJSON.map<QuestionData>((item) => createAQuestionData(item as Map<String, dynamic>)).toList();
      return listItem;
    } else {
      return listItem;
    }
  }
}
