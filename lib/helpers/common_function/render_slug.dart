String nonAccentVietnamese(String vietnamese) {
  vietnamese = vietnamese.toLowerCase();
  vietnamese =
      vietnamese.replaceAll(RegExp('à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'), "a");
  vietnamese = vietnamese.replaceAll(RegExp('è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'), "e");
  vietnamese = vietnamese.replaceAll(RegExp('ì|í|ị|ỉ|ĩ'), "i");
  vietnamese =
      vietnamese.replaceAll(RegExp('ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'), "o");
  vietnamese = vietnamese.replaceAll(RegExp('ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'), "u");
  vietnamese = vietnamese.replaceAll(RegExp('ỳ|ý|ỵ|ỷ|ỹ'), "y");
  vietnamese = vietnamese.replaceAll(RegExp('đ'), "d");
  vietnamese =
      vietnamese.replaceAll(RegExp('\u0300|\u0301|\u0303|\u0309|\u0323'), "");
  vietnamese = vietnamese.replaceAll(RegExp('\u02C6|\u0306|\u031B'), "");
  return vietnamese;
}

String renderSlug(String slug) {
  String newSlug = nonAccentVietnamese(slug);
  newSlug = newSlug.replaceAll(RegExp(r'[^a-z^A-Z^0-9^ ]+'), "");
  newSlug = newSlug.trim().replaceAll(RegExp('\\s+'), "-");
  return newSlug;
}