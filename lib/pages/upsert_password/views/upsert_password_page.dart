import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';
import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../layouts/layouts.dart';
import '../../pages.dart';

class UpsertPasswordPage extends StatefulWidget {
  const UpsertPasswordPage({Key? key}) : super(key: key);

  @override
  _UpsertPasswordPageState createState() => _UpsertPasswordPageState();
}

class _UpsertPasswordPageState extends State<UpsertPasswordPage> {
  late UpsertPasswordController _upsertPasswordController;

  final FocusNode _oldPasswordFN = FocusNode();
  final FocusNode _newPasswordFN = FocusNode();
  final FocusNode _confirmNewPasswordFN = FocusNode();

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();

  @override
  void initState() {
    _upsertPasswordController =
        Get.put(UpsertPasswordController(myContext: context, authState: context.read<AuthState>()));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<UpsertPasswordController>();
    super.dispose();
  }

  _textItem(String title) {
    return Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headline6),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            "*",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: $errorColor),
          ),
        ),
      ],
    );
  }

  _textError({required String text}) {
    if (text == $EMPTY) {
      text = AppLocalizations.of(context)!.not_be_empty;
    } else if (text == $NOT_EQUAL){
      text = AppLocalizations.of(context)!.invalid_confirm_password;
    } else if (text == $INVALID){
      text = AppLocalizations.of(context)!.password_invalid;
    }else {
      text = "";
    }
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

  bool _isShowOldPassword = true;
  bool _isShowNewPassword = true;
  bool _isShowConfirmNewPassword = true;

  _itemContainer({
    required String title,
    required String hintText,
    TextInputAction? textInputAction,
    TextInputType? type,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    Function? onEditingCompleteInput,
    required Function(String) onChange,
    required bool isShowPassword,
    required Function toggleShowPassword,
    required String error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _textItem(title),
        const SizedBox(height: 8),
        InputOutLine(
          isShow: isShowPassword,
          suffixIconInput: IconButton(
            onPressed: () {
              toggleShowPassword();
            },
            icon: isShowPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          hintTextInput: hintText,
          typeInput: type ?? TextInputType.text,
          actionInput: textInputAction ?? TextInputAction.next,
          textColor: Theme.of(context).textTheme.headline6!.color,
          backgroundColor: Theme.of(context).backgroundColor,
          colorBorderInput: $hoverColor,
          colorBorderFocusInput: $primaryColor,
          borderRadius: 12,
          textEditingController: textEditingController,
          focusInput: focusNode,
          onEditingCompleteInput: onEditingCompleteInput,
          onChange: (value) {
            onChange(value);
          },
        ),
        _textError(text: error),
      ],
    );
  }

  _formUpsertPassword() {
    final User myUser = context.read<AuthState>().getUserModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        myUser.isHasPassword ?
        Obx(
          () => _itemContainer(
            title: AppLocalizations.of(context)!.old_password,
            hintText: AppLocalizations.of(context)!.old_password,
            type: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            textEditingController: _oldPassword,
            focusNode: _oldPasswordFN,
            onEditingCompleteInput: () {
              FocusScope.of(context).requestFocus(_newPasswordFN);
            },
            onChange: (value) {
              _upsertPasswordController.checkErrorOldPassword(value);
            },
            isShowPassword: _isShowOldPassword,
            toggleShowPassword: () {
              setState(() {
                _isShowOldPassword = !_isShowOldPassword;
              });
            },
            error: _upsertPasswordController.errorOldPassword.value,
          ),
        ) : Text(AppLocalizations.of(context)!.dont_have_password, style: AppThemeLight.caption3),
        const SizedBox(height: 5),
        Obx(
          () => _itemContainer(
            title: AppLocalizations.of(context)!.new_password,
            hintText: AppLocalizations.of(context)!.new_password,
            type: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            textEditingController: _newPassword,
            focusNode: _newPasswordFN,
            onEditingCompleteInput: () {
              FocusScope.of(context).requestFocus(_confirmNewPasswordFN);
            },
            onChange: (value) {
              _upsertPasswordController.checkErrorNewPassword(value, _confirmNewPassword.text);
            },
            isShowPassword: _isShowNewPassword,
            toggleShowPassword: () {
              setState(() {
                _isShowNewPassword = !_isShowNewPassword;
              });
            },
            error: _upsertPasswordController.errorNewPassword.value,
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => _itemContainer(
            title: AppLocalizations.of(context)!.confirm_password,
            hintText: AppLocalizations.of(context)!.confirm_password,
            type: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            textEditingController: _confirmNewPassword,
            focusNode: _confirmNewPasswordFN,
            onChange: (value) {
              _upsertPasswordController.checkErrorConfirmNewPassword(value, _newPassword.text);
            },
            isShowPassword: _isShowConfirmNewPassword,
            toggleShowPassword: () {
              setState(() {
                _isShowConfirmNewPassword = !_isShowConfirmNewPassword;
              });
            },
            error: _upsertPasswordController.errorNewConfirmPassword.value,
          ),
        ),
        const SizedBox(height: 16),
        ButtonFullColor(
          textBtn: AppLocalizations.of(context)!.change_password,
          onPressCallBack: () {
            _upsertPasswordController.upsertPassword(
              oldPassword:  myUser.isHasPassword ? _oldPassword.text : $HAVE_PASSWORD,
              newPassword: _newPassword.text,
              confirmNewPassword: _confirmNewPassword.text,
            );
          },
          widthBtn: double.infinity,
          paddingBtn: const EdgeInsets.symmetric(vertical: 18),
        )
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
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _formUpsertPassword(),
          ),
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
        title: AppLocalizations.of(context)!.change_password,
      ),
      body: _body(),
    );
  }
}
