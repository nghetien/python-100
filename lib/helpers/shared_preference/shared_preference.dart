import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();

  static final SharedPreferenceHelper _singleton = SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<void> saveUserAccessToken(String userToken) async {
    (await SharedPreferences.getInstance()).setString($USER_TOKEN, userToken);
  }

  Future<void> clearUserAccessToken() async {
    (await SharedPreferences.getInstance()).remove($USER_TOKEN);
  }

  Future<String?> getUserAccessToken() async {
    final String? accessToken = (await SharedPreferences.getInstance()).getString($USER_TOKEN);
    if (accessToken != null) {
      return accessToken;
    }
    return null;
  }

  Future<String?> getLocaleDefault() async {
    String? languageCode = (await SharedPreferences.getInstance()).getString($LANGUAGE);
    if (languageCode != null) {
      return languageCode;
    }
    return null;
  }

  Future<void> saveLocaleDefault(String language) async {
    (await SharedPreferences.getInstance()).setString($LANGUAGE, language);
  }

  Future<String?> getThemeDefault() async {
    String? getTheme = (await SharedPreferences.getInstance()).getString($THEME);
    if (getTheme != null) {
      return getTheme;
    }
    return null;
  }

  Future<void> saveThemeDefault(String theme) async {
    (await SharedPreferences.getInstance()).setString($THEME, theme);
  }
}
