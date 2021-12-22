import 'dart:io';
import '../services.dart';

Future<DataResponse> loginEmailResponse(String email, String password) async {
  try {
    RequestApi requestApi = RequestApi();
    return await requestApi.$post($signInAPIUrl, {"email": email, "password": password});
  } catch (e) {
    DataResponse dataResponse = DataResponse();
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> loginWithGoogleResponse(String googleToken) async {
  RequestApi requestApi = RequestApi();
  try {
    return await requestApi.$post($signInAPIUrl, {
      "google_token": googleToken,
    });
  } catch (e) {
    DataResponse dataResponse = DataResponse();
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> signUpEmailResponse(String email, String password, String? affiliateCode) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($signUpAPIUrl, {"email": email, "password": password, "affiliate_code": affiliateCode ?? "",});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> upLoadImageResponse(File image, String folder) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$postFile($uploadImageAPIUrl, image, mapQuery: {"folder": folder});
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> upsertPasswordResponse(Map<String, String> dataUpsertPassword) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($upsertPasswordAPIUrl, dataUpsertPassword);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> transactionCourseResponse(Map<String, dynamic> dataMyTransaction) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($transactionAPIUrl, dataMyTransaction);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> submitQuizResponse(int lessonId ,Map<String, dynamic> dataSubmit) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($submitQuizAPIUrl(lessonId.toString()), dataSubmit);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> submitQuizWithAnswerResponse(int lessonId ,Map<String, dynamic> dataSubmit) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($submitQuizAPIUrl(lessonId.toString()), dataSubmit);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> submitQuestionResponse(Map<String, dynamic> dataSubmit) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($submitQuizWithAnswerAPIUrl, dataSubmit);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> createAffiliateCodeResponse(Map<String, dynamic> dataAffiliate) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($myAffiliateAPIUrl, dataAffiliate);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> submissionJudgeCodeResponse(Map<String, dynamic> data) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($snippetJudgeSubmission, data);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> submissionJudgeQuestionResponse(int questionId, Map<String, dynamic> data) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($runTestAPIUrl(questionId.toString()), data);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> feedbackSubmissionResponse(Map<String, dynamic> data) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($feedbackSubmissionAPIURL, data);
    return dataResponse;
  } catch (e) {

    print(">>>>> cc givay ");
    print(e.toString());

    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}

Future<DataResponse> createCodeSnippetResponse(Map<String, dynamic> dataSnippet) async {
  DataResponse dataResponse = DataResponse();
  RequestApi requestApi = RequestApi();
  try {
    dataResponse = await requestApi.$post($snippetAPIUrl, dataSnippet);
    return dataResponse;
  } catch (e) {
    dataResponse.setResponseErrorData(e.toString());
    return dataResponse;
  }
}