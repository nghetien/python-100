class DataResponse {
  int code = 0;
  Map<String, dynamic> data = <String, dynamic>{};
  Map<String, dynamic>? metaData = <String, dynamic>{};
  bool status = true;
  String message = "";

  DataResponse();

  void setResponseData(Map<String, dynamic> dataJson) {
    try{
      code = dataJson["error_code"] == 0 ? 200 : dataJson["error_code"];
      status = dataJson["success"];
      data["data"] = dataJson["data"];
      message = dataJson["message"].toString();
      metaData = dataJson["metadata"] ?? {};
    }catch(e){
      code = dataJson["error_code"] == 0 ? 200 : dataJson["error_code"];
      status = dataJson["success"];
      data["data"] = dataJson["data"];
      message = dataJson["message"].toString();
    }
  }

  void setResponseErrorData(String error){
    code = 403;
    status = false;
    data = <String, dynamic>{};
    message = error;
  }

  List<Object?> get props => [code, data, status, message, metaData];
}
