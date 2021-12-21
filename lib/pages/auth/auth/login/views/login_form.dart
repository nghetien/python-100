import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/constants.dart';
import '../../../../../pages/pages.dart';
import '../../../../../states/states.dart';
import '../../../../../widgets/widgets.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isShowPassword = true;

  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();

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

  _textError({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: $red500,
        fontFamily: Theme.of(context).textTheme.caption!.fontFamily,
        fontWeight: Theme.of(context).textTheme.caption!.fontWeight,
        fontSize: Theme.of(context).textTheme.caption!.fontSize,
        letterSpacing: Theme.of(context).textTheme.caption!.letterSpacing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputOutLine(
          textEditingController: _login,
          onChange: (value) {
            _loginController.checkErrorEmail(value);
          },
          prefixIconInput: const Icon(Icons.alternate_email_sharp),
          hintTextInput: "Email",
          colorBorderFocusInput: $primaryColor,
          typeInput: TextInputType.emailAddress,
          actionInput: TextInputAction.next,
          borderRadius: 10,
        ),
        Obx(
          () => _loginController.errorEmail.value.isEmpty
              ? _textError(text: "")
              : _loginController.errorEmail.value == $EMPTY
                  ? _textError(text: AppLocalizations.of(context)!.not_be_empty)
                  : _textError(text: AppLocalizations.of(context)!.email_invalid),
        ),
        const SizedBox(
          height: 3,
        ),
        InputOutLine(
          textEditingController: _password,
          onChange: (value) {
            _loginController.checkErrorPassword(value);
          },
          prefixIconInput: const Icon(Icons.lock),
          suffixIconInput: IconButton(
            onPressed: () {
              setState(() {
                isShowPassword = !isShowPassword;
              });
            },
            icon: isShowPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          hintTextInput: AppLocalizations.of(context)!.password,
          colorBorderFocusInput: $primaryColor,
          typeInput: TextInputType.visiblePassword,
          actionInput: TextInputAction.next,
          isShow: isShowPassword,
          borderRadius: 10,
        ),
        Obx(
          () => _loginController.errorPassword.value.isEmpty
              ? _textError(text: "")
              : _loginController.errorPassword.value == $EMPTY
                  ? _textError(text: AppLocalizations.of(context)!.not_be_empty)
                  : _textError(text: AppLocalizations.of(context)!.password_invalid),
        ),
        const SizedBox(
          height: 3,
        ),
        ButtonFullColor(
          textBtn: AppLocalizations.of(context)!.login,
          onPressCallBack: () {
            _loginController.login(email: _login.text, password: _password.text);
          },
          paddingBtn: const EdgeInsets.symmetric(vertical: 18),
          widthBtn: double.infinity,
          radiusBtn: 10,
        )
      ],
    );
  }
}
