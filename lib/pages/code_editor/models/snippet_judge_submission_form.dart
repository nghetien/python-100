class SnippetJudgeSubmissionForm {
  final String languageId;
  final String sourceCode;
  final String inputData;
  final String expectedOutput;

  const SnippetJudgeSubmissionForm({
    required this.languageId,
    required this.sourceCode,
    required this.inputData,
    required this.expectedOutput,
  });

  Map<String, dynamic> convertToJSON(){
    Map<String, dynamic> data = {};
    data["language_id"] = languageId;
    data["source_code"] = sourceCode;
    data["input_data"] = inputData;
    data["expected_output"] = expectedOutput;
    return data;
  }
}
