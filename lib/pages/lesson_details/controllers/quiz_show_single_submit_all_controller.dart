import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';

class QuizShowSingleSubmitAllController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  final BuildContext myContext;

  /// Init
  final List<QuestionData> listQuestionData;

  /// State
  RxList<Map<String, dynamic>> listAnswer = RxList<Map<String, dynamic>>([]);

  QuizShowSingleSubmitAllController({
    required this.myContext,
    required this.listQuestionData,
  });

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
            "user_answer": "",
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

  void saveDaft(int? submissionId, int lessonId) {
    List<Map<String, dynamic>> listAnswers = [];
    for (var answer in listAnswer) {
      switch (answer["type"]) {
        case $singleChoice:
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": answer["user_answer"].toString(),
          });
          break;
        case $multipleChoice:
          List<String> resultMultipleChoice = [];
          if (answer["user_answer"].isNotEmpty) {
            for (int i = 0; i < answer["user_answer"].length; i++) {
              if (answer["user_answer"][i] == true) {
                resultMultipleChoice.add(i.toString());
              }
            }
          }
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": resultMultipleChoice.join(","),
          });
          break;
        case $fillIn:
          List<int> indexAnswer = answer["user_answer"].keys.toList()..sort();
          List<String> myFillInAnswer = [];
          for (int i = 0; i < indexAnswer.length; i++) {
            if (answer["user_answer"][indexAnswer[i]].isNotEmpty) {
              myFillInAnswer.add("x_$i::${answer["user_answer"][indexAnswer[i]]}");
            }
          }
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": myFillInAnswer.join("||"),
          });
          break;
        case $shortAnswer:
          listAnswers.add({
            "answer_format": "plaintext",
            "question_id": answer["question_id"],
            "user_answer": answer["user_answer"],
          });
          break;
        case $longAnswer:
          String userAnswer = "";
          String long = answer["user_answer"];
          if (long.length >= 12) {
            userAnswer = long.substring(12, long.length - 3);
          }
          listAnswers.add({
            "answer_format": "markdown",
            "question_id": answer["question_id"],
            "user_answer": userAnswer,
          });

          break;
      }
    }
    final SubmitQuiz myAnswer = SubmitQuiz(draft: true, listAnswers: listAnswers, submissionId: submissionId);
    submitQuizWithAnswerResponse(lessonId, myAnswer.convertToJSONSubmit());
  }

  Future<DataResponse> submitQuiz(int? submissionId, int lessonId) async {
    List<Map<String, dynamic>> listAnswers = [];
    for (var answer in listAnswer) {
      switch (answer["type"]) {
        case $singleChoice:
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": answer["user_answer"].toString(),
          });
          break;
        case $multipleChoice:
          List<String> resultMultipleChoice = [];
          if (answer["user_answer"].isNotEmpty) {
            for (int i = 0; i < answer["user_answer"].length; i++) {
              if (answer["user_answer"][i] == true) {
                resultMultipleChoice.add(i.toString());
              }
            }
          }
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": resultMultipleChoice.join(","),
          });
          break;
        case $fillIn:
          List<int> indexAnswer = answer["user_answer"].keys.toList()..sort();
          List<String> myFillInAnswer = [];
          for (int i = 0; i < indexAnswer.length; i++) {
            if (answer["user_answer"][indexAnswer[i]].isNotEmpty) {
              myFillInAnswer.add("x_$i::${answer["user_answer"][indexAnswer[i]]}");
            }
          }
          listAnswers.add({
            "question_id": answer["question_id"],
            "user_answer": myFillInAnswer.join("||"),
          });
          break;
        case $shortAnswer:
          listAnswers.add({
            "answer_format": "plaintext",
            "question_id": answer["question_id"],
            "user_answer": answer["user_answer"],
          });
          break;
        case $longAnswer:
          String userAnswer = "";
          String long = answer["user_answer"];
          if (long.length >= 12) {
            userAnswer = long.substring(12, long.length - 3);
          }
          listAnswers.add({
            "answer_format": "markdown",
            "question_id": answer["question_id"],
            "user_answer": userAnswer,
          });
          break;
      }
    }
    final SubmitQuiz myAnswer = SubmitQuiz(draft: false, listAnswers: listAnswers, submissionId: submissionId);
    _loader.showLoader(myContext);
    DataResponse res = await submitQuizWithAnswerResponse(lessonId, myAnswer.convertToJSONSubmit());
    if (res.status) {
      /// call kết quả
      if (res.data["data"]["submission_id"] != null) {
        DataResponse callResult = await getResultQuizResponse(res.data["data"]["submission_id"]);
        if (callResult.status) {
          while (callResult.status && callResult.data["data"]["status"] == $runningTest) {
            callResult = await getResultQuizResponse(res.data["data"]["submission_id"]);
          }
        } else {
          showSnackBar(myContext,
              message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
        }
      } else {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
      }
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.submission_fail, backgroundColor: $errorColor);
      res.setResponseErrorData(res.message);
    }
    _loader.hideLoader();
    return res;
  }
}
