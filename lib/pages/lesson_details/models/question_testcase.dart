class QuestionTestCase {
  final int? id;
  final String? name;
  final String? explanation;
  final int? questionId;
  final int? order;
  final bool? isSample;
  final int? score;
  final String? input;
  final String? output;
  final double? inputSize;
  final double? outputSize;
  final String? inputUrl;
  final String? outputUrl;

  const QuestionTestCase({
    this.id,
    this.name,
    this.explanation,
    this.questionId,
    this.order,
    this.isSample,
    this.score,
    this.input,
    this.output,
    this.inputSize,
    this.outputSize,
    this.inputUrl,
    this.outputUrl,
  });

  static List<QuestionTestCase> createListQuizTestCaseFromJSON(List<dynamic> listDataJSON) {
    List<QuestionTestCase> listItem = [];
    if (listDataJSON.isNotEmpty) {
      listItem = listDataJSON.map<QuestionTestCase>((item) => QuestionTestCase(
        id: item["id"],
        name: item["name"],
        explanation: item["explanation"],
        questionId: item["question_id"],
        order: item["order"],
        isSample: item["is_sample"],
        score: item["score"],
        input: item["input"],
        output: item["output"],
        inputSize: item["input_size"],
        outputSize: item["output_size"],
        inputUrl: item["input_url"],
        outputUrl: item["output_url"],
      )).toList();
      return listItem;
    } else {
      return listItem;
    }
  }
}
