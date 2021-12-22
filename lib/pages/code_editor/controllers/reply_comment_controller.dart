import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';

class ReplyCommentController extends GetxController {
  /// init
  final BuildContext myContext;
  final int? questionId;
  final Comment parentComment;

  ReplyCommentController({
    required this.myContext,
    required this.questionId,
    required this.parentComment,
  });

  /// -----------------------------------------------------------------------
  /// history
  RxInt page = RxInt(1);
  RxInt maxPage = RxInt(2);
  RxBool isLoadMore = RxBool(false);

  RxList<Comment> listReply = RxList<Comment>([]);

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchListReply();
    });
  }

  Future<void> fetchListReply() async {
    DataResponse res = await getReplyFeedbackResponse(parentComment.id, {
      "page": "1",
      "pageSize": "10",
    });
    if (res.status) {
      page.value = res.metaData!["current_page"];
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listReply.value = [
        ...[parentComment],
        ...Comment.createListComment(res.data["data"])
      ];
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> loadMoreListReply() async {
    if (isLoadMore.value) {
      return;
    }
    isLoadMore.value = true;
    DataResponse res = await getReplyFeedbackResponse(parentComment.id, {
      "page": (page.value + 1).toString(),
      "pageSize": "10",
    });
    if (res.status) {
      page.value += 1;
      listReply.value = [...listReply, ...Comment.createListComment(res.data["data"])];
      isLoadMore.value = false;
    }
  }

  Future<void> feedbackSubmission({
    required String value,
    int? parentID,
    required String type,
  }) async {
    Map<String, dynamic> filters = {
      "content": value,
      "content_format": "plaintext",
      "type": type,
    };
    if (parentID != null) filters["parent_id"] = parentID;
    if (questionId != null) filters["question_id"] = questionId;
    DataResponse res = await feedbackSubmissionResponse(filters);
    if (res.status) {
      await fetchListReply();
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.feedback_fail, backgroundColor: $errorColor);
    }
  }

  void insertNewComment(Comment newComment) {
    listReply.insert(1, newComment);
  }

  Future<void> deleteAComment({required int idComment}) async {
    for (int indexReply = 0; indexReply < listReply.length; indexReply++) {
      if (listReply[indexReply].id == idComment) {
        listReply.removeAt(indexReply);
        break;
      }
    }
    DataResponse res = await deleteCommentResponse(idComment);
    if (res.status) {
      fetchListReply();
    }
  }

  /// -----------------------------------------------------------------------

}
