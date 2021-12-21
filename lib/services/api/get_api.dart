import '../services.dart';

Future<DataResponse> getDataHomePage() async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($dataHomeAPIUrl);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getInfoUserResponse() async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  dataResponse = await requestApi.$get($getInfoUserAPIUrl);
  return dataResponse;
}

Future<DataResponse> getProblemResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($problemsAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getCoursesResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($coursesAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getInfoCourseResponse(String idCourse) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$coursesAPIUrl}/$idCourse");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getCurriculumCourseResponse(String idCourse) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($courseItemAPIUrl(idCourse));
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getTagsResponse(String type) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($tagsAPIUrl, mapQuery: {"type": type});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getCategoriesResponse(String type) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($categoryAPIUrl, mapQuery: {"category_type": type});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getBlogsResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($blogsAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getDataLessonResponse(String idLesson) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$lessonItemAPIUrl}$idLesson");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getDataLessonQuestionResponse(String idLesson) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($lessonItemQuizAPIUrl(idLesson));
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> transactionCourseDetailResponse(String vnPayRef) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$transactionCourseDetailAPIUrl}$vnPayRef");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getResultQuizResponse(int submissionId) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($resultQuizAPIUrl(submissionId.toString()));
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getCoursesEnrolledResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($coursesEnrolledAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getMyAffiliateResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($myAffiliateAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getDetailAffiliateAccount(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($affiliateDetailAccountAPIUrl, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getStatusTransactionResponse() async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($checkStatusTransactionAPIUrl);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getSnippetJudgeLanguageResponse() async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($snippetJudgeLanguageAPIUrl);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getSubmissionJudgeTokenResponse(String token) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$snippetJudgeSubmission}/$token");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getSubmissionJudgeResultResponse(String submissionId) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($runTestResultAPIUrl(submissionId));
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getHistorySubmissionResponse(int questionId, Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($historySubmissionAPIUrl(questionId.toString()), mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getInfoSubmissionResponse(int idSubmission) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$infoSubmissionAPIURL}$idSubmission");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getFeedbackSubmissionResponse(Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($feedbackSubmissionAPIURL, mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getReplyFeedbackResponse(int idReply, Map<String, dynamic> dataFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($replyFeedbackAPIURL(idReply.toString()), mapQuery: dataFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getSnippetResponse(Map<String, dynamic> dataSnippetFilters) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get($snippetAPIUrl, mapQuery: dataSnippetFilters);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> getSnippetDetailResponse(String slug) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$get("${$snippetAPIUrl}$slug");
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}
