import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../constants/constants.dart';
import '../../../../layouts/layouts.dart';
import '../../../../states/states.dart';
import '../../../../widgets/widgets.dart';
import '../../pages.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late EditProfileController _editProfileController;
  late FixedExtentScrollController _scrollController;

  final FocusNode _fullNameFN = FocusNode();
  final FocusNode _phoneNumberFN = FocusNode();
  final FocusNode _schoolFN = FocusNode();
  final FocusNode _clazzFN = FocusNode();
  final FocusNode _addressFN = FocusNode();
  final FocusNode _address2FN = FocusNode();
  final FocusNode _parentEmailFN = FocusNode();

  late final TextEditingController _fullName;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _school;
  late final TextEditingController _clazz;
  late final TextEditingController _address;
  late final TextEditingController _address2;
  late final TextEditingController _parentEmail;

  List<Map<String, String>> _listSelectGender() {
    return [
      {"key": $male, "value": AppLocalizations.of(context)!.male},
      {"key": $female, "value": AppLocalizations.of(context)!.female},
      {"key": $other, "value": AppLocalizations.of(context)!.other},
    ];
  }

  int _getInitGender(String valueCheck) {
    for (int index = 0; index < _listSelectGender().length; index++) {
      if (valueCheck == _listSelectGender()[index]["key"]) {
        return index;
      }
    }
    return 0;
  }

  @override
  void initState() {
    _editProfileController = Get.put(EditProfileController(context: context, auth: context.read<AuthState>()));
    _fullName = TextEditingController(text: _editProfileController.myProfile.value.fullName);
    _phoneNumber = TextEditingController(text: _editProfileController.myProfile.value.phoneNumber);
    _school = TextEditingController(text: _editProfileController.myProfile.value.school);
    _clazz = TextEditingController(text: _editProfileController.myProfile.value.clazz);
    _address = TextEditingController(text: _editProfileController.myProfile.value.addressLine);
    _address2 = TextEditingController(text: _editProfileController.myProfile.value.addressLine2);
    _parentEmail = TextEditingController(text: _editProfileController.myProfile.value.parentEmail);
    Future.delayed(Duration.zero, () {
      _scrollController =
          FixedExtentScrollController(initialItem: _getInitGender(_editProfileController.myProfile.value.gender));
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<EditProfileController>();
    _scrollController.dispose();
    super.dispose();
  }

  _textRequired({required String title, bool moreError = true}) {
    return Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headline6),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            !moreError ? "*" : "* (${AppLocalizations.of(context)!.not_be_empty})",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(color: $errorColor),
          ),
        ),
      ],
    );
  }

  _text(String text) {
    return Text(text, style: Theme.of(context).textTheme.headline6);
  }

  _infoItem({
    required Widget title,
    required String hintText,
    TextInputAction? textInputAction,
    TextInputType? type,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    Function? onEditingCompleteInput,
    required Function(String) onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        const SizedBox(height: 8),
        InputOutLine(
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
      ],
    );
  }

  _button({required String value, required Function onClick}) {
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: $hoverColor),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        primary: Theme.of(context).backgroundColor,
        onPrimary: $greyColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
        // shadowColor: shadowColorBtn,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline6!.color, fontWeight: FontWeight.w200, fontFamily: "Roboto"),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  _dobSelector() {
    return Obx(
      () {
        DateTime myDOB = DateTime.now();
        if (_editProfileController.myProfile.value.dob.isNotEmpty) {
          myDOB = DateTime.fromMillisecondsSinceEpoch(int.parse(_editProfileController.myProfile.value.dob) * 1000);
        }
        return Column(
          children: <Widget>[
            _textRequired(title: AppLocalizations.of(context)!.date_of_birth, moreError: false),
            const SizedBox(height: 8),
            _button(
              value: DateFormat("dd/MM/yyyy").format(myDOB),
              onClick: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          backgroundColor: Theme.of(context).backgroundColor,
                          initialDateTime: myDOB,
                          minimumYear: DateTime.now().year - 70,
                          maximumYear: DateTime.now().year,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (date) {
                            myDOB = date;
                          },
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: Text(AppLocalizations.of(context)!.done),
                      onPressed: () {
                        _editProfileController.handleChangeValueDOB(myDOB);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _genderSelector() {
    return Obx(
      () {
        int indexGender = _getInitGender(_editProfileController.myProfile.value.gender);
        return Column(
          children: <Widget>[
            _textRequired(title: AppLocalizations.of(context)!.gender, moreError: false),
            const SizedBox(height: 8),
            _button(
              value: _listSelectGender()[indexGender]["value"] ?? AppLocalizations.of(context)!.male,
              onClick: () {
                _scrollController.dispose();
                _scrollController = FixedExtentScrollController(initialItem: indexGender);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      SizedBox(
                        height: 150,
                        child: CupertinoPicker(
                          backgroundColor: Theme.of(context).backgroundColor,
                          scrollController: _scrollController,
                          itemExtent: 56,
                          children: _listSelectGender()
                              .map<Widget>((item) => Center(
                                    child: Text(
                                      item["value"] ?? "",
                                    ),
                                  ))
                              .toList(),
                          onSelectedItemChanged: (value) {
                            indexGender = value;
                          },
                        ),
                      )
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: Text(AppLocalizations.of(context)!.done),
                      onPressed: () {
                        _editProfileController
                            .handleChangeValueGender(_listSelectGender()[indexGender]["key"] ?? $male);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _infoRequired() {
    return Obx(
      () => Column(
        children: <Widget>[
          _infoItem(
            title: _textRequired(
                title: AppLocalizations.of(context)!.full_name,
                moreError: _editProfileController.errorFullName.value.isNotEmpty),
            hintText: AppLocalizations.of(context)!.full_name,
            textEditingController: _fullName,
            focusNode: _fullNameFN,
            onEditingCompleteInput: () {
              FocusScope.of(context).requestFocus(_phoneNumberFN);
            },
            onChange: (value) {
              _editProfileController.handleChangeValueFullName(value);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          _infoItem(
            title: _textRequired(
                title: AppLocalizations.of(context)!.phone_number,
                moreError: _editProfileController.errorPhoneNumber.value.isNotEmpty),
            hintText: AppLocalizations.of(context)!.phone_number,
            textEditingController: _phoneNumber,
            focusNode: _phoneNumberFN,
            onEditingCompleteInput: () {
              FocusScope.of(context).requestFocus(_schoolFN);
            },
            onChange: (value) {
              _editProfileController.handleChangeValuePhoneNumber(value);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _dobSelector(),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: _genderSelector(),
              ),
            ],
          )
        ],
      ),
    );
  }

  _infoBonus() {
    return Column(
      children: <Widget>[
        _infoItem(
          title: _text(AppLocalizations.of(context)!.school),
          hintText: AppLocalizations.of(context)!.school,
          textEditingController: _school,
          focusNode: _schoolFN,
          onEditingCompleteInput: () {
            FocusScope.of(context).requestFocus(_clazzFN);
          },
          onChange: (value) {
            _editProfileController.handleChangeValueBonus(mySchool: value);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        _infoItem(
          title: _text(AppLocalizations.of(context)!.clazz),
          hintText: AppLocalizations.of(context)!.clazz,
          textEditingController: _clazz,
          focusNode: _clazzFN,
          onEditingCompleteInput: () {
            FocusScope.of(context).requestFocus(_addressFN);
          },
          onChange: (value) {
            _editProfileController.handleChangeValueBonus(myClazz: value);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        _infoItem(
          title: _text(AppLocalizations.of(context)!.address_line),
          hintText: AppLocalizations.of(context)!.address_line,
          textEditingController: _address,
          focusNode: _addressFN,
          onEditingCompleteInput: () {
            FocusScope.of(context).requestFocus(_address2FN);
          },
          onChange: (value) {
            _editProfileController.handleChangeValueBonus(myAddress: value);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        _infoItem(
          title: _text(AppLocalizations.of(context)!.address_line_2),
          hintText: AppLocalizations.of(context)!.address_line_2,
          textEditingController: _address2,
          focusNode: _address2FN,
          onEditingCompleteInput: () {
            FocusScope.of(context).requestFocus(_parentEmailFN);
          },
          onChange: (value) {
            _editProfileController.handleChangeValueBonus(myAddress2: value);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        _infoItem(
          title: _text(AppLocalizations.of(context)!.parent_email),
          hintText: AppLocalizations.of(context)!.parent_email,
          textInputAction: TextInputAction.done,
          type: TextInputType.emailAddress,
          textEditingController: _parentEmail,
          focusNode: _parentEmailFN,
          onChange: (value) {
            _editProfileController.handleChangeValueBonus(myParentEmail: value);
          },
        ),
      ],
    );
  }

  _listInfoItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 24,
        ),
        Text(AppLocalizations.of(context)!.required_information, style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          height: 16,
        ),
        _infoRequired(),
        const SizedBox(
          height: 16,
        ),
        const Line1(
          widthLine: 0.5,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(AppLocalizations.of(context)!.additional_information, style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          height: 16,
        ),
        _infoBonus(),
        const SizedBox(
          height: 24,
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _listInfoItem(),
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
        title: AppLocalizations.of(context)!.edit_profile,
        actionsAppBar: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              if (_editProfileController.isError()) {
                _editProfileController.changeProfile();
              }
            },
            child: Obx(
              () => Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(
                  color: _editProfileController.isError()
                      ? Theme.of(context).textTheme.headline5!.color
                      : Theme.of(context).textTheme.bodyText2!.color,
                  fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline5!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                  letterSpacing: Theme.of(context).textTheme.headline5!.letterSpacing,
                  height: Theme.of(context).textTheme.headline5!.height,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }
}
