class Submission {
  final String answer;
  final String answerFormat;
  final int ?challengeId;
  final String? detailAnswer;
  final String? fileType;
  final int id;
  final String judgeStatus;
  final String language;
  final int questionId;
  final int quizId;
  final double score;
  final String sourceCode;
  final String status;
  final String? statusMsg;
  final int submittedAt;
  final String? userAvatar;
  final String userEmail;
  final int userId;
  final String? userName;

  const Submission({
    required this.answer,
    required this.answerFormat,
    this.challengeId,
    this.detailAnswer,
    this.fileType,
    required this.id,
    required this.judgeStatus,
    required this.language,
    required this.questionId,
    required this.quizId,
    required this.score,
    required this.sourceCode,
    required this.status,
    this.statusMsg,
    required this.submittedAt,
    this.userAvatar,
    required this.userEmail,
    required this.userId,
    this.userName,
  });

  static const empty = Submission(
    answer: "",
    answerFormat: "",
    id: -1,
    judgeStatus: "",
    language: "",
    questionId: -1,
    quizId: -1,
    score: 0,
    sourceCode: "",
    status: "",
    submittedAt: 0,
    userEmail: "",
    userId: 0,
  );

  static Submission createASubmissions(Map<String, dynamic> data) {
    return Submission(
      answer: data["answer"],
      answerFormat: data["answer_format"],
      challengeId: data["challenge_id"],
      detailAnswer: data["detail_answer"],
      fileType: data["file_type"],
      id: data["id"],
      judgeStatus: data["judge_status"],
      language: data["language"],
      questionId: data["question_id"],
      quizId: data["quiz_id"],
      score: data["score"],
      sourceCode: data["source_code"],
      status: data["status"],
      statusMsg: data["status_msg"],
      submittedAt: data["submitted_at"],
      userAvatar: data["user_avatar"],
      userEmail: data["user_email"],
      userId: data["user_id"],
      userName: data["user_name"],
    );
  }
}
