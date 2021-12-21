import '../services.dart';

Future<DataResponse> deleteCommentResponse(int idComment) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$delete("${$feedbackSubmissionAPIURL}/$idComment", {});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

// Future<DataResponse> deleteSnippetResponse(String idSnippet) async {
//   DataResponse dataResponse = DataResponse();
//   RequestApi requestApi = RequestApi();
//   try {
//     dataResponse =
//     await requestApi.$delete("${$ucodeGetSnippet}$idSnippet",{});
//     return dataResponse;
//   } catch (e) {
//     dataResponse.setResponseErrorData(e.toString());
//     return dataResponse;
//   }
// }
//
// Future<DataResponse> deleteMyContestResponse(String idMyContest) async {
//   DataResponse dataResponse = DataResponse();
//   RequestApi requestApi = RequestApi();
//   try {
//     dataResponse =
//     await requestApi.$delete("${$lessonItem}$idMyContest",{});
//     return dataResponse;
//   } catch (e) {
//     dataResponse.setResponseErrorData(e.toString());
//     return dataResponse;
//   }
// }
