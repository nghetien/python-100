import '../services.dart';

Future<DataResponse> updateProfileUserResponse(
    Map<String, String> dataUser) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$put($updateProfileAPIUrl, dataUser);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> enrollCourseResponse(String courseId) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$put($enrollCourseAPIUrl(courseId), {});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> putFinishLessonItemResponse(String idLesson) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$put($finishLessonItemContestAPIUrl(idLesson), {"percent_complete": 100});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> changeSnippetResponse(int idSnippet,Map<String, dynamic> dataSnippet) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$put("${$snippetAPIUrl}$idSnippet", dataSnippet);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}