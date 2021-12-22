import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../states/states.dart';
import '../../../../models/models.dart';
import '../models/models.dart';
import '../../lesson_details/models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';

class HistorySubmissionController extends GetxController {
  /// init
  final BuildContext myContext;
  final QuestionData questionData;
  final int? quizId;

  HistorySubmissionController({
    required this.myContext,
    required this.questionData,
    this.quizId,
  });

  /// -----------------------------------------------------------------------
  /// history
  RxInt page = RxInt(1);
  RxInt maxPage = RxInt(2);
  RxBool isLoadMore = RxBool(false);
  RxBool isLoadData = RxBool(true);
  RxString languageID = RxString("");
  RxList<HistorySubmission> listHistorySubmission = RxList<HistorySubmission>([]);

  Rx<Submission> currentHistorySubmission = Rx<Submission>(Submission.empty);
  RxList<TestCase> listTestCase = RxList<TestCase>([]);

  Future<void> getResultSubmission(int idSubmission) async {
    DataResponse getResult = await getSubmissionJudgeResultResponse(idSubmission.toString());
    if (getResult.status) {
      SubmissionCodeResult submissionCodeResult =
          SubmissionCodeResult.createASubmissionCodeResultFromJSON(getResult.data["data"]);
      listTestCase.value = submissionCodeResult.testcases;
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> getInfoSubmission(int idSubmission) async {
    DataResponse res = await getInfoSubmissionResponse(idSubmission);
    if (res.status) {
      currentHistorySubmission.value = Submission.createASubmissions(res.data["data"][0]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  void handleChangeFilter(String language) {
    languageID.value = language;
  }

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchHistorySubmission();
    });
  }

  Future<void> fetchHistorySubmission() async {
    final currentUser = myContext.read<AuthState>().getUserModel;
    DataResponse res = await getHistorySubmissionResponse(questionData.id, {
      "page": "1",
      "pageSize": "10",
      "quiz_id": quizId.toString(),
      "user_id": currentUser.id.toString(),
      "language": languageID.value,
    });
    if (res.status) {
      page.value = res.metaData!["current_page"];
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listHistorySubmission.value = HistorySubmission.createListHistorySubmission(res.data["data"]);
      isLoadData.value = false; // Tắt trạng thái load
    } else {
      isLoadData.value = true;
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> reloadHistorySubmission(int userId) async {
    languageID.value = "";
    DataResponse res = await getHistorySubmissionResponse(questionData.id, {
      "page": "1",
      "pageSize": "10",
      "quiz_id": quizId.toString(),
      "user_id": userId.toString(),
      "language": "",
    });
    if (res.status) {
      page.value = res.metaData!["current_page"];
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listHistorySubmission.value = HistorySubmission.createListHistorySubmission(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> loadMoreHistorySubmission() async {
    final User currentUser = myContext.read<AuthState>().getUserModel;
    if (isLoadMore.value) {
      return;
    }
    isLoadMore.value = true;
    DataResponse res = await getHistorySubmissionResponse(questionData.id, {
      "page": (page.value + 1).toString(),
      "pageSize": "10",
      "quiz_id": quizId != null ? quizId.toString() : "",
      "user_id": currentUser.id.toString(),
      "language": languageID.value.toString(),
    });
    if (res.status) {
      page.value += 1;
      listHistorySubmission.value = [
        ...listHistorySubmission,
        ...HistorySubmission.createListHistorySubmission(res.data["data"])
      ];
      isLoadMore.value = false;
    }
  }

  /// -----------------------------------------------------------------------

}
