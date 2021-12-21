import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'data_response.dart';

import '../constants/constants.dart';

class RequestApi {
  static Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Referer': 'https://uschool.vn/',
  };

  static void setHeaderToken(String token) {
    headers["access-token"] = token;
  }

  static get getHeaderToken {
    return headers["access-token"];
  }

  DataResponse dataResponse = DataResponse();

  RequestApi();

  Future<DataResponse> $get(String url,
      {Map<String, dynamic>? mapQuery}) async {
    try {
      http.Response result;
      result = await http.get(Uri.https($domainAPI, url, mapQuery),
          headers: headers);
      dataResponse.setResponseData(jsonDecode(result.body));
      return dataResponse;
    } catch (e) {
      dataResponse.setResponseErrorData(e.toString());
      return dataResponse;
    }
  }

  Future<DataResponse> $post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? mapQuery}) async {
    try {
      http.Response result = await http.post(
        Uri.https($domainAPI, url, mapQuery),
        headers: headers,
        body: jsonEncode(body),);
      dataResponse.setResponseData(jsonDecode(result.body));
      return dataResponse;
    } catch (e) {
      dataResponse.setResponseErrorData(e.toString());
      return dataResponse;
    }
  }

  Future<DataResponse> $put(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? mapQuery}) async {
    try {
      http.Response result = await http.put(
          Uri.https($domainAPI, url, mapQuery),
          headers: headers,
          body: jsonEncode(body));
      dataResponse.setResponseData(jsonDecode(result.body));
      return dataResponse;
    } catch (e) {
      dataResponse.setResponseErrorData(e.toString());
      return dataResponse;
    }
  }

  dynamic $delete(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? mapQuery}) async {
    try {
      http.Response result = await http.delete(
          Uri.https($domainAPI, url, mapQuery),
          headers: headers,
          body: jsonEncode(body));
      dataResponse.setResponseData(jsonDecode(result.body));
      return dataResponse;
    } catch (e) {
      dataResponse.setResponseErrorData(e.toString());
      return dataResponse;
    }
  }

  Future<DataResponse> $postFile(String url, File file,
      {Map<String, dynamic>? mapQuery}) async {
    try {
      var uri = Uri.https($domainAPI, url, mapQuery);
      var request = http.MultipartRequest("POST", uri);
      var pic = await http.MultipartFile.fromPath("file", file.path);
      request.headers.addAll(headers);
      request.files.add(pic);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      dataResponse.setResponseData(jsonDecode(responseString));
      return dataResponse;
    } catch (e) {
      dataResponse.setResponseErrorData(e.toString());
      return dataResponse;
    }
  }
}
