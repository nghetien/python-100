import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';
import '../../../services/services.dart';
import '../../../helpers/helpers.dart';

class UpsertPasswordController extends GetxController {
  final BuildContext myContext;
  final AuthState authState;

  RxString errorOldPassword = RxString("");
  RxString errorNewPassword = RxString("");
  RxString errorNewConfirmPassword = RxString("");

  final CustomLoader _loader = CustomLoader();

  UpsertPasswordController({required this.myContext, required this.authState});

  bool checkErrorOldPassword(String password){
    errorOldPassword.value = Validators.checkValidPassword(password);
    return errorOldPassword.isEmpty;
  }

  bool checkErrorNewPassword(String password, String confirmPassword){
    errorNewPassword.value = Validators.checkValidPassword(password);
    errorNewConfirmPassword.value = password != confirmPassword ? $NOT_EQUAL : "";
    return errorNewPassword.isEmpty;
  }

  bool checkErrorConfirmNewPassword(String password, String confirmPassword){
    errorNewConfirmPassword.value = password != confirmPassword ? $NOT_EQUAL : "";
    return errorNewConfirmPassword.isEmpty;
  }

  upsertPassword({required String oldPassword, required String newPassword, required String confirmNewPassword}) async {
    if(checkErrorOldPassword(oldPassword) && checkErrorNewPassword(newPassword, confirmNewPassword) && checkErrorConfirmNewPassword(confirmNewPassword, newPassword)){
      _loader.showLoader(myContext);
      DataResponse res = await upsertPasswordResponse({
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmNewPassword,
      });
      if(res.status) {
        Navigator.popUntil(myContext, ModalRoute.withName(UrlRoutes.$splash));
        await authState.logOut();
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.change_password_success, backgroundColor: $primaryColor);
      }else{
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.change_password_fail, backgroundColor: $errorColor);
      }
      _loader.hideLoader();
    }
  }

}