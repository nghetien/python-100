import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';

class QuizInteractionController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  final BuildContext myContext;
  final int? currentLessonId;
  final Map<String, dynamic> optionPosition;
  final QuestionData currentInteraction;

  /// Data State answer
  final RxString _stringAnswer = RxString("");

  QuizInteractionController({
    required this.myContext,
    required this.currentLessonId,
    required this.optionPosition,
    required this.currentInteraction,
  });

  Future<DataResponse> submitQuizInteraction() async {
    _loader.showLoader(myContext);
    DataResponse res = DataResponse();
    if (currentLessonId != null) {
      final SubmitQuiz myAnswer = SubmitQuiz(draft: false, listAnswers: [{
        "answer_format": "markdown",
        "question_id": currentInteraction.id.toString(),
        "quiz_id": currentLessonId.toString(),
        "user_answer": _stringAnswer.value,
      }]);
      res = await submitQuestionResponse(myAnswer.jSONSubmitInteraction());
      if (!res.status) {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.submission_fail, backgroundColor: $errorColor);
        res.setResponseErrorData(res.message);
      }
    }else{
      res.setResponseErrorData("");
    }
    _loader.hideLoader();
    return res;
  }

  void changeAnswerMultiChoice(List<bool> myListAnswer) {
    List<int> indexChoice = [];
    for(int i =0;i<myListAnswer.length; i++){
      if(myListAnswer[i]){
        indexChoice.add(i);
      }
    }
    _stringAnswer.value = indexChoice.join(",");
  }

  void changeAnswerFullIn(List<TextEditingController> myListAnswer) {
    List<String> listFillIn = [];
    for(TextEditingController item in myListAnswer){
      listFillIn.add(item.text);
    }
    _stringAnswer.value = listFillIn.join("||");
  }

  void changeAnswerSingleChoice(int answer) {
    _stringAnswer.value = answer.toString();
  }
}
