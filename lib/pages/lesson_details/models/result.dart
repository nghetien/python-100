class Result {
  final int submissionId;
  final int quizId;
  final int createdAt;
  final int submittedAt;
  final int totalTime;
  final String status;
  final int score;
  final int uCoin;
  final int numPassed;
  final int numFailed;
  final int numWaitingJudge;
  final int numQuestions;
  final int quizScore;

  const Result({
    required this.submissionId,
    required this.quizId,
    required this.createdAt,
    required this.submittedAt,
    required this.totalTime,
    required this.status,
    required this.score,
    required this.uCoin,
    required this.numPassed,
    required this.numFailed,
    required this.numWaitingJudge,
    required this.numQuestions,
    required this.quizScore,
  });

  static Result createAResultFromJSON(Map<String, dynamic> dataJSON) {
    return Result(
        createdAt: dataJSON["created_at"] ?? 0,
        numFailed: dataJSON["num_failed"] ?? 0,
        numPassed: dataJSON["num_passed"] ?? 0,
        numQuestions: dataJSON["num_questions"] ?? 0,
        numWaitingJudge: dataJSON["num_waiting_judge"] ?? 0,
        quizId: dataJSON["quiz_id"] ?? 0,
        quizScore: dataJSON["quiz_score"] ?? 0,
        score: dataJSON["score"] ?? 0,
        status: dataJSON["status"] ?? "",
        submissionId: dataJSON["submission_id"] ?? 0,
        submittedAt: dataJSON["submitted_at"] ?? 0,
        totalTime: dataJSON["total_time"] ?? 0,
        uCoin: dataJSON["ucoin"] ?? 0,
    );
  }
}
