import '../../pages.dart';

class SubmissionCodeResult {
  final String answerFormat;
  final int? challengeId;
  final String? correctAnswer;
  final String? fileType;
  final String? judgeStatus;
  final String language;
  final int questionId;
  final int questionScore;
  final int? quizId;
  final int score;
  final String status;
  final String? statusMsg;
  final int? submissionId;
  final List<TestCase> testcases;
  final int uCoin;
  final String? userAnswer;

  const SubmissionCodeResult({
    required this.answerFormat,
    this.challengeId,
    this.correctAnswer,
    this.fileType,
    this.judgeStatus,
    required this.language,
    required this.questionId,
    required this.questionScore,
    this.quizId,
    required this.score,
    required this.status,
    this.statusMsg,
    this.submissionId,
    required this.testcases,
    required this.uCoin,
    this.userAnswer,
  });

  static SubmissionCodeResult createASubmissionCodeResultFromJSON(Map<String, dynamic> data){
    List<TestCase> listTestCase = [];
    for(Map<String, dynamic> item in data["testcases"]){
      listTestCase.add(TestCase.createATestCaseFromJSON(item));
    }
    return SubmissionCodeResult(
      answerFormat: data["answer_format"],
      challengeId: data["challenge_id"],
      correctAnswer: data["correct_answer"],
      fileType: data["file_type"],
      judgeStatus: data["judge_status"],
      language: data["language"],
      questionId: data["question_id"],
      questionScore: data["question_score"],
      quizId: data["quiz_id"],
      score: data["score"],
      status: data["status"],
      statusMsg: data["status_msg"],
      submissionId: data["submission_id"],
      testcases: listTestCase,
      uCoin: data["ucoin"],
      userAnswer: data["user_answer"],
    );
  }
}
