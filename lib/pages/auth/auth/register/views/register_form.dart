import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/constants.dart';
import '../../../../../pages/auth/auth.dart';
import '../../../../../states/states.dart';
import '../../../../../widgets/widgets.dart';

class RegisterForm extends StatefulWidget {
  final String? affiliateCode;

  const RegisterForm({
    Key? key,
    required this.affiliateCode,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isShowPassword = true;
  final FocusNode _passwordFocusNode = FocusNode();
  bool isShowConfirmPassword = true;
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  late RegisterController _registerController;

  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    _registerController = Get.put(RegisterController(myContext: context, authState: context.read<AuthState>()));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<RegisterController>();
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
            _registerController.checkErrorEmail(value);
          },
          prefixIconInput: const Icon(Icons.alternate_email_sharp),
          hintTextInput: "Email",
          colorBorderFocusInput: $primaryColor,
          typeInput: TextInputType.emailAddress,
          actionInput: TextInputAction.next,
          borderRadius: 10,
        ),
        Obx(
          () => _registerController.errorEmail.value.isEmpty
              ? _textError(text: "")
              : _registerController.errorEmail.value == $EMPTY
                  ? _textError(text: AppLocalizations.of(context)!.not_be_empty)
                  : _textError(text: AppLocalizations.of(context)!.email_invalid),
        ),
        const SizedBox(
          height: 3,
        ),
        InputOutLine(
          textEditingController: _password,
          onChange: (value) {
            _registerController.checkErrorPassword(value);
          },
          prefixIconInput: const Icon(Icons.lock),
          focusInput: _passwordFocusNode,
          onEditingCompleteInput: () {
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
          },
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
          () => _registerController.errorPassword.value.isEmpty
              ? _textError(text: "")
              : _registerController.errorPassword.value == $EMPTY
                  ? _textError(text: AppLocalizations.of(context)!.not_be_empty)
                  : _textError(text: AppLocalizations.of(context)!.password_invalid),
        ),
        const SizedBox(
          height: 3,
        ),
        InputOutLine(
          textEditingController: _confirmPassword,
          onChange: (value) {
            _registerController.checkErrorConfirmPassword(_password.text, value);
          },
          prefixIconInput: const Icon(Icons.lock),
          focusInput: _confirmPasswordFocusNode,
          suffixIconInput: IconButton(
            onPressed: () {
              setState(() {
                isShowConfirmPassword = !isShowConfirmPassword;
              });
            },
            icon: isShowConfirmPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          hintTextInput: AppLocalizations.of(context)!.confirm_password,
          colorBorderFocusInput: $primaryColor,
          typeInput: TextInputType.visiblePassword,
          actionInput: TextInputAction.next,
          isShow: isShowConfirmPassword,
          borderRadius: 10,
        ),
        Obx(
          () => _registerController.errorConfirmPassword.value.isEmpty
              ? _textError(text: "")
              : _textError(text: AppLocalizations.of(context)!.invalid_confirm_password),
        ),
        const SizedBox(
          height: 3,
        ),
        ButtonFullColor(
          textBtn: AppLocalizations.of(context)!.register,
          onPressCallBack: () {
            _registerController.register(
              email: _login.text,
              password: _password.text,
              confirmPassword: _confirmPassword.text,
              affiliateCode: widget.affiliateCode,
            );
          },
          paddingBtn: const EdgeInsets.symmetric(vertical: 18),
          widthBtn: double.infinity,
          radiusBtn: 10,
        )
      ],
    );
  }
}
