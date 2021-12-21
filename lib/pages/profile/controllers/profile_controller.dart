import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../states/states.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';
import '../../../../models/models.dart';
import '../../pages.dart';

class ProfileController extends GetxController {
  late final BuildContext myContext;
  late final AuthState authState;

  Rx<File> avatarState = Rx<File>(File($EMPTY));
  late RxString currentLocation;

  final CustomLoader _loader = CustomLoader();

  ProfileController({required BuildContext context, required AuthState auth}){
    final User myUser = auth.getUserModel;
    myContext = context;
    authState = auth;
    currentLocation = RxString(myUser.avatar == null || myUser.avatar!.isEmpty ? $asset : $network);
  }

  void setFileAvatar(File myFileAvatar){
    currentLocation.value = $file;
    avatarState.value = myFileAvatar;
  }

  Future<void> changeAvatar() async {
    _loader.showLoader(myContext);
    try{
      if(avatarState.value.path != $EMPTY){
        DataResponse uploadImage = await upLoadImageResponse(avatarState.value, "avatar");
        if(uploadImage.status && uploadImage.data["data"].isNotEmpty){
          Profile myProfile = Profile.emptyProfile;
          myProfile = myProfile.handleChangeProfile(avatarChange: uploadImage.data["data"]);
          DataResponse res = await updateProfileUserResponse(myProfile.getJSONAvatar);
          if (res.status) {
            await authState.reloadInfoUser();
            avatarState.value = File($EMPTY);
            currentLocation.value = $network;
            showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_success, backgroundColor: $primaryColor);
          } else {
            showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
          }
        }else{
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
        }
      }else{
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
      }
      _loader.hideLoader();
    }catch (e){
      _loader.hideLoader();
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.edit_fail, backgroundColor: $errorColor);
    }
  }
}