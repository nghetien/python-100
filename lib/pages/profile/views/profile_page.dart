import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../constants/constants.dart';
import '../../../../layouts/layouts.dart';
import '../../../../states/states.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../../../models/models.dart';
import '../../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _profileController;

  @override
  void initState() {
    _profileController = Get.put(ProfileController(context: context, auth: context.read<AuthState>()));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProfileController>();
    super.dispose();
  }

  _onClickButtonLogout() async {
    AppRedirect appDirections = context.read<AppRedirect>();
    Navigator.popUntil(context, ModalRoute.withName(UrlRoutes.$splash));
    appDirections.setPageIndex = "/";
    await context.read<AuthState>().logOut();
  }

  _showLevel(int myLevel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: $primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "${AppLocalizations.of(context)!.level} ${truncateNumberToString(myLevel)}",
        style: const TextStyle(
          color: $whiteColor,
          fontFamily: "Lexend",
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: -0.02,
        ),
      ),
    );
  }

  _showEXP(int myEXP) {
    return Text(
      "${truncateNumberToString(myEXP)} EXP",
      style: TextStyle(
        color: $neutrals400,
        fontFamily: Theme.of(context).textTheme.subtitle2!.fontFamily,
        fontWeight: Theme.of(context).textTheme.subtitle2!.fontWeight,
        fontSize: Theme.of(context).textTheme.subtitle2!.fontSize,
        letterSpacing: Theme.of(context).textTheme.subtitle2!.letterSpacing,
      ),
    );
  }

  _showAccountType(String myType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: $green100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: $primaryColor),
      ),
      child: Text(
        myType == $student ? AppLocalizations.of(context)!.student : AppLocalizations.of(context)!.teacher,
        style: const TextStyle(
          color: $primaryColor,
          fontFamily: "Lexend",
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: -0.02,
        ),
      ),
    );
  }

  _changeAvatar() {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: size.width * 0.005,
      right: size.width * 0.005,
      child: InkWell(
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
            backgroundColor: Theme.of(context).backgroundColor,
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(18),
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    ButtonOutLineWithIcon(
                      widthBtn: double.infinity,
                      textBtn: AppLocalizations.of(context)!.open_camera,
                      onPressCallBack: () {
                        getImage(context, ImageSource.camera, (file) {
                          if (file.path != $EMPTY) {
                            _profileController.setFileAvatar(file);
                          }
                          Navigator.pop(context);
                        });
                      },
                      paddingBtn: const EdgeInsets.symmetric(vertical: 16),
                      radiusBtn: 16,
                      iconBtn: const Icon(Icons.photo_camera),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonOutLineWithIcon(
                      widthBtn: double.infinity,
                      textBtn: AppLocalizations.of(context)!.select_photo,
                      onPressCallBack: () {
                        getImage(context, ImageSource.gallery, (file) {
                          if (file.path != $EMPTY) {
                            _profileController.setFileAvatar(file);
                          }
                          Navigator.pop(context);
                        });
                      },
                      paddingBtn: const EdgeInsets.symmetric(vertical: 16),
                      radiusBtn: 16,
                      iconBtn: const Icon(Icons.photo),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: $green100,
            borderRadius: BorderRadius.circular(36),
          ),
          child: SvgPicture.asset($assetSVGEdit),
        ),
        focusColor: $green100,
      ),
    );
  }

  _header() {
    final User currentUser = context.watch<AuthState>().getUserModel;
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Stack(
            children: <Widget>[
              Obx(
                () => AvatarCircleImage(
                  typeImage: _profileController.currentLocation.value,
                  onClickImg: () {
                    if (_profileController.currentLocation.value == $file) {
                      Navigator.pushNamed(
                        context,
                        UrlRoutes.$fullImageFile,
                        arguments: FileFullImagePage(
                          fileImage: _profileController.avatarState.value,
                        ),
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        UrlRoutes.$fullImage,
                        arguments: NetworkFullImagePage(
                          urlAvatar: currentUser.avatar,
                        ),
                      );
                    }
                  },
                  urlImg: currentUser.avatar,
                  fileImage: _profileController.avatarState.value,
                  widthImg: size.width * 0.3,
                  heightImg: size.width * 0.3,
                  radiusImg: size.width * 0.155,
                ),
              ),
              _changeAvatar(),
            ],
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                currentUser.fullName ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                currentUser.email,
                style: Theme.of(context).textTheme.bodyText2,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  _showLevel(currentUser.currentExpLevel ?? 0),
                  const SizedBox(
                    width: 8,
                  ),
                  _showAccountType(currentUser.type),
                ],
              ),
              _showEXP(currentUser.totalExp),
            ],
          ),
        ),
      ],
    );
  }

  _showUCoin() {
    final User currentUser = context.watch<AuthState>().getUserModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${AppLocalizations.of(context)!.current_u_coin}:",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                truncateNumberToString(currentUser.totalUcoin),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                  letterSpacing: Theme.of(context).textTheme.headline4!.letterSpacing,
                  height: Theme.of(context).textTheme.headline4!.height,
                  color: $primaryColor,
                ),
              ),
            ),
            const Image(
              image: AssetImage($assetsImageUCoin),
              height: 30,
              width: 30,
            ),
          ],
        ),
      ],
    );
  }

  _body() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            _header(),
            const SizedBox(
              height: 16,
            ),
            _showUCoin(),
            const SizedBox(
              height: 18,
            ),
            const Line1(
              widthLine: 0.5,
            ),
            const SizedBox(
              height: 18,
            ),
            ButtonOutLineWithIcon(
              heightBtn: 23,
              colorBtn: $backgroundGreyColor,
              borderColorBtn: $backgroundGreyColor,
              paddingBtn: const EdgeInsets.symmetric(vertical: 18),
              widthBtn: double.infinity,
              onPressCallBack: () {
                Navigator.pushNamed(context, UrlRoutes.$editProfile);
              },
              textBtn: AppLocalizations.of(context)!.information,
              iconBtn: Icon(
                Icons.person_outline,
                color: Theme.of(context).textTheme.headline5!.color,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            ButtonOutLineWithIcon(
              heightBtn: 23,
              colorBtn: $backgroundGreyColor,
              borderColorBtn: $backgroundGreyColor,
              paddingBtn: const EdgeInsets.symmetric(vertical: 18),
              widthBtn: double.infinity,
              onPressCallBack: () {
                Navigator.pushNamed(context, UrlRoutes.$upsertPassword);
              },
              textBtn: AppLocalizations.of(context)!.change_password,
              iconBtn: Icon(
                Icons.lock_outline,
                color: Theme.of(context).textTheme.headline5!.color,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Line1(
              widthLine: 0.5,
            ),
            const SizedBox(
              height: 18,
            ),
            ButtonOutLineWithIcon(
              heightBtn: 23,
              colorBtn: $backgroundGreyColor,
              borderColorBtn: $backgroundGreyColor,
              paddingBtn: const EdgeInsets.symmetric(vertical: 18),
              widthBtn: double.infinity,
              onPressCallBack: () {
                Navigator.pushNamed(context, UrlRoutes.$affiliate);
              },
              textBtn: "Mã giới thiệu",
              iconBtn: Icon(
                Icons.account_tree_outlined,
                color: Theme.of(context).textTheme.headline5!.color,
              ),
            ),
            // const SizedBox(
            //   height: 18,
            // ),
            // ButtonOutLineWithIcon(
            //   heightBtn: 23,
            //   colorBtn: $backgroundGreyColor,
            //   borderColorBtn: $backgroundGreyColor,
            //   paddingBtn: const EdgeInsets.symmetric(vertical: 18),
            //   widthBtn: double.infinity,
            //   onPressCallBack: () {
            //     // Navigator.pushNamed(context, UrlRoutes.$editProfile);
            //   },
            //   textBtn: "Lịch sử giao dịch",
            //   iconBtn: Icon(
            //     Icons.assignment_outlined,
            //     color: Theme.of(context).textTheme.headline5!.color,
            //   ),
            // ),
            const SizedBox(
              height: 18,
            ),
            const Line1(
              widthLine: 0.5,
            ),
            const SizedBox(
              height: 18,
            ),
            ButtonOutLineWithIcon(
              heightBtn: 23,
              colorBtn: $backgroundGreyColor,
              borderColorBtn: $backgroundGreyColor,
              paddingBtn: const EdgeInsets.symmetric(vertical: 18),
              widthBtn: double.infinity,
              onPressCallBack: () {
                _onClickButtonLogout();
              },
              textBtn: AppLocalizations.of(context)!.logout,
              iconBtn: Icon(
                Icons.logout,
                color: Theme.of(context).textTheme.headline5!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: simpleAppBar(
        context: context,
        title: AppLocalizations.of(context)!.profile,
        actionsAppBar: [
          Obx((){
            if(_profileController.avatarState.value.path == $EMPTY){
              return const SizedBox(height: 0, width: 0,);
            }else {
              return TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).backgroundColor,
                ),
                onPressed: () {
                  _profileController.changeAvatar();
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: Theme.of(context).textTheme.headline5,
                ),
              );
            }
          })
        ],
      ),
      body: _body(),
    );
  }
}
