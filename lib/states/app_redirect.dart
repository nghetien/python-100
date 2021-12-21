import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class AppRedirect extends ChangeNotifier {
  String _pageIndex = UrlRoutes.$home;
  String get pageIndex {
    return _pageIndex;
  }

  set setPageIndex(String pageIndex) {
    _pageIndex = pageIndex;
    notifyListeners();
  }
}
