import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../constants/constants.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../../pages/auth/auth.dart';
import '../../../../../states/states.dart';
import '../../../../../widgets/widgets.dart';
import 'login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController _loginController;

  @override
  void initState() {
    _loginController = Get.put(LoginController(myContext: context, authState: context.read<AuthState>()));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<LoginController>();
  }

  _bottomBody() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.dont_have_an_account,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, UrlRoutes.$register,
                    arguments: const RegisterPage(
                      affiliateCode: "",
                    ));
              },
              child: Text(AppLocalizations.of(context)!.register),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Platform.isAndroid
            ? ButtonOutLineWithIcon(
                widthBtn: double.infinity,
                heightBtn: 24,
                textBtn: "Google",
                iconBtn: SvgPicture.asset(
                  $assetsSVGGoogle,
                ),
                onPressCallBack: () {
                  _loginController.loginGoogle();
                },
                paddingBtn: const EdgeInsets.symmetric(vertical: 16),
                borderColorBtn: $errorColor,
                textColor: $errorColor,
                onPrimaryBtn: $hoverColor,
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }

  _body() {
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "${AppLocalizations.of(context)!.login} uSchool",
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 24,
                ),
                const LoginForm(),
              ],
            ),
            _bottomBody(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: _body(),
      ),
    );
  }
}
