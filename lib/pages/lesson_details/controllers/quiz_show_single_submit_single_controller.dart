import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';

class QuizShowSingleSubmitSingleController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  final BuildContext myContext;

  /// Init
  final List<QuestionData> listQuestionData;

  /// State
  RxList<Map<String, dynamic>> listAnswer = RxList<Map<String, dynamic>>([]);

  QuizShowSingleSubmitSingleController({
    required this.myContext,
    required this.listQuestionData,
  });

  @override
  void onInit() {
    addQuestion();
    super.onInit();
  }

  void addQuestion() {
    List<Map<String, dynamic>> tempListAnswer = [];
    for (var element in listQuestionData) {
      switch (element.type) {
        case $code:
          tempListAnswer.add({
            "type": $code,
            "question_id": element.id,
            "user_answer": "",
          });
          break;
        case $singleChoice:
          tempListAnswer.add({
            "type": $singleChoice,
            "question_id": element.id,
            "user_answer": -1,
          });
          break;
        case $multipleChoice:
          List<bool> list = [];
          tempListAnswer.add({
            "type": $multipleChoice,
            "question_id": element.id,
            "user_answer": list,
          });
          break;
        case $fillIn:
          final Map<int, String> listFillIn = {};
          tempListAnswer.add({
            "type": $fillIn,
            "question_id": element.id,
            "user_answer": listFillIn,
          });
          break;
        case $shortAnswer:
          tempListAnswer.add({
            "type": $shortAnswer,
            "question_id": element.id,
            "user_answer": "",
          });
          break;
        case $longAnswer:
          tempListAnswer.add({
            "type": $longAnswer,
            "question_id": element.id,
            "user_answer": "",
          });
          break;
        case $theory:
          tempListAnswer.add({
            "type": $theory,
            "question_id": element.id,
            "user_answer": "",
          });
          break;
        default:
          tempListAnswer.add({
            "type": "",
            "question_id": element.id,
            "user_answer": "",
          });
          break;
      }
    }
    listAnswer.value = tempListAnswer;
  }

  void changeSingleChoice({required int index, required int indexAnswer}) {
    listAnswer[index]["user_answer"] = indexAnswer;
  }

  void changeMultiChoice({required int index, required List<bool> listIndexAnswer}) {
    listAnswer[index]["user_answer"] = listIndexAnswer;
  }

  void changeFillIn({required int index, required String value, required int indexAnswer}) {
    Map<int, String> listFillIn = listAnswer[index]["user_answer"];
    listFillIn[indexAnswer] = value;
    listAnswer[index]["user_answer"] = listFillIn;
  }

  void changeShortAnswer({required int index, required String value}) {
    listAnswer[index]["user_answer"] = value;
  }

  void changeLongAnswer({required int index, required String value}) {
    listAnswer[index]["user_answer"] = value;
  }

  Future<DataResponse> submitSingleQuiz({required int index, required int idLesson}) async {
    List<Map<String, dynamic>> listAnswers = [];
    switch (listAnswer[index]["type"]) {
      case $singleChoice:
        listAnswers.add({
          "answer_format": "markdown",
          "question_id": listAnswer[index]["question_id"],
          "quiz_id": idLesson.toString(),
          "user_answer": listAnswer[index]["user_answer"].toString(),
        });
        break;
      case $multipleChoice:
        List<String> resultMultipleChoice = [];
        if (listAnswer[index]["question_id"].isNotEmpty) {
          for (int i = 0; i < listAnswer[index]["question_id"].length; i++) {
            if (listAnswer[index]["question_id"][i] == true) {
              resultMultipleChoice.add(i.toString());
            }
          }
        }
        listAnswers.add({
          "answer_format": "markdown",
          "quiz_id": idLesson.toString(),
          "question_id": listAnswer[index]["question_id"],
          "user_answer": resultMultipleChoice.join(","),
        });
        break;
      case $fillIn:
        List<int> indexAnswer = listAnswer[index]["user_answer"].keys.toList()..sort();
        List<String> myFillInAnswer = [];
        for (int i = 0; i < indexAnswer.length; i++) {
          if (listAnswer[index]["user_answer"][indexAnswer[i]].isNotEmpty) {
            myFillInAnswer.add("x_$i::${listAnswer[index]["user_answer"][indexAnswer[i]]}");
          }
        }
        listAnswers.add({
          "answer_format": "markdown",
          "quiz_id": idLesson.toString(),
          "question_id": listAnswer[index]["question_id"],
          "user_answer": myFillInAnswer.join("||"),
        });
        break;
      case $shortAnswer:
        listAnswers.add({
          "answer_format": "markdown",
          "quiz_id": idLesson.toString(),
          "question_id": listAnswer[index]["question_id"],
          "user_answer": listAnswer[index]["user_answer"],
        });
        break;
      case $longAnswer:
        String userAnswer = "";
        String long = listAnswer[index]["user_answer"];
        if(long.length >= 12){
          userAnswer = long.substring(12, long.length-3);
        }
        listAnswers.add({
          "answer_format": "markdown",
          "quiz_id": idLesson.toString(),
          "question_id": listAnswer[index]["question_id"],
          "user_answer":  userAnswer,
        });

        break;
      case $theory:
        listAnswers.add({
          "answer_format": "markdown",
          "quiz_id": idLesson.toString(),
          "question_id": listAnswer[index]["question_id"],
          "user_answer": "",
        });
        break;
    }
    final SubmitQuiz myAnswer = SubmitQuiz(draft: false, listAnswers: listAnswers);
    _loader.showLoader(myContext);
    DataResponse res = await submitQuestionResponse(myAnswer.jSONSubmitInteraction());
    if (!res.status) {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.submission_fail, backgroundColor: $errorColor);
      res.setResponseErrorData(res.message);
    }
    _loader.hideLoader();
    return res;
  }
}
