import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../constants/constants.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../../services/services.dart';
import '../../../../../states/states.dart';
import '../../../../../widgets/widgets.dart';

class RegisterController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  var errorEmail = RxString("");
  var errorPassword = RxString("");
  var errorConfirmPassword = RxString("");
  final BuildContext myContext;
  final AuthState authState;

  RegisterController({required this.myContext, required this.authState});

  bool checkErrorEmail(String email) {
    errorEmail.value = Validators.checkValidEmail(email);
    return errorEmail.isEmpty;
  }

  bool checkErrorPassword(String password) {
    errorPassword.value = Validators.checkValidPassword(password);
    return errorPassword.isEmpty;
  }

  bool checkErrorConfirmPassword(String password, String confirmPassword) {
    errorConfirmPassword.value = password != confirmPassword ? $NOT_EQUAL : "";
    return password == confirmPassword;
  }

  register({
    required String email,
    required String password,
    required String confirmPassword,
    String? affiliateCode,
  }) async {
    if (checkErrorEmail(email) &&
        checkErrorPassword(password) &&
        checkErrorConfirmPassword(password, confirmPassword)) {
      _loader.showLoader(myContext);
      DataResponse registerRes = await authState.registerEmail(email, password, affiliateCode);
      if (registerRes.status) {
        Navigator.pop(myContext);
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.register_success, backgroundColor: $green500);
      } else {
        if (registerRes.code.toString() == "412") {
          showSnackBar(myContext,
              message: AppLocalizations.of(myContext)!.email_already_exist, backgroundColor: $errorColor);
        } else {
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.register_fail, backgroundColor: $errorColor);
        }
      }
      _loader.hideLoader();
    }
  }
}
