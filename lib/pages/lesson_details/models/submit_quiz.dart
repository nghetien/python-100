class SubmitQuiz {
  final List<Map<String, dynamic>> listAnswers;
  final bool draft;
  final int? submissionId;
  final String? joinKey;

  const SubmitQuiz({
    required this.listAnswers,
    required this.draft,
    this.submissionId,
    this.joinKey,
  });

  Map<String, dynamic> convertToJSONStart(){
    return {
      "list_answers": listAnswers,
      "draft": draft,
      "join_key": joinKey,
    };
  }

  Map<String, dynamic> convertToJSONSubmit(){
    return {
      "list_answers": listAnswers,
      "draft": draft,
      "submission_id": submissionId,
    };
  }

  Map<String, dynamic> jSONSubmitInteraction(){
    return {
      "list_answers": listAnswers,
      "draft": draft,
    };
  }
}
