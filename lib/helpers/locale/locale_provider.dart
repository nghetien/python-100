import 'package:flutter/material.dart';
import '../helpers.dart';

class LocaleProvider extends ChangeNotifier{
  Locale _locale = const Locale('vi');

  Locale getCurrentLanguage(){
    return _locale;
  }

  void setDefaultLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Locale? get locale => _locale;

  void setLocale(Locale locale) async {
    if(!L10n.all.contains(locale)) return;
    _locale = locale;
    SharedPreferenceHelper().saveLocaleDefault(_locale.languageCode);
    notifyListeners();
  }
}