import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';

class FeedbackController extends GetxController {
  /// init
  final BuildContext myContext;
  final int? questionId;
  final int? courseId;
  final int? lessonId;


  FeedbackController({
    required this.myContext,
    this.questionId,
    this.courseId,
    this.lessonId,
  });

  /// -----------------------------------------------------------------------
  /// history
  RxInt page = RxInt(1);
  RxInt maxPage = RxInt(2);
  RxInt maxComment = RxInt(0);
  RxBool isLoadMore = RxBool(false);
  RxBool isLoadData = RxBool(true);

  RxList<Comment> listComment = RxList<Comment>([]);
  RxInt currentCommentId = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchFeedbackSubmission();
    });
  }

  Future<void> fetchFeedbackSubmission() async {
    Map<String, String> filters = {
      "page": "1",
      "pageSize": "10",
    };
    if(courseId != null) filters["course_id"] = courseId.toString();
    if(lessonId != null) filters["lesson_item_id"] = lessonId.toString();
    if(questionId != null) filters["question_id"] = questionId.toString();
    DataResponse res = await getFeedbackSubmissionResponse(filters);
    if (res.status) {
      page.value = res.metaData!["current_page"];
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listComment.value = Comment.createListComment(res.data["data"]);
      isLoadData.value = false; // Tắt trạng thái load
      maxComment.value = res.metaData!["total_items"];
    } else {
      isLoadData.value = true;
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> loadFeedbackSubmission() async {
    Map<String, String> filters = {
      "page": "1",
      "pageSize": "10",
    };
    if(courseId != null) filters["course_id"] = courseId.toString();
    if(lessonId != null) filters["lesson_item_id"] = lessonId.toString();
    if(questionId != null) filters["question_id"] = questionId.toString();
    DataResponse res = await getFeedbackSubmissionResponse(filters);
    if (res.status) {
      page.value = res.metaData!["current_page"];
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listComment.value = Comment.createListComment(res.data["data"]);
      maxComment.value = res.metaData!["total_items"];
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> loadMoreHistorySubmission() async {
    if (isLoadMore.value) {
      return;
    }
    isLoadMore.value = true;
    Map<String, String> filters = {
      "page": (page.value + 1).toString(),
      "pageSize": "10",
    };
    if(courseId != null) filters["course_id"] = courseId.toString();
    if(lessonId != null) filters["lesson_item_id"] = lessonId.toString();
    if(questionId != null) filters["question_id"] = questionId.toString();
    DataResponse res = await getFeedbackSubmissionResponse(filters);
    if (res.status) {
      maxComment.value = res.metaData!["total_items"];
      page.value += 1;
      listComment.value = [...listComment, ...Comment.createListComment(res.data["data"])];
      isLoadMore.value = false;
    }
  }

  Future<void> feedbackSubmission({
    required String value,
    required String type,
  }) async {
    Map<String, dynamic> formSubmit = {
      "content": value,
      "content_format": "plaintext",
      "type": type,
    };
    if(courseId != null) formSubmit["course_id"] = courseId.toString();
    if(lessonId != null) formSubmit["lesson_item_id"] = lessonId;
    if(questionId != null) formSubmit["question_id"] = questionId;
    DataResponse res = await feedbackSubmissionResponse(formSubmit);
    if (res.status) {
      fetchFeedbackSubmission();
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.feedback_fail, backgroundColor: $errorColor);
    }
  }

  void insertNewComment(Comment newComment) {
    listComment.insert(0, newComment);
  }

  Future<void> deleteAComment({required int idComment, int? idParent}) async {
    if (idParent != null) {
      for (int indexComment = 0; indexComment < listComment.length; indexComment++) {
        if (listComment[indexComment].id == idParent) {
          for (int indexReply = 0; indexReply < listComment[indexComment].replies!.length; indexReply++) {
            if (listComment[indexComment].replies![indexReply].id == idComment) {
              listComment[indexComment].replies!.removeAt(indexReply);
              break;
            }
          }
          break;
        }
      }
    } else {
      for (int indexComment = 0; indexComment < listComment.length; indexComment++) {
        if (listComment[indexComment].id == idComment) {
          listComment.removeAt(indexComment);
          break;
        }
      }
    }
    DataResponse res = await deleteCommentResponse(idComment);
    if (res.status) {
      fetchFeedbackSubmission();
    }
  }

  /// -----------------------------------------------------------------------

}
