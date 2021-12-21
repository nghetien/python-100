import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../constants/constants.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../../services/services.dart';
import '../../../../../states/states.dart';
import '../../../../../widgets/widgets.dart';

class LoginController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  var errorEmail = RxString("");
  var errorPassword = RxString("");
  final BuildContext myContext;
  final AuthState authState;

  LoginController({required this.myContext, required this.authState});

  bool checkErrorEmail(String email){
    errorEmail.value = Validators.checkValidEmail(email);
    return errorEmail.isEmpty;
  }

  bool checkErrorPassword(String password){
    errorPassword.value = Validators.checkValidPassword(password);
    return errorPassword.isEmpty;
  }

  login({required String email, required String password}) async {
    if(checkErrorEmail(email) && checkErrorPassword(password)){
      _loader.showLoader(myContext);
      DataResponse loginRes = await authState.loginEmail(email, password);
      if(!loginRes.status) {
        if(loginRes.code.toString() == "401"){
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.bad_username_password, backgroundColor: $errorColor);
        }else{
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.login_fail, backgroundColor: $errorColor);
        }
      }
      _loader.hideLoader();
    }
  }

  loginGoogle() async {
    _loader.showLoader(myContext);
    DataResponse loginGoogleRes = await authState.loginGoogle();
    if(!loginGoogleRes.status) {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.login_fail, backgroundColor: $errorColor);
    }
    _loader.hideLoader();
  }

}