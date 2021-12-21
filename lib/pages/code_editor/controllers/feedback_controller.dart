import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/models.dart';
import '../../lesson_details/models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';

class FeedbackController extends GetxController {
  /// init
  final BuildContext myContext;
  final QuestionData questionData;
  final int? courseId;
  final int? lessonId;


  FeedbackController({
    required this.myContext,
    required this.questionData,
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

  Future<void> fetchFeedbackSubmission() async {
    DataResponse res = await getFeedbackSubmissionResponse({
      "course_id": courseId.toString(),
      "lesson_item_id": lessonId.toString(),
      "question_id": questionData.id.toString(),
      "page": "1",
      "pageSize": "10",
    });
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
    DataResponse res = await getFeedbackSubmissionResponse({
      "course_id": courseId.toString(),
      "lesson_item_id": lessonId.toString(),
      "question_id": questionData.id.toString(),
      "page": "1",
      "pageSize": "10",
    });
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
    DataResponse res = await getFeedbackSubmissionResponse({
      "course_id": courseId.toString(),
      "lesson_item_id": lessonId.toString(),
      "question_id": questionData.id.toString(),
      "page": (page.value + 1).toString(),
      "pageSize": "10",
    });
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
    DataResponse res = await feedbackSubmissionResponse({
      "course_id": courseId.toString(),
      "lesson_item_id": lessonId,
      "content": value,
      "content_format": "plaintext",
      "question_id": questionData.id,
      "type": type,
    });
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
