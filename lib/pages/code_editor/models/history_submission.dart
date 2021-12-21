class HistorySubmission {
  final int? challengeId;
  final int id;
  final String? judgeStatus;
  final String language;
  final int questionId;
  final int quizId;
  final double score;
  final String status;
  final String? statusMsg;
  final int submittedAt;
  final String? userAvatar;
  final String userEmail;
  final int userId;
  final String? userName;

  const HistorySubmission({
    this.challengeId,
    required this.id,
    this.judgeStatus,
    required this.language,
    required this.questionId,
    required this.quizId,
    required this.score,
    required this.status,
    this.statusMsg,
    required this.submittedAt,
    this.userAvatar,
    required this.userEmail,
    required this.userId,
    this.userName,
  });

  static List<HistorySubmission> createListHistorySubmission(List<dynamic> listDataJSON) {
    List<HistorySubmission> listItem = [];
    if (listDataJSON.isNotEmpty) {
      listItem = listDataJSON
          .map<HistorySubmission>((item) => HistorySubmission(
                challengeId: item["challenge_id"],
                id: item["id"],
                judgeStatus: item["judge_status"],
                language: item["language"],
                questionId: item["question_id"],
                quizId: item["quiz_id"],
                score: item["score"],
                status: item["status"],
                statusMsg: item["status_msg"],
                submittedAt: item["submitted_at"],
                userAvatar: item["user_avatar"],
                userEmail: item["user_email"],
                userId: item["user_id"],
                userName: item["user_name"],
              ))
          .toList();
      return listItem;
    } else {
      return listItem;
    }
  }
}
