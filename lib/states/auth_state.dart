import 'dart:io' show Cookie;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/constants.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthState extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User _user = User.empty;

  User get getUserModel => _user;

  Future<void> updateAuthState(String? accessToken) async {
    if (accessToken == null) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      notifyListeners();
    } else {
      RequestApi.setHeaderToken(accessToken);
      await loadInfoUser();
    }
  }

  Future<void> reloadInfoUser() async {
    DataResponse infoUser = await getInfoUserResponse();
    if (infoUser.status) {
      User user = createUser(infoUser.data);
      _user = user;
      notifyListeners();
    }
  }

  Future<DataResponse> loadInfoUser() async {
    try {
      DataResponse infoUser = await getInfoUserResponse();
      if (infoUser.status) {
        User user = createUser(infoUser.data);
        _user = user;
        authStatus = AuthStatus.LOGGED_IN;
        // lưu vào đăng nhập vào máy
        await SharedPreferenceHelper().saveUserAccessToken(RequestApi.getHeaderToken);
        // // -------------------------
        // // set cookie trên webview
        final cookieManager = WebviewCookieManager();
        await cookieManager.setCookies([
          Cookie($uToken, RequestApi.getHeaderToken)
            ..domain = "$getDomain$getReference.vn"
            ..expires = DateTime.now().add(const Duration(days: 30))
            ..httpOnly = false
        ]);
        // // -------------------------
      } else {
        infoUser.setResponseErrorData(infoUser.message);
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      notifyListeners();
      return infoUser;
    } catch (e) {
      DataResponse dataError = DataResponse();
      dataError.setResponseErrorData(e.toString());
      notifyListeners();
      return dataError;
    }
  }

  Future<DataResponse> loginEmail(String email, String password) async {
    try {
      DataResponse dataSignInResponse = await loginEmailResponse(email, password);
      if (dataSignInResponse.status) {
        RequestApi.setHeaderToken(dataSignInResponse.data["data"]);
      } else {
        return dataSignInResponse;
      }
      return await loadInfoUser();
    } catch (e) {
      DataResponse dataSignInResponse = DataResponse();
      dataSignInResponse.setResponseErrorData(e.toString());
      return dataSignInResponse;
    }
  }

  Future<DataResponse> loginGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      DataResponse dataSignInResponse = await loginWithGoogleResponse('${googleAuth!.idToken}');
      if (dataSignInResponse.status) {
        RequestApi.setHeaderToken(dataSignInResponse.data["data"]);
      } else {
        return dataSignInResponse;
      }
      return await loadInfoUser();
    } catch (e) {
      DataResponse dataSignInResponse = DataResponse();
      dataSignInResponse.setResponseErrorData(e.toString());
      return dataSignInResponse;
    }
  }

  Future<DataResponse> registerEmail(String email, String password, String? affiliateCode) async {
    try {
      DataResponse dataSignUpResponse = await signUpEmailResponse(email, password, affiliateCode);
      return dataSignUpResponse;
    } catch (e) {
      DataResponse dataSignUpResponse = DataResponse();
      dataSignUpResponse.setResponseErrorData(e.toString());
      return dataSignUpResponse;
    }
  }

  Future<void> logOut() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    _user = User.empty;
    await _googleSignIn.signOut();
    final cookieManager = WebviewCookieManager();
    await cookieManager.removeCookie($urlWebViewHome);
    await cookieManager.clearCookies();
    await SharedPreferenceHelper().clearUserAccessToken();
    notifyListeners();
  }

  User createUser(Map<String, dynamic> dataResponse) {
    return User(
      id: dataResponse["data"]['id'] ?? 0,
      tenantId: dataResponse["data"]['tenant_id'] ?? 0,
      email: dataResponse["data"]['email'],
      fullName: dataResponse["data"]['full_name'],
      gender: dataResponse["data"]['gender'],
      dob: dataResponse["data"]['dob'],
      type: dataResponse["data"]['type'] ?? "",
      status: dataResponse["data"]['status'] ?? "",
      emailVerified: dataResponse["data"]['email_verified'] ?? false,
      addressLine: dataResponse["data"]['address_line'],
      addressLine2: dataResponse["data"]['address_line_2'],
      phoneNumber: dataResponse["data"]['phone_number'],
      phoneVerified: dataResponse["data"]['phone_verified'] ?? false,
      avatar: dataResponse["data"]['avatar'],
      role: dataResponse["data"]['role'],
      parentEmail: dataResponse["data"]['parent_email'],
      parentId: dataResponse["data"]['parent_id'],
      referralToken: dataResponse["data"]['referral_token'],
      apiKey: dataResponse["data"]['api_key'],
      apiKeyExpired: dataResponse["data"]['api_key_expired'],
      provinceCode: dataResponse["data"]['province_code'],
      provinceName: dataResponse["data"]['province_name'],
      school: dataResponse["data"]['school'],
      clazz: dataResponse["data"]['clazz'],
      numNotifications: dataResponse["data"]['num_notifications'] ?? 0,
      totalUcoin: dataResponse["data"]['total_ucoin'] ?? 0,
      currentExpLevel: dataResponse["data"]['current_exp_level'],
      totalExp: dataResponse["data"]['total_exp'] ?? 0,
      nextExpLevelStart: dataResponse["data"]['next_exp_level_start'],
      currentExpLevelStart: dataResponse["data"]['current_exp_level_start'],
      lastLogin: dataResponse["data"]['last_login'],
      isHasPassword: dataResponse["data"]['is_has_password'] ?? false,
      userTypeSet: dataResponse["data"]['user_type_set'] ?? false,
    );
  }
}
