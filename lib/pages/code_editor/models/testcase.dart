class TestCase {
  final String? actualOutput;
  final String? compileOutput;
  final String? correctOutput;
  final String? input;
  final bool isSample;
  final String? judgeMessage;
  final int judgeStatus;
  final String judgeStatusDescription;
  final int order;
  final int score;
  final String status;
  final String? statusMsg;
  final int testcaseId;

  const TestCase({
    this.actualOutput,
    this.compileOutput,
    this.correctOutput,
    this.input,
    required this.isSample,
    this.judgeMessage,
    required this.judgeStatus,
    required this.judgeStatusDescription,
    required this.order,
    required this.score,
    required this.status,
    this.statusMsg,
    required this.testcaseId,
  });

  static TestCase createATestCaseFromJSON(Map<String, dynamic> data){
    return TestCase(
      actualOutput: data["actual_output"],
      compileOutput: data["compile_output"],
      correctOutput: data["correct_output"],
      input: data["input"],
      isSample: data["is_sample"],
      judgeMessage: data["judge_message"],
      judgeStatus: data["judge_status"],
      judgeStatusDescription: data["judge_status_description"],
      order: data["order"],
      score: data["score"],
      status: data["status"],
      statusMsg: data["status_msg"],
      testcaseId: data["testcase_id"],
    );
  }
}
