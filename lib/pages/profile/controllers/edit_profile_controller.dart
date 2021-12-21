import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../states/states.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../../../models/models.dart';
import '../../pages.dart';

class EditProfileController extends GetxController {
  late final BuildContext myContext;
  late final AuthState authState;
  final CustomLoader _loader = CustomLoader();

  late Rx<Profile> myProfile;
  var errorFullName = RxString("");
  var errorPhoneNumber = RxString("");

  EditProfileController({required BuildContext context, required AuthState auth}) {
    final User myUser = auth.getUserModel;
    myContext = context;
    authState = auth;
    myProfile = Rx<Profile>(Profile(
      fullName: myUser.fullName ?? "",
      gender: myUser.gender ?? "",
      dob: myUser.dob ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      phoneNumber: myUser.phoneNumber ?? "",
      addressLine: myUser.addressLine ?? "",
      addressLine2: myUser.addressLine2 ?? "",
      avatar: myUser.avatar ?? "",
      parentEmail: myUser.parentEmail ?? "",
      school: myUser.school ?? "",
      clazz: myUser.clazz ?? "",
    ));
  }

  bool isError(){
    return errorFullName.isEmpty && errorPhoneNumber.isEmpty;
  }

  void handleChangeValueFullName(String myName){
    myProfile.value = myProfile.value.handleChangeProfile(fullNameChange: myName);
    errorFullName.value = Validators.checkEmpty(myName);
  }

  void handleChangeValuePhoneNumber(String myPhone){
    myProfile.value = myProfile.value.handleChangeProfile(phoneNumberChange: myPhone);
    errorPhoneNumber.value = Validators.checkEmpty(myPhone);
  }

  void handleChangeValueDOB(DateTime myDOB){
    myProfile.value = myProfile.value.handleChangeProfile(dobChange: (myDOB.millisecondsSinceEpoch ~/ 1000).toString());
  }

  void handleChangeValueGender(String myGender){
    myProfile.value = myProfile.value.handleChangeProfile(genderChange: myGender);
  }

  void handleChangeValueBonus({String? mySchool, String? myClazz, String? myAddress, String? myAddress2, String? myParentEmail}){
    myProfile.value = myProfile.value.handleChangeProfile(
      schoolChange: mySchool,
      clazzChange: myClazz,
      addressLineChange: myAddress,
      addressLine2Change: myAddress2,
      parentEmailChange: myParentEmail,
    );
  }

  Future<void> changeProfile() async {
    _loader.showLoader(myContext);
    try{
      DataResponse res = await updateProfileUserResponse(myProfile.value.getJSON);
      if (res.status) {
        await authState.reloadInfoUser();
        Navigator.pop(myContext);
      } else {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
      }
      _loader.hideLoader();
    }catch (e){
      _loader.hideLoader();
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
    }
  }
}
