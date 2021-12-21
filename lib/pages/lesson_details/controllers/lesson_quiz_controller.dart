import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../pages.dart';
import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';

class LessonQuizController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  final BuildContext myContext;

  /// init
  final bool isContest;

  /// state
  RxList<QuestionData> listQuestionData = RxList<QuestionData>([]);
  RxBool isReloadListQuestionData = RxBool(false);
  late final Rx<LessonData> lessonData;

  LessonQuizController({
    required this.myContext,
    required LessonData lessonData,
    required this.isContest,
  }){
    this.lessonData = Rx<LessonData>(lessonData);
  }

  @override
  void onInit() {
    WidgetsBinding.instance!.addPostFrameCallback(
          (_) {
        fetchQuestionData();
      },
    );
    super.onInit();
  }

  Future<void> fetchQuestionData() async {
    isReloadListQuestionData.value = false;
    DataResponse res = await getDataLessonQuestionResponse(lessonData.value.id.toString());
    if (res.status) {
      listQuestionData.value = QuestionData.createListQuizDataFromJSON(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
    isReloadListQuestionData.value = true;
  }

  Future<void> reloadQuestionData() async {
    DataResponse res = await getDataLessonQuestionResponse(lessonData.value.id.toString());
    if (res.status) {
      listQuestionData.value = QuestionData.createListQuizDataFromJSON(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> reloadLessonData() async {
    DataResponse res = await getDataLessonResponse(lessonData.value.id.toString());
    if (res.status) {
      lessonData.value = LessonData.createALessonDataFromJson(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> startQuiz() async {
    _loader.showLoader(myContext);
    SubmitQuiz emptySubmit = const SubmitQuiz(draft: true, listAnswers: []);
    DataResponse res = await submitQuizResponse(lessonData.value.id, emptySubmit.convertToJSONStart());
    _loader.hideLoader();
    if (res.status) {
      await reloadLessonData();
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.submission_fail, backgroundColor: $errorColor);
    }
  }
}
